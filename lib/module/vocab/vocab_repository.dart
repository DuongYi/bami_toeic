import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/supabase.dart';
import '../../helper/srs.dart';

class VocabItem {
  VocabItem({
    required this.id,
    required this.word,
    this.ipa,
    this.pos,
    required this.meaning,
    this.example,
    this.exampleMeaning,
    required this.topic,
    this.audioUrl,
    this.review,
  });

  factory VocabItem.fromJson(Map<String, dynamic> j) {
    final reviews = j['vocab_reviews'] as List? ?? const [];
    final r = reviews.isEmpty ? null : reviews.first as Map<String, dynamic>;
    return VocabItem(
      id: j['id'] as String,
      word: j['word'] as String,
      ipa: j['ipa'] as String?,
      pos: j['pos'] as String?,
      meaning: j['meaning'] as String,
      example: j['example'] as String?,
      exampleMeaning: j['example_meaning'] as String?,
      topic: j['topic'] as String,
      audioUrl: j['audio_url'] as String?,
      review: r == null
          ? null
          : SrsState(
              ease: (r['ease'] as num).toDouble(),
              intervalDays: r['interval_days'] as int,
              repetitions: r['repetitions'] as int,
              due: DateTime.parse(r['due_at'] as String).toLocal(),
            ),
    );
  }

  final String id;
  final String word;
  final String? ipa;
  final String? pos;
  final String meaning;
  final String? example;
  final String? exampleMeaning;
  final String topic;
  final String? audioUrl;

  /// null = từ mới, chưa học
  final SrsState? review;

  bool get isNew => review == null;
  bool isDue(DateTime now) => review != null && !review!.dueAt.isAfter(now);
}

final vocabRepositoryProvider = Provider<VocabRepository>(
  (ref) => VocabRepository(ref.watch(supabaseProvider)),
);

final vocabListProvider = FutureProvider.autoDispose<List<VocabItem>>(
  (ref) => ref.watch(vocabRepositoryProvider).fetchAll(),
);

class VocabRepository {
  VocabRepository(this._db);

  final SupabaseClient _db;

  Future<List<VocabItem>> fetchAll() async {
    final rows = await _db.from('vocab').select('*, vocab_reviews(*)').order('word');
    return rows.map(VocabItem.fromJson).toList();
  }

  Future<void> save({
    String? id,
    required String word,
    String? ipa,
    String? pos,
    required String meaning,
    String? example,
    String? exampleMeaning,
    required String topic,
  }) async {
    String? clean(String? s) => (s == null || s.trim().isEmpty) ? null : s.trim();
    final data = {
      'word': word.trim(),
      'ipa': clean(ipa),
      'pos': clean(pos),
      'meaning': meaning.trim(),
      'example': clean(example),
      'example_meaning': clean(exampleMeaning),
      'topic': clean(topic) ?? 'General',
    };
    if (id == null) {
      await _db.from('vocab').insert(data);
    } else {
      await _db.from('vocab').update(data).eq('id', id);
    }
  }

  Future<void> delete(String id) => _db.from('vocab').delete().eq('id', id);

  Future<void> saveReview(String vocabId, SrsState s) async {
    await _db.from('vocab_reviews').upsert({
      'user_id': _db.auth.currentUser!.id,
      'vocab_id': vocabId,
      'ease': s.ease,
      'interval_days': s.intervalDays,
      'repetitions': s.repetitions,
      'due_at': s.dueAt.toUtc().toIso8601String(),
      'last_reviewed_at': DateTime.now().toUtc().toIso8601String(),
    }, onConflict: 'user_id,vocab_id');
  }
}
