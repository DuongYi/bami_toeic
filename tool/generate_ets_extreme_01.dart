// Master generator cho bộ đề ETS Extreme Hard Test 01 (200 Questions - Target 990)
//
// Cách chạy:
//   dart run tool/generate_ets_extreme_01.dart
//
import 'dart:convert';
import 'dart:io';

import 'data_part1_part2.dart';
import 'data_part3_part4.dart';
import 'data_part5_part6.dart';
import 'data_part7.dart';

void main() async {
  final outDir = Directory('content/tests/ets_extreme_01');
  if (!outDir.existsSync()) {
    outDir.createSync(recursive: true);
  }

  stdout.writeln('🚀 Bắt đầu lắp ráp bộ đề ETS Extreme Hard Test 01 (200 câu)...');

  final p1 = buildPart1();
  final p2 = buildPart2();
  final p3 = buildPart3();
  final p4 = buildPart4();
  final p5 = buildPart5();
  final p6 = buildPart6();
  final p7 = buildPart7();

  final allGroups = <Map<String, dynamic>>[
    ...p1,
    ...p2,
    ...p3,
    ...p4,
    ...p5,
    ...p6,
    ...p7,
  ];

  stdout.writeln('📊 Thống kê nhóm câu hỏi:');
  stdout.writeln('   Part 1: ${p1.length} nhóm (${_countQs(p1)} câu)');
  stdout.writeln('   Part 2: ${p2.length} nhóm (${_countQs(p2)} câu)');
  stdout.writeln('   Part 3: ${p3.length} nhóm (${_countQs(p3)} câu)');
  stdout.writeln('   Part 4: ${p4.length} nhóm (${_countQs(p4)} câu)');
  stdout.writeln('   Part 5: ${p5.length} nhóm (${_countQs(p5)} câu)');
  stdout.writeln('   Part 6: ${p6.length} nhóm (${_countQs(p6)} câu)');
  stdout.writeln('   Part 7: ${p7.length} nhóm (${_countQs(p7)} câu)');

  final totalQuestions = _countQs(allGroups);
  stdout.writeln('👉 Tổng cộng: ${allGroups.length} nhóm · $totalQuestions câu hỏi.');
  if (totalQuestions != 200) {
    stderr.writeln('❌ LỖI: Tổng số câu không phải là 200 (hiện là $totalQuestions)!');
    exit(1);
  }

  // 1. Tạo file test.json
  final testData = {
    'title': 'ETS Extreme Hard Test 01 (Target 990)',
    'source': 'Bami TOEIC Extreme Series',
    'description':
        'Bộ đề thi 200 câu siêu khó (Target 850-990) gồm 100 câu Listening và 100 câu Reading với đầy đủ bẫy ngữ pháp C1, câu hỏi hàm ý gián tiếp và 3 bài đoạn ba Triple Passages suy luận phức hợp.',
    'is_free': false,
    'groups': allGroups,
  };

  final jsonFile = File('${outDir.path}/test.json');
  jsonFile.writeAsStringSync(const JsonEncoder.withIndent('  ').convert(testData));
  stdout.writeln('💾 Đã lưu test.json vào: ${jsonFile.path}');

  // 2. Tạo Audio cho Part 1, 2, 3, 4 bằng macOS `say`
  stdout.writeln('🎙️ Bắt đầu sinh audio cho Listening (Part 1 - Part 4)...');
  int audioGenerated = 0;
  for (final g in allGroups) {
    final audioName = g['audio'] as String?;
    final speech = g['_speech'] as String?;
    if (audioName != null && speech != null) {
      final audioFile = File('${outDir.path}/$audioName');
      if (!audioFile.existsSync() || audioFile.lengthSync() == 0) {
        final result = Process.runSync('say', [
          '-v',
          'Samantha',
          '-r',
          '175',
          speech,
          '-o',
          audioFile.path,
        ]);
        if (result.exitCode != 0) {
          // Fallback to default voice if Samantha is unavailable
          Process.runSync('say', [
            speech,
            '-o',
            audioFile.path,
          ]);
        }
        audioGenerated++;
        stdout.writeln('   🔊 Tạo audio: $audioName');
      }
    }
  }
  stdout.writeln('✅ Hoàn thành sinh audio ($audioGenerated files mới).');

  // 3. Sinh file SQL Seeding
  stdout.writeln('📝 Đang sinh master SQL file: supabase/seed_ets_extreme_01.sql ...');
  _generateSqlSeed(testData, allGroups);
  stdout.writeln('🎉 HOÀN TẤT TOÀN BỘ!');
}

