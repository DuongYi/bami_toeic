import 'dart:convert';
import 'dart:io';

String escapeSql(String text) {
  return text.replaceAll("'", "''");
}

String arrayToSql(List<dynamic>? list) {
  if (list == null || list.isEmpty) return 'ARRAY[]::text[]';
  final items = list.map((e) => "'${escapeSql(e.toString())}'").join(', ');
  return 'ARRAY[$items]::text[]';
}

void main() {
  final buffer = StringBuffer();
  buffer.writeln('-- =================================================================');
  buffer.writeln('-- BAMI TOEIC: 5 BỘ ĐỀ QUICK TEST 15 PHÚT (SEED DATA)');
  buffer.writeln('-- Hướng dẫn: Dán toàn bộ file này vào Supabase Dashboard -> SQL Editor -> Run');
  buffer.writeln('-- =================================================================');
  buffer.writeln();
  buffer.writeln('BEGIN;');
  buffer.writeln();
  buffer.writeln('-- Xóa dữ liệu cũ nếu đã từng import để đảm bảo tính idempotent');
  buffer.writeln("DELETE FROM public.tests WHERE title LIKE 'Quick Test 15m - Đề %';");
  buffer.writeln();

  for (int i = 1; i <= 5; i++) {
    final testDir = 'content/tests/quick15_test0$i';
    final testFile = File('$testDir/test.json');
    if (!testFile.existsSync()) {
      print('File not found: ${testFile.path}');
      continue;
    }

    final data = jsonDecode(testFile.readAsStringSync()) as Map<String, dynamic>;
    final title = data['title'] as String;
    final source = data['source'] as String?;
    final description = data['description'] as String?;
    final isFree = data['is_free'] as bool? ?? true;
    final groups = data['groups'] as List<dynamic>;

    buffer.writeln('-- -------------------------------------------------------------');
    buffer.writeln('-- BỘ ĐỀ: $title');
    buffer.writeln('-- -------------------------------------------------------------');
    buffer.writeln('DO \$\$');
    buffer.writeln('DECLARE');
    buffer.writeln('  v_test_id uuid;');
    buffer.writeln('  v_group_id uuid;');
    buffer.writeln('BEGIN');
    buffer.writeln('  -- 1. Tạo test');
    buffer.writeln('  INSERT INTO public.tests (title, source, description, is_free)');
    buffer.writeln('  VALUES (');
    buffer.writeln("    '${escapeSql(title)}',");
    buffer.writeln(source != null ? "    '${escapeSql(source)}'," : '    NULL,');
    buffer.writeln(description != null ? "    '${escapeSql(description)}'," : '    NULL,');
    buffer.writeln('    $isFree');
    buffer.writeln('  )');
    buffer.writeln('  RETURNING id INTO v_test_id;');
    buffer.writeln();

    int orderNo = 1;
    for (final group in groups) {
      final part = group['part'] as int;
      final passage = group['passage'] as String?;
      final audioUrl = group['audio_url'] as String?;
      final imageUrl = group['image_url'] as String?;
      final questions = group['questions'] as List<dynamic>;

      buffer.writeln('  -- Tạo Group #$orderNo (Part $part)');
      buffer.writeln('  INSERT INTO public.question_groups (test_id, part, order_no, passage, audio_url, image_url)');
      buffer.writeln('  VALUES (');
      buffer.writeln('    v_test_id,');
      buffer.writeln('    $part,');
      buffer.writeln('    $orderNo,');
      buffer.writeln(passage != null ? "    '${escapeSql(passage)}'," : '    NULL,');
      buffer.writeln(audioUrl != null ? "    '${escapeSql(audioUrl)}'," : '    NULL,');
      buffer.writeln(imageUrl != null ? "    '${escapeSql(imageUrl)}'" : '    NULL');
      buffer.writeln('  )');
      buffer.writeln('  RETURNING id INTO v_group_id;');
      buffer.writeln();

      for (final q in questions) {
        final number = q['number'] as int;
        final content = (q['content'] as String?) ?? 'Choose the best option for blank [$number].';
        final options = jsonEncode(q['options']);
        final answer = q['answer'] as String;
        final explanation = q['explanation'] as String?;
        final tags = q['tags'] as List<dynamic>?;

        buffer.writeln('  -- Question $number');
        buffer.writeln('  INSERT INTO public.questions (test_id, group_id, part, number, content, options, answer, explanation, tags)');
        buffer.writeln('  VALUES (');
        buffer.writeln('    v_test_id,');
        buffer.writeln('    v_group_id,');
        buffer.writeln('    $part,');
        buffer.writeln('    $number,');
        buffer.writeln("    '${escapeSql(content)}',");
        buffer.writeln("    '${escapeSql(options)}'::jsonb,");
        buffer.writeln("    '${escapeSql(answer)}',");
        buffer.writeln(explanation != null ? "    '${escapeSql(explanation)}'," : '    NULL,');
        buffer.writeln('    ${arrayToSql(tags)}');
        buffer.writeln('  );');
      }
      buffer.writeln();
      orderNo++;
    }

    buffer.writeln('END \$\$;');
    buffer.writeln();
  }

  buffer.writeln('COMMIT;');
  buffer.writeln();
  buffer.writeln('-- Kiểm tra lại số lượng câu hỏi và bộ đề đã thêm:');
  buffer.writeln("SELECT t.title, COUNT(q.id) AS total_questions");
  buffer.writeln("FROM public.tests t");
  buffer.writeln("LEFT JOIN public.questions q ON q.test_id = t.id");
  buffer.writeln("WHERE t.title LIKE 'Quick Test 15m - Đề %'");
  buffer.writeln("GROUP BY t.id, t.title");
  buffer.writeln("ORDER BY t.title;");

  File('supabase/seed_quick15_tests.sql').writeAsStringSync(buffer.toString());
  print('✅ Generated supabase/seed_quick15_tests.sql successfully!');
}
