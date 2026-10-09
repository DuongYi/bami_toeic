// Import bộ từ vựng (mảng JSON) vào bảng vocab – upsert theo (word, topic), chạy lại an toàn.
//
//   dart run tool/import_vocab.dart content/raw/ets2026/vocab/ets2026_all.json [--dry-run]
//
// Mỗi phần tử: {word, ipa?, pos?, meaning, example?, example_meaning?, topic?}; trường khác bị bỏ qua.
// Đăng nhập như import_test.dart (TOEIC_EMAIL / TOEIC_PASSWORD hoặc hỏi khi chạy).
import 'dart:convert';
import 'dart:io';

import 'package:supabase/supabase.dart';

const _columns = ['word', 'ipa', 'pos', 'meaning', 'example', 'example_meaning', 'topic'];

Future<void> main(List<String> args) async {
  final path = args.where((a) => !a.startsWith('--')).firstOrNull;
  if (path == null) {
    stderr.writeln('Cách dùng: dart run tool/import_vocab.dart <file.json> [--dry-run]');
    exit(64);
  }
  final raw = (jsonDecode(File(path).readAsStringSync()) as List).cast<Map<String, dynamic>>();
  final rows = <String, Map<String, dynamic>>{};
  for (final (i, v) in raw.indexed) {
    final word = (v['word'] as String?)?.trim() ?? '';
    final meaning = (v['meaning'] as String?)?.trim() ?? '';
    if (word.isEmpty || meaning.isEmpty) {
      stderr.writeln('❌ Phần tử #$i thiếu word/meaning');
      exit(65);
    }
    final row = {
      for (final c in _columns)
        if (v[c] case final String s when s.trim().isNotEmpty) c: s.trim(),
    };
    row['topic'] ??= 'General';
    // Trùng (word, topic) trong cùng 1 lô làm upsert lỗi → giữ bản đầu.
    rows.putIfAbsent('${row['word']}|${row['topic']}', () => row);
  }
  final topics = <String, int>{};
  for (final r in rows.values) {
    topics.update(r['topic'] as String, (n) => n + 1, ifAbsent: () => 1);
  }
  stdout.writeln(
    '${rows.length} từ · ${topics.length} chủ đề: '
    '${(topics.entries.toList()..sort((a, b) => b.value - a.value)).map((e) => '${e.key} ${e.value}').join(', ')}',
  );
  if (args.contains('--dry-run')) exit(0);

  final env = jsonDecode(File('env.json').readAsStringSync()) as Map<String, dynamic>;
  final db = SupabaseClient(env['SUPABASE_URL'] as String, env['SUPABASE_KEY'] as String);
  await db.auth.signInWithPassword(
    email: Platform.environment['TOEIC_EMAIL'] ?? _ask('Email: '),
    password: Platform.environment['TOEIC_PASSWORD'] ?? _ask('Mật khẩu: ', hidden: true),
  );
  try {
    final list = rows.values.toList();
    for (var i = 0; i < list.length; i += 200) {
      final chunk = list.sublist(i, (i + 200).clamp(0, list.length));
      await db.from('vocab').upsert(chunk, onConflict: 'word,topic');
      stdout.writeln('  ↑ ${i + chunk.length}/${list.length}');
    }
    stdout.writeln('✅ Đã import ${list.length} từ');
  } finally {
    await db.dispose();
  }
  exit(0);
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
