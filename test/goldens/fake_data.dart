// Dữ liệu & repository giả để chụp màn hình (golden) không cần mạng.
import 'package:bami_toeic/helper/srs.dart';
import 'package:bami_toeic/module/auth/data/models/session.dart';
import 'package:bami_toeic/module/auth/presentation/controllers/auth_controller.dart';
import 'package:bami_toeic/module/test/data/models/test_models.dart';
import 'package:bami_toeic/module/test/data/test_repository.dart';
import 'package:bami_toeic/module/vocab/data/models/vocab_models.dart';
import 'package:bami_toeic/module/vocab/data/vocab_repository.dart';

final now = DateTime(2026, 10, 8, 9, 30);

/// Lịch ôn từ vựng phải tính theo NGÀY THẬT (app so với DateTime.now()), nếu không golden đổi mỗi ngày.
final _today = DateTime.now();

class FakeAuth extends AuthController {
  @override
  Future<Session?> build() async => const Session(
    accessToken: 'a',
    refreshToken: 'r',
    expiresAt: 4102444800,
    user: AuthUser(id: 'u1', email: 'me@example.com'),
  );
}

final _tests = [
  const TestSummary(id: 't1', title: 'ETS 2024 – Test 1', source: 'ETS 2024', questionCount: 200),
  const TestSummary(id: 't2', title: 'ETS 2024 – Test 2', source: 'ETS 2024', questionCount: 200),
  const TestSummary(
    id: 't3',
    title: 'Mini Test 01 (mẫu)',
    source: 'Bami TOEIC',
    description: 'Đề mẫu ngắn để kiểm tra app: Part 5, 6, 7.',
    questionCount: 12,
  ),
];

Question _q(int n, int part, String content, List<String> opts, String ans, [String? exp]) =>
    Question(
      id: 'q$n',
      part: part,
      number: n,
      content: content,
      options: opts,
      answer: ans,
      explanation: exp,
    );

final _groups = [
  QuestionGroup(
    id: 'g1',
    part: 5,
    orderNo: 1,
    questions: [
      _q(
        101,
        5,
        'All employees are required to submit their expense reports ------- the end of the month.',
        ['by', 'until', 'since', 'during'],
        'A',
        '"by + mốc thời gian" = chậm nhất là. "until" diễn tả hành động kéo dài liên tục.',
      ),
    ],
  ),
  QuestionGroup(
    id: 'g2',
    part: 5,
    orderNo: 2,
    questions: [
      _q(102, 5, 'The new software has made the billing process significantly more -------.', [
        'efficiency',
        'efficient',
        'efficiently',
        'efficiencies',
      ], 'B'),
    ],
  ),
  QuestionGroup(
    id: 'g3',
    part: 7,
    orderNo: 3,
    passage:
        'GREENLEAF CATERING\n\nNow booking for summer events! Orders for 50 guests or more '
        'receive a 10% discount. Free delivery within the city limits.',
    questions: [
      _q(147, 7, 'What is being advertised?', [
        'A restaurant opening',
        'A food service for events',
        'A cooking class',
        'A grocery delivery app',
      ], 'B'),
      _q(148, 7, 'How can customers receive a discount?', [
        'By ordering online',
        'By ordering five days in advance',
        'By ordering for a large group',
        'By picking up the order',
      ], 'C'),
    ],
  ),
];

final _attempts = [
  Attempt(
    id: 'a1',
    testId: 't1',
    testTitle: 'ETS 2024 – Test 1',
    mode: 'exam',
    parts: const [1, 2, 3, 4, 5, 6, 7],
    startedAt: now.subtract(const Duration(hours: 2)),
    finishedAt: now,
    totalQuestions: 200,
    listeningCorrect: 82,
    readingCorrect: 71,
  ),
  Attempt(
    id: 'a2',
    testId: 't3',
    testTitle: 'Mini Test 01 (mẫu)',
    mode: 'practice',
    parts: const [5, 7],
    startedAt: now.subtract(const Duration(days: 1, minutes: 12)),
    finishedAt: now.subtract(const Duration(days: 1)),
    totalQuestions: 4,
    listeningCorrect: 0,
    readingCorrect: 3,
  ),
];

