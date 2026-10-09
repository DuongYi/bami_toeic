// Đồng bộ PHẦN CHỮ của 1 đề đã import (câu hỏi, đáp án, giải thích, đoạn văn, transcript)
// từ test.json lên Supabase – không upload lại audio/ảnh, không đổi id (giữ lịch sử làm bài).
//
//   dart run tool/sync_text.dart content/tests/ets2026_test01 [--dry-run] [--images]
//
// --images: upload đè ảnh (jpg/png) cùng đường dẫn cũ trên Storage → link không đổi, không đụng audio.
//
// Đăng nhập như import_test.dart (TOEIC_EMAIL / TOEIC_PASSWORD hoặc hỏi khi chạy).
import 'dart:convert';
import 'dart:io';

import 'package:supabase/supabase.dart';

Future<void> main(List<String> args) async {
  final dirs = args.where((a) => !a.startsWith('--')).toList();
  if (dirs.isEmpty) {
    stderr.writeln('Cách dùng: dart run tool/sync_text.dart <thư-mục-đề>... [--dry-run]');
    exit(64);
  }
  final dryRun = args.contains('--dry-run');
  final images = args.contains('--images');
  final env = jsonDecode(File('env.json').readAsStringSync()) as Map<String, dynamic>;
  final db = SupabaseClient(env['SUPABASE_URL'] as String, env['SUPABASE_KEY'] as String);
  await db.auth.signInWithPassword(
    email: Platform.environment['TOEIC_EMAIL'] ?? _ask('Email: '),
    password: Platform.environment['TOEIC_PASSWORD'] ?? _ask('Mật khẩu: ', hidden: true),
  );
  try {
    for (final dir in dirs) {
      await _sync(db, dir, dryRun);
      if (images) await _uploadImages(db, dir, dryRun);
    }
  } finally {
    await db.dispose();
  }
  exit(0);
}

Future<void> _sync(SupabaseClient db, String dir, bool dryRun) async {
  final data = jsonDecode(File('$dir/test.json').readAsStringSync()) as Map<String, dynamic>;
  final title = data['title'] as String;
  final test = await db.from('tests').select('id').eq('title', title).maybeSingle();
  if (test == null) {
    stderr.writeln('❌ "$title" chưa có trên Supabase – import trước bằng tool/import_test.dart');
    return;
  }
  final testId = test['id'] as String;
  final rows = await db
      .from('questions')
      .select('id, number, group_id, content, options, explanation, tags')
      .eq('test_id', testId);
  final byNumber = {for (final r in rows) r['number'] as int: r};
  final groupRows = await db
      .from('question_groups')
      .select('id, passage, transcript')
      .eq('test_id', testId);
  final groupById = {for (final g in groupRows) g['id'] as String: g};

  var qChanged = 0, gChanged = 0;
  for (final g in (data['groups'] as List).cast<Map<String, dynamic>>()) {
    final qs = (g['questions'] as List).cast<Map<String, dynamic>>();
    final first = byNumber[qs.first['number']];
    if (first == null) continue;
    final remoteGroup = groupById[first['group_id']];
    final gPatch = <String, dynamic>{};
    for (final k in ['passage', 'transcript']) {
      if (g[k] != remoteGroup?[k]) gPatch[k] = g[k];
    }
    if (gPatch.isNotEmpty) {
      gChanged++;
      if (!dryRun) {
        await db.from('question_groups').update(gPatch).eq('id', first['group_id'] as String);
      }
    }
    for (final q in qs) {
      final remote = byNumber[q['number']];
      if (remote == null) continue;
      final patch = <String, dynamic>{};
      if (q['content'] != remote['content']) patch['content'] = q['content'];
      if (jsonEncode(q['options'] ?? []) != jsonEncode(remote['options'] ?? [])) {
        patch['options'] = q['options'] ?? [];
      }
      if (q['explanation'] != remote['explanation']) patch['explanation'] = q['explanation'];
      if (q['tags'] != null && jsonEncode(q['tags']) != jsonEncode(remote['tags'] ?? [])) {
        patch['tags'] = q['tags'];
      }
      if (patch.isEmpty) continue;
      qChanged++;
      if (!dryRun) await db.from('questions').update(patch).eq('id', remote['id'] as String);
    }
  }
  stdout.writeln('${dryRun ? '🔍 (thử) ' : '✅ '}"$title": cập nhật $qChanged câu, $gChanged nhóm');
}

Future<void> _uploadImages(SupabaseClient db, String dir, bool dryRun) async {
  final data = jsonDecode(File('$dir/test.json').readAsStringSync()) as Map<String, dynamic>;
  final folder = Directory(dir).uri.pathSegments.where((s) => s.isNotEmpty).last;
  var n = 0;
  for (final g in (data['groups'] as List).cast<Map<String, dynamic>>()) {
    final path = g['image'] as String?;
    if (path == null || path.startsWith('http')) continue;
    final file = File('$dir/$path');
    if (!file.existsSync()) continue;
    n++;
    if (!dryRun) {
      // cùng key với import_test.dart → public URL giữ nguyên
      await db.storage
          .from('media')
          .upload('tests/$folder/$path', file, fileOptions: const FileOptions(upsert: true));
    }
  }
  stdout.writeln('${dryRun ? '🔍 (thử) ' : '🖼  '}"${data['title']}": upload lại $n ảnh');
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
