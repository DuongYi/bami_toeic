// Import một đề TOEIC từ thư mục chứa test.json (+ file audio/ảnh) lên Supabase.
//
//   dart run tool/import_test.dart content/tests/sample_test [--replace] [--dry-run]
//
// --dry-run: chỉ kiểm tra test.json và file media, không đăng nhập / không ghi gì lên Supabase.
//
// Đăng nhập bằng tài khoản của bạn (biến môi trường TOEIC_EMAIL / TOEIC_PASSWORD,
// hoặc nhập khi được hỏi). URL và key đọc từ env.json.
// Xem định dạng test.json trong content/README.md.
import 'dart:convert';
import 'dart:io';

import 'package:supabase/supabase.dart';

const bucket = 'media';

Future<void> main(List<String> args) async {
  final dirArg = args.where((a) => !a.startsWith('--')).firstOrNull;
  if (dirArg == null) {
    stderr.writeln('Cách dùng: dart run tool/import_test.dart <thư-mục-đề> [--replace]');
    exit(64);
  }
  final replace = args.contains('--replace');
  final dryRun = args.contains('--dry-run');
  final dir = Directory(dirArg);
  final testFile = File('${dir.path}/test.json');
  if (!testFile.existsSync()) _fail('Không thấy ${testFile.path}');

  final data = jsonDecode(testFile.readAsStringSync()) as Map<String, dynamic>;
  final groups = (data['groups'] as List).cast<Map<String, dynamic>>();
  _validate(data, groups);
  for (final g in groups) {
    for (final key in ['audio', 'image']) {
      final path = g[key] as String?;
      if (path != null && !path.startsWith('http') && !_isSafeRelative(path)) {
        _fail('Đường dẫn media không hợp lệ (phải nằm trong thư mục đề): $path');
      }
      if (path != null && !path.startsWith('http') && !File('${dir.path}/$path').existsSync()) {
        _fail('Thiếu file media: ${dir.path}/$path');
      }
    }
  }
  if (dryRun) {
    final count = groups.fold<int>(0, (s, g) => s + (g['questions'] as List).length);
    final parts = groups.map((g) => g['part']).toSet().toList()..sort();
    stdout.writeln(
      '✅ Hợp lệ: "${data['title']}" · ${groups.length} nhóm · $count câu · Part $parts',
    );
    exit(0);
  }

  final env = jsonDecode(File('env.json').readAsStringSync()) as Map<String, dynamic>;
  final db = SupabaseClient(env['SUPABASE_URL'] as String, env['SUPABASE_KEY'] as String);
  await db.auth.signInWithPassword(
    email: Platform.environment['TOEIC_EMAIL'] ?? _ask('Email: '),
    password: Platform.environment['TOEIC_PASSWORD'] ?? _ask('Mật khẩu: ', hidden: true),
  );

  final title = data['title'] as String;
  final existing = await db.from('tests').select('id').eq('title', title).maybeSingle();
  if (existing != null) {
    if (!replace) _fail('Đề "$title" đã tồn tại. Thêm --replace để ghi đè.');
    await db.from('tests').delete().eq('id', existing['id'] as String);
    stdout.writeln('Đã xoá đề cũ "$title".');
  }

  // Upload media
  final folder = dir.uri.pathSegments.where((s) => s.isNotEmpty).last;
  final uploaded = <String, String>{};
  Future<String?> media(String? path) async {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    if (uploaded.containsKey(path)) return uploaded[path];
    final file = File('${dir.path}/$path');
    if (!file.existsSync()) _fail('Thiếu file media: ${file.path}');
    final key = 'tests/$folder/$path';
    await db.storage.from(bucket).upload(key, file, fileOptions: const FileOptions(upsert: true));
    stdout.writeln('  ↑ $path');
    return uploaded[path] = db.storage.from(bucket).getPublicUrl(key);
  }

  final test = await db
      .from('tests')
      .insert({
        'title': title,
        'source': data['source'],
        'description': data['description'],
        if (data['score_table'] != null) 'score_table': data['score_table'],
      })
      .select('id')
      .single();
  final testId = test['id'] as String;

  try {
    final questionRows = <Map<String, dynamic>>[];
    for (final (i, g) in groups.indexed) {
      final group = await db
          .from('question_groups')
          .insert({
            'test_id': testId,
            'part': g['part'],
            'order_no': i + 1,
            'passage': g['passage'],
            'transcript': g['transcript'],
            'audio_url': await media(g['audio'] as String?),
            'image_url': await media(g['image'] as String?),
          })
          .select('id')
          .single();
      for (final q in (g['questions'] as List).cast<Map<String, dynamic>>()) {
        questionRows.add({
          'test_id': testId,
          'group_id': group['id'],
          'part': g['part'],
          'number': q['number'],
          'content': q['content'],
          'options': q['options'] ?? [],
          'answer': (q['answer'] as String).toUpperCase(),
          'explanation': q['explanation'],
          if (q['tags'] != null) 'tags': q['tags'],
        });
      }
    }
    await db.from('questions').insert(questionRows);
    stdout.writeln('✅ Đã import "$title": ${groups.length} nhóm, ${questionRows.length} câu.');
  } catch (e) {
    await db.from('tests').delete().eq('id', testId); // không để lại đề dở dang
    _fail('Import lỗi, đã rollback: $e');
  } finally {
    await db.dispose();
  }
  exit(0);
}

void _validate(Map<String, dynamic> data, List<Map<String, dynamic>> groups) {
  if (data['title'] is! String) _fail('Thiếu "title"');
  final numbers = <int>{};
  for (final g in groups) {
    final part = g['part'];
    if (part is! int || part < 1 || part > 7) _fail('Part không hợp lệ: $part');
    for (final q in (g['questions'] as List).cast<Map<String, dynamic>>()) {
      final n = q['number'];
      if (n is! int || !numbers.add(n)) _fail('Số câu thiếu hoặc trùng: $n');
      if (!RegExp(r'^[A-Da-d]$').hasMatch('${q['answer']}')) _fail('Câu $n: answer phải là A-D');
    }
  }
}

/// Chỉ cho phép đường dẫn tương đối nằm trong thư mục đề (không tuyệt đối, không `..`).
bool _isSafeRelative(String path) {
  if (path.isEmpty || path.startsWith('/') || path.startsWith(r'\') || path.contains(':')) {
    return false;
  }
  return !path.split(RegExp(r'[/\\]')).contains('..');
}

String _ask(String prompt, {bool hidden = false}) {
  stdout.write(prompt);
  if (hidden) stdin.echoMode = false;
  final v = stdin.readLineSync() ?? '';
  if (hidden) {
    stdin.echoMode = true;
    stdout.writeln();
  }
  return v.trim();
}

Never _fail(String msg) {
  stderr.writeln('❌ $msg');
  exit(1);
}
