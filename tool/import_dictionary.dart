// Import từ điển Anh–Việt (file SQLite) vào bảng dict_entries (migration 008) – upsert theo
// word_key, chạy lại an toàn. Cần tài khoản admin (bảng app_admins) và lệnh `sqlite3` trên máy.
//
//   dart run tool/import_dictionary.dart <dictionary_en_vi.db> [--dry-run]
//
// Nguồn: https://github.com/skypediacode/english-vietnamese-dictionary (CC BY-SA 4.0),
// tải file dictionary_en_vi.db về rồi truyền đường dẫn vào đây.
// Đăng nhập như import_test.dart (TOEIC_EMAIL / TOEIC_PASSWORD hoặc hỏi khi chạy).
import 'dart:convert';
import 'dart:io';

import 'package:supabase/supabase.dart';

/// Mã loại từ của nguồn → mã ngắn app dùng (giống cột vocab.pos).
const _pos = {
  'N': 'n',
  'noun': 'n',
  'V': 'v',
  'verb': 'v',
  'A': 'adj',
  'adj': 'adj',
  'D': 'adv',
  'adv': 'adv',
  'P': 'pron',
  'pron': 'pron',
  'C': 'conj',
  'E': 'prep',
  'O': 'interj',
  'M': 'num',
  'Z': 'affix',
  'idiom': 'idiom',
  'S': 'phrase',
  'name': 'name',
};

// IPA ưu tiên giọng Mỹ (TOEIC đọc nhiều giọng Mỹ), không có thì lấy bản bất kỳ.
const _query = '''
select w.word,
  (select p.ipa from pronunciations p where p.word_id = w.id
   order by case p.region when 'NAmE' then 0 when 'US' then 1 when 'General-American' then 2
                          when '' then 3 else 4 end, p.id limit 1) as ipa,
  d.pos, d.definition, wd.example
from word_definitions wd
join words w on w.id = wd.word_id
join definitions d on d.id = wd.definition_id
order by w.id, wd.id
''';

Future<void> main(List<String> args) async {
  final path = args.where((a) => !a.startsWith('--')).firstOrNull;
  if (path == null) {
    stderr.writeln(
      'Cách dùng: dart run tool/import_dictionary.dart <dictionary_en_vi.db> [--dry-run]',
    );
    exit(64);
  }
  final res = await Process.run('sqlite3', ['-json', path, _query], stdoutEncoding: utf8);
  if (res.exitCode != 0) {
    stderr.writeln('❌ Không đọc được $path: ${res.stderr}');
    exit(66);
  }
  final raw = (jsonDecode(res.stdout as String) as List).cast<Map<String, dynamic>>();

  // Gộp các mục chỉ khác hoa/thường (English / english) thành 1 dòng, ưu tiên dạng chữ thường.
  final rows = <String, Map<String, dynamic>>{};
  for (final r in raw) {
    final word = (r['word'] as String).trim().replaceAll(RegExp(r'\s+'), ' ');
    final meaning = (r['definition'] as String?)?.trim() ?? '';
    if (word.isEmpty || meaning.isEmpty) continue;
    final key = word.toLowerCase();
    final row = rows.putIfAbsent(
      key,
      () => {'word_key': key, 'word': word, 'ipa': null, 'senses': <Map<String, String>>[]},
    );
    if (word == key) row['word'] = word;
    row['ipa'] ??= _clean(r['ipa']);
    final senses = row['senses'] as List<Map<String, String>>;
    if (senses.any((s) => s['m'] == meaning)) continue;
    senses.add({'p': ?_pos[r['pos']], 'm': meaning, 'e': ?_clean(r['example'])});
  }
  final senseCount = rows.values.fold<int>(0, (n, r) => n + (r['senses'] as List).length);
  stdout.writeln('${rows.length} mục · $senseCount nghĩa (từ ${raw.length} dòng nguồn)');
  if (args.contains('--dry-run')) {
    for (final w in ['invoice', 'book', 'run out of']) {
      stdout.writeln(jsonEncode(rows[w]));
    }
    exit(0);
  }

  final env = jsonDecode(File('env.json').readAsStringSync()) as Map<String, dynamic>;
  final db = SupabaseClient(env['SUPABASE_URL'] as String, env['SUPABASE_KEY'] as String);
  await db.auth.signInWithPassword(
    email: Platform.environment['TOEIC_EMAIL'] ?? _ask('Email: '),
    password: Platform.environment['TOEIC_PASSWORD'] ?? _ask('Mật khẩu: ', hidden: true),
  );
  try {
    final list = rows.values.toList();
    for (var i = 0; i < list.length; i += 1000) {
      final chunk = list.sublist(i, (i + 1000).clamp(0, list.length));
      await db.from('dict_entries').upsert(chunk, onConflict: 'word_key');
      stdout.write('\r  ↑ ${i + chunk.length}/${list.length}');
    }
    stdout.writeln('\n✅ Đã import ${list.length} mục từ điển');
  } finally {
    await db.dispose();
  }
  exit(0);
}

String? _clean(Object? v) => switch (v) {
  final String s when s.trim().isNotEmpty => s.trim(),
  _ => null,
};

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
