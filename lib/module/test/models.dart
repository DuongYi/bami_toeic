class TestSummary {
  TestSummary({
    required this.id,
    required this.title,
    this.source,
    this.description,
    required this.questionCount,
  });

  factory TestSummary.fromJson(Map<String, dynamic> j) => TestSummary(
    id: j['id'] as String,
    title: j['title'] as String,
    source: j['source'] as String?,
    description: j['description'] as String?,
    questionCount: ((j['questions'] as List?)?.firstOrNull?['count'] as int?) ?? 0,
  );

  final String id;
  final String title;
  final String? source;
  final String? description;
  final int questionCount;
}

class Question {
  Question({
    required this.id,
    required this.part,
    required this.number,
    this.content,
    required this.options,
    required this.answer,
    this.explanation,
  });

  factory Question.fromJson(Map<String, dynamic> j) => Question(
    id: j['id'] as String,
    part: j['part'] as int,
    number: j['number'] as int,
    content: j['content'] as String?,
    options: (j['options'] as List? ?? const []).map((e) => '$e').toList(),
    answer: j['answer'] as String,
    explanation: j['explanation'] as String?,
  );

  final String id;
  final int part;
  final int number;
  final String? content;
  final List<String> options;
  final String answer;
  final String? explanation;

  /// Part 2 có 3 lựa chọn, các part khác 4. Nếu đề có ghi options thì theo số options.
  List<String> get letters {
    final n = options.isNotEmpty ? options.length : (part == 2 ? 3 : 4);
    return List.generate(n, (i) => String.fromCharCode(65 + i));
  }

  String optionText(int i) => i < options.length ? options[i] : '';
}

class QuestionGroup {
  QuestionGroup({
    required this.id,
    required this.part,
    required this.orderNo,
    this.passage,
    this.imageUrl,
    this.audioUrl,
    this.transcript,
    required this.questions,
  });

  factory QuestionGroup.fromJson(Map<String, dynamic> j) => QuestionGroup(
    id: j['id'] as String,
    part: j['part'] as int,
    orderNo: j['order_no'] as int,
    passage: j['passage'] as String?,
    imageUrl: j['image_url'] as String?,
    audioUrl: j['audio_url'] as String?,
    transcript: j['transcript'] as String?,
    questions:
        (j['questions'] as List).map((e) => Question.fromJson(e as Map<String, dynamic>)).toList()
          ..sort((a, b) => a.number.compareTo(b.number)),
  );

  final String id;
  final int part;
  final int orderNo;
  final String? passage;
  final String? imageUrl;
  final String? audioUrl;
  final String? transcript;
  final List<Question> questions;
}

class TestDetail {
  TestDetail({required this.summary, required this.groups});

  final TestSummary summary;
  final List<QuestionGroup> groups;

  Map<int, int> get questionsPerPart {
    final m = <int, int>{};
    for (final g in groups) {
      m[g.part] = (m[g.part] ?? 0) + g.questions.length;
    }
    return m;
  }
}

class Attempt {
  Attempt({
    required this.id,
    required this.testId,
    required this.testTitle,
    required this.mode,
    required this.parts,
    required this.startedAt,
    required this.finishedAt,
    required this.totalQuestions,
    required this.listeningCorrect,
    required this.readingCorrect,
  });

  factory Attempt.fromJson(Map<String, dynamic> j) => Attempt(
    id: j['id'] as String,
    testId: j['test_id'] as String,
    testTitle: (j['tests'] as Map?)?['title'] as String? ?? '',
    mode: j['mode'] as String,
    parts: (j['parts'] as List).cast<int>(),
    startedAt: DateTime.parse(j['started_at'] as String).toLocal(),
    finishedAt: DateTime.parse(j['finished_at'] as String).toLocal(),
    totalQuestions: j['total_questions'] as int,
    listeningCorrect: j['listening_correct'] as int,
    readingCorrect: j['reading_correct'] as int,
  );

  final String id;
  final String testId;
  final String testTitle;
  final String mode;
  final List<int> parts;
  final DateTime startedAt;
  final DateTime finishedAt;
  final int totalQuestions;
  final int listeningCorrect;
  final int readingCorrect;

  int get correct => listeningCorrect + readingCorrect;
  bool get isFullTest => parts.length == 7 && totalQuestions == 200;
  Duration get duration => finishedAt.difference(startedAt);
}

class PartStat {
  PartStat({required this.part, required this.total, required this.correct});

  factory PartStat.fromJson(Map<String, dynamic> j) =>
      PartStat(part: j['part'] as int, total: j['total'] as int, correct: j['correct'] as int);

  final int part;
  final int total;
  final int correct;

  double get accuracy => total == 0 ? 0 : correct / total;
}