class FakeTestRepository implements TestRepository {
  @override
  Future<List<TestSummary>> fetchTests() async => _tests;

  @override
  Future<TestDetail> fetchTest(String id) async => TestDetail(
    summary: _tests.firstWhere((t) => t.id == id, orElse: () => _tests.last),
    groups: _groups,
  );

  @override
  Future<List<Attempt>> fetchAttempts() async => _attempts;

  @override
  Future<AttemptResult> fetchResult(String attemptId) async => AttemptResult(
    attempt: _attempts.last,
    groups: _groups,
    answers: const {'q101': 'A', 'q102': 'C', 'q147': 'B', 'q148': null},
  );

  @override
  Future<List<PartStat>> fetchPartStats() async => const [
    PartStat(part: 1, total: 60, correct: 52),
    PartStat(part: 2, total: 250, correct: 180),
    PartStat(part: 3, total: 390, correct: 260),
    PartStat(part: 4, total: 300, correct: 190),
    PartStat(part: 5, total: 300, correct: 230),
    PartStat(part: 6, total: 160, correct: 98),
    PartStat(part: 7, total: 540, correct: 270),
  ];

  @override
  Future<void> deleteAttempt(String id) async {}

  @override
  Future<Attempt> submitAttempt({
    required String testId,
    required String mode,
    required List<int> parts,
    required DateTime startedAt,
    required List<Question> questions,
    required Map<String, String> answers,
  }) async => _attempts.first;
}

VocabItem _v(
  String id,
  String word,
  String ipa,
  String pos,
  String meaning,
  String topic, {
  String? ex,
  String? exVi,
  VocabReview? r,
}) => VocabItem(
  id: id,
  word: word,
  ipa: ipa,
  pos: pos,
  meaning: meaning,
  topic: topic,
  example: ex,
  exampleMeaning: exVi,
  reviews: r == null ? const [] : [r],
);

final _vocab = [
  _v(
    'v1',
    'budget',
    '/ˈbʌdʒɪt/',
    'n',
    'ngân sách',
    'Finance',
    r: VocabReview(
      ease: 2.5,
      intervalDays: 6,
      repetitions: 2,
      dueAt: _today.add(const Duration(days: 2, hours: 12)),
    ),
  ),
  _v(
    'v2',
    'invoice',
    '/ˈɪnvɔɪs/',
    'n',
    'hoá đơn',
    'Finance',
    ex: 'Please send the invoice to the accounting department.',
    exVi: 'Vui lòng gửi hoá đơn tới phòng kế toán.',
  ),
  _v(
    'v3',
    'itinerary',
    '/aɪˈtɪnəreri/',
    'n',
    'lịch trình chuyến đi',
    'Travel',
    r: VocabReview(
      ease: 2.3,
      intervalDays: 1,
      repetitions: 1,
      dueAt: _today.subtract(const Duration(hours: 2)),
    ),
  ),
  _v('v4', 'postpone', '/poʊstˈpoʊn/', 'v', 'hoãn lại', 'Office'),
  _v('v5', 'reimburse', '/ˌriːɪmˈbɜːrs/', 'v', 'hoàn trả (chi phí)', 'Finance'),
  _v('v6', 'qualified', '/ˈkwɑːlɪfaɪd/', 'adj', 'đủ năng lực, trình độ', 'Hiring'),
];

class FakeVocabRepository implements VocabRepository {
  @override
  Future<List<VocabItem>> fetchAll() async => _vocab;

  @override
  Future<void> save(VocabInput input, {String? id}) async {}

  @override
  Future<void> delete(String id) async {}

  @override
  Future<void> saveReview({
    required String userId,
    required String vocabId,
    required SrsState state,
  }) async {}
}
