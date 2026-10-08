import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_models.freezed.dart';
part 'test_models.g.dart';

// ---------- Đọc từ API ----------

@freezed
abstract class TestSummary with _$TestSummary {
  const factory TestSummary({
    required String id,
    required String title,
    String? source,
    String? description,

    /// Từ `questions(count)` → `[{"count": n}]`
    @JsonKey(name: 'questions', fromJson: _readCount, includeToJson: false)
    @Default(0)
    int questionCount,
  }) = _TestSummary;

  factory TestSummary.fromJson(Map<String, dynamic> json) => _$TestSummaryFromJson(json);
}

int _readCount(Object? v) =>
    v is List && v.isNotEmpty ? ((v.first as Map)['count'] as num).toInt() : 0;

@freezed
abstract class Question with _$Question {
  const Question._();

  const factory Question({
    required String id,
    required int part,
    required int number,
    String? content,
    @Default(<String>[]) List<String> options,
    required String answer,
    String? explanation,
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  /// Part 2 có 3 lựa chọn, các part khác 4. Nếu đề có ghi options thì theo số options.
  List<String> get letters {
    final n = options.isNotEmpty ? options.length : (part == 2 ? 3 : 4);
    return List.generate(n, (i) => String.fromCharCode(65 + i));
  }

  String optionText(int i) => i < options.length ? options[i] : '';
}

@freezed
abstract class QuestionGroup with _$QuestionGroup {
  const factory QuestionGroup({
    required String id,
    required int part,
    required int orderNo,
    String? passage,
    String? imageUrl,
    String? audioUrl,
    String? transcript,
    @Default(<Question>[]) List<Question> questions,
  }) = _QuestionGroup;

  factory QuestionGroup.fromJson(Map<String, dynamic> json) => _$QuestionGroupFromJson(json);
}

@freezed
abstract class Attempt with _$Attempt {
  const Attempt._();

  const factory Attempt({
    required String id,
    required String testId,

    /// Từ `tests(title)` → `{"title": "..."}`
    @JsonKey(name: 'tests', fromJson: _readTitle, includeToJson: false)
    @Default('')
    String testTitle,
    required String mode,
    required List<int> parts,
    required DateTime startedAt,
    required DateTime finishedAt,
    required int totalQuestions,
    required int listeningCorrect,
    required int readingCorrect,
  }) = _Attempt;

  factory Attempt.fromJson(Map<String, dynamic> json) => _$AttemptFromJson(json);

  int get correct => listeningCorrect + readingCorrect;
  bool get isFullTest => parts.length == 7 && totalQuestions == 200;
  bool get isExam => mode == 'exam';
  Duration get duration => finishedAt.difference(startedAt);
}

String _readTitle(Object? v) => v is Map ? (v['title'] as String? ?? '') : '';

@freezed
abstract class AttemptAnswer with _$AttemptAnswer {
  const factory AttemptAnswer({required String questionId, String? chosen}) = _AttemptAnswer;

  factory AttemptAnswer.fromJson(Map<String, dynamic> json) => _$AttemptAnswerFromJson(json);
}

@freezed
abstract class PartStat with _$PartStat {
  const PartStat._();

  const factory PartStat({required int part, required int total, required int correct}) = _PartStat;

  factory PartStat.fromJson(Map<String, dynamic> json) => _$PartStatFromJson(json);

  double get accuracy => total == 0 ? 0 : correct / total;
}

// ---------- Gửi lên API ----------

@JsonSerializable(createFactory: false)
class AttemptInsert {
  const AttemptInsert({
    required this.testId,
    required this.mode,
    required this.parts,
    required this.startedAt,
    required this.totalQuestions,
    required this.listeningCorrect,
    required this.readingCorrect,
  });

  final String testId;
  final String mode;
  final List<int> parts;

  /// Phải là UTC để Postgres (timestamptz) hiểu đúng.
  final DateTime startedAt;
  final int totalQuestions;
  final int listeningCorrect;
  final int readingCorrect;

  Map<String, dynamic> toJson() => _$AttemptInsertToJson(this);
}

@JsonSerializable(createFactory: false)
class AttemptAnswerInsert {
  const AttemptAnswerInsert({
    required this.attemptId,
    required this.questionId,
    required this.chosen,
    required this.isCorrect,
  });

  final String attemptId;
  final String questionId;
  final String? chosen;
  final bool isCorrect;

  Map<String, dynamic> toJson() => _$AttemptAnswerInsertToJson(this);
}

// ---------- Domain (không serialize) ----------

@freezed
abstract class TestDetail with _$TestDetail {
  const TestDetail._();

  const factory TestDetail({required TestSummary summary, required List<QuestionGroup> groups}) =
      _TestDetail;

  Map<int, int> get questionsPerPart {
    final m = <int, int>{};
    for (final g in groups) {
      m[g.part] = (m[g.part] ?? 0) + g.questions.length;
    }
    return m;
  }
}

@freezed
abstract class AttemptResult with _$AttemptResult {
  const AttemptResult._();

  const factory AttemptResult({
    required Attempt attempt,
    required List<QuestionGroup> groups,

    /// question_id → đáp án đã chọn (null = bỏ trống)
    required Map<String, String?> answers,
  }) = _AttemptResult;

  List<Question> get questions => [for (final g in groups) ...g.questions];
  bool isCorrect(Question q) => answers[q.id] == q.answer;
}