int _countQs(List<Map<String, dynamic>> groups) {
  return groups.fold<int>(0, (s, g) => s + (g['questions'] as List).length);
}

void _generateSqlSeed(Map<String, dynamic> testData, List<Map<String, dynamic>> groups) {
  final sqlFile = File('supabase/seed_ets_extreme_01.sql');
  final sb = StringBuffer();

  final testTitle = testData['title'] as String;
  final testSource = testData['source'] as String;
  final testDesc = testData['description'] as String;

  sb.writeln('-- =============================================================================');
  sb.writeln('-- BAMI TOEIC - MASTER SEED: ETS Extreme Hard Test 01 (200 Questions - Target 990)');
  sb.writeln('-- Dành cho Supabase Dashboard -> SQL Editor -> Run');
  sb.writeln('-- =============================================================================');
  sb.writeln('BEGIN;\n');

  sb.writeln('-- 1. Xóa dữ liệu cũ nếu đã tồn tại');
  sb.writeln("DELETE FROM public.tests WHERE title = '${_escape(testTitle)}';\n");

  sb.writeln('DO \$\$');
  sb.writeln('DECLARE');
  sb.writeln('  v_test_id uuid;');
  sb.writeln('  v_group_id uuid;');
  sb.writeln('BEGIN');

  sb.writeln('''  -- Insert test
  INSERT INTO public.tests (title, source, description, is_free)
  VALUES (
    '${_escape(testTitle)}',
    '${_escape(testSource)}',
    '${_escape(testDesc)}',
    false
  )
  RETURNING id INTO v_test_id;
''');

  for (int i = 0; i < groups.length; i++) {
    final g = groups[i];
    final orderNo = i + 1;
    final part = g['part'];
    final passage = g['passage'] != null ? "'${_escape(g['passage'])}'" : 'NULL';
    final transcript = g['transcript'] != null ? "'${_escape(g['transcript'])}'" : 'NULL';
    final audioUrl = g['audio'] != null
        ? "'tests/ets_extreme_01/${g['audio']}'"
        : 'NULL';
    final imageUrl = g['image'] != null
        ? "'tests/ets_extreme_01/${g['image']}'"
        : 'NULL';

    sb.writeln('''  -- Group #$orderNo (Part $part)
  INSERT INTO public.question_groups (test_id, part, order_no, passage, transcript, audio_url, image_url)
  VALUES (v_test_id, $part, $orderNo, $passage, $transcript, $audioUrl, $imageUrl)
  RETURNING id INTO v_group_id;
''');

    final qs = (g['questions'] as List).cast<Map<String, dynamic>>();
    sb.writeln('  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags) VALUES');

    final qRows = <String>[];
    for (final q in qs) {
      final num = q['number'];
      final content = "'${_escape(q['content'])}'";
      final optsJson = "'${_escape(jsonEncode(q['options'] ?? []))}'::jsonb";
      final ans = "'${(q['answer'] as String).toUpperCase()}'";
      final exp = "'${_escape(q['explanation'] ?? '')}'";
      final tagsJson = "'${_escape(jsonEncode(q['tags'] ?? []))}'::jsonb";

      qRows.add("    (v_test_id, v_group_id, $part, $num, $content, $optsJson, $ans, $exp, $tagsJson)");
    }
    sb.writeln('${qRows.join(',\n')};\n');
  }

  sb.writeln('END \$\$;\n');
  sb.writeln('COMMIT;\n');

  sb.writeln('-- =============================================================================');
  sb.writeln('-- KIỂM TRA TÍNH TOÀN VẸN CỦA ĐỀ THI VỪA INSERT');
  sb.writeln('-- =============================================================================');
  sb.writeln('''
SELECT 
  t.title,
  COUNT(DISTINCT qg.id) AS total_groups,
  COUNT(q.id) AS total_questions,
  MIN(q.number) AS min_question_num,
  MAX(q.number) AS max_question_num
FROM public.tests t
LEFT JOIN public.question_groups qg ON qg.test_id = t.id
LEFT JOIN public.questions q ON q.test_id = t.id
WHERE t.title = '${_escape(testTitle)}'
GROUP BY t.id, t.title;
''');

  sqlFile.writeAsStringSync(sb.toString());
  stdout.writeln('💾 Đã lưu master SQL vào: ${sqlFile.path} (${(sqlFile.lengthSync() / 1024).toStringAsFixed(1)} KB)');
}

String _escape(String str) {
  return str.replaceAll("'", "''");
}
