import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../../helper/word_match.dart';
import '../../../../routes/app_router.dart';
import '../../../plan/presentation/controllers/plan_controller.dart';
import '../../../test/presentation/controllers/test_providers.dart';
import '../../../vocab/data/models/vocab_models.dart';
import '../../../vocab/data/vocab_decks.dart';
import '../../../vocab/presentation/controllers/vocab_controller.dart';
import '../../../vocab/presentation/pages/vocab_form_sheet.dart';
import '../../../vocab/presentation/widgets/word_detail_sheet.dart';
import '../../data/models/dict_models.dart';
import '../controllers/dictionary_controller.dart';
import 'lookup_origin.dart';
import 'translation_view.dart';

/// Tên tiếng Việt của loại từ (mã trong dict_entries và partOfSpeech của API Anh–Anh).
String posLabel(String? pos) => switch (pos) {
  'n' || 'noun' => 'Danh từ',
  'v' || 'verb' => 'Động từ',
  'adj' || 'adjective' => 'Tính từ',
  'adv' || 'adverb' => 'Trạng từ',
  'pron' || 'pronoun' => 'Đại từ',
  'conj' || 'conjunction' => 'Liên từ',
  'prep' || 'preposition' => 'Giới từ',
  'interj' || 'interjection' => 'Thán từ',
  'num' || 'numeral' => 'Số từ',
  'affix' => 'Tiền tố / hậu tố',
  'idiom' => 'Thành ngữ',
  'phrase' => 'Cụm từ',
  'name' => 'Tên riêng',
  null || '' => 'Khác',
  final p => p,
};

enum _Tab { vi, en }

/// Số nghĩa hiện sẵn mỗi nhóm loại từ; còn lại bấm "Xem thêm".
const _collapsedSenses = 4;

/// 1 mục từ điển: từ + phát âm + lưu sổ từ, khớp kho ETS, nghĩa Anh–Việt / định nghĩa Anh–Anh.
/// Không tự cuộn – đặt trong ListView / SingleChildScrollView.
class DictEntryView extends ConsumerStatefulWidget {
  const DictEntryView({super.key, required this.query, required this.onLookup});

  /// Chữ cần tra (có thể là dạng biến đổi: "invoices").
  final String query;

  /// Tra 1 từ khác (từ đồng nghĩa, gợi ý gần đúng).
  final ValueChanged<String> onLookup;

  @override
  ConsumerState<DictEntryView> createState() => _DictEntryViewState();
}

class _DictEntryViewState extends ConsumerState<DictEntryView> {
  _Tab? _tab;

  @override
  void didUpdateWidget(DictEntryView old) {
    super.didUpdateWidget(old);
    if (old.query != widget.query) _tab = null;
  }

  @override
  Widget build(BuildContext context) {
    final lookup = ref.watch(dictLookupProvider(widget.query));
    return lookup.when(
      skipLoadingOnReload: true,
      loading: () => const DictSkeleton(),
      error: (e, _) => DictInlineError(
        message: AppException.from(e).message,
        onRetry: () => ref.invalidate(dictLookupProvider(widget.query)),
      ),
      data: (l) {
        final en = ref.watch(enEntriesProvider(l.word));
        final enEmpty = en.hasValue && en.value!.isEmpty;
        if (l.entry == null && enEmpty) {
          // Cụm nhiều từ không có trong từ điển → dịch cả cụm.
          return wordCount(widget.query) >= 2
              ? TranslationView(text: widget.query)
              : _NotFound(query: widget.query, onLookup: widget.onLookup);
        }
        final tab = _tab ?? (l.entry == null ? _Tab.en : _Tab.vi);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(lookup: l, en: en.value ?? const []),
            Gaps.v12,
            _BankMatches(query: widget.query),
            if (l.entry != null && !enEmpty) ...[
              SegmentedButton<_Tab>(
                segments: const [
                  ButtonSegment(value: _Tab.vi, label: Text('Anh – Việt')),
                  ButtonSegment(value: _Tab.en, label: Text('Anh – Anh')),
                ],
                selected: {tab},
                showSelectedIcon: false,
                onSelectionChanged: (s) => setState(() => _tab = s.first),
              ),
              Gaps.v16,
            ],
            if (l.entry == null)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.s16),
                child: AppBanner(
                  message: 'Chưa có nghĩa tiếng Việt cho từ này. Dưới đây là định nghĩa Anh – Anh.',
                ),
              ),
            if (tab == _Tab.vi && l.entry != null)
              _ViSenses(entry: l.entry!)
            else
              _EnSection(word: l.word, onLookup: widget.onLookup),
            Gaps.v16,
            Text(
              tab == _Tab.vi
                  ? 'Nguồn: Từ điển Anh – Việt mở (CC BY-SA 4.0)'
                  : 'Nguồn: Wiktionary qua dictionaryapi.dev (CC BY-SA)',
              style: context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        );
      },
    );
  }
}

// ---------- Tiêu đề: từ, IPA, nghe, lưu ----------

class _Header extends ConsumerWidget {
  const _Header({required this.lookup, required this.en});

  final DictLookup lookup;
  final List<EnEntry> en;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entry = lookup.entry;
    final word = lookup.word;
    final ipa = entry?.ipa ?? en.map((e) => e.phonetic).nonNulls.firstOrNull;
    final muted = context.textStyles.bodyMedium?.copyWith(color: context.colors.onSurfaceVariant);
    final isVariant = entry != null && entry.wordKey != WordMatch.normalize(lookup.query);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(word, style: context.textStyles.headlineSmall),
              if (ipa != null && ipa.isNotEmpty) Text(ipa, style: muted),
              if (isVariant) ...[
                Gaps.v4,
                Text('Dạng gốc của "${lookup.query}"', style: context.textStyles.bodySmall),
              ],
            ],
          ),
        ),
        _SpeakButton(text: word, audioUrl: en.audioUrl),
        Gaps.h8,
        _SaveButton(lookup: lookup, en: en),
      ],
    );
  }
}

/// Phát file phát âm thật (API Anh–Anh) nếu có, không thì đọc bằng giọng máy.
class _SpeakButton extends ConsumerStatefulWidget {
  const _SpeakButton({required this.text, this.audioUrl});

  final String text;
  final String? audioUrl;

  @override
  ConsumerState<_SpeakButton> createState() => _SpeakButtonState();
}

class _SpeakButtonState extends ConsumerState<_SpeakButton> {
  AudioPlayer? _player;

  Future<void> _play() async {
    final url = widget.audioUrl;
    if (url != null) {
      try {
        final player = _player ??= AudioPlayer();
        await player.setUrl(url);
        await player.play();
        return;
      } catch (_) {
        // Lỗi mạng / định dạng → đọc bằng giọng máy.
      }
    }
    await ref.read(ttsServiceProvider).speak(widget.text);
  }

  @override
  void dispose() {
    _player?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: 'Nghe phát âm',
    icon: const Icon(Icons.volume_up_rounded),
    onPressed: _play,
  );
}

/// Lưu / bỏ lưu từ trong Sổ từ của tôi. Lưu nghĩa đầu tiên; chọn nghĩa khác bằng nút ở từng nghĩa.
class _SaveButton extends ConsumerWidget {
  const _SaveButton({required this.lookup, required this.en});

  final DictLookup lookup;
  final List<EnEntry> en;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saved = ref.watch(notebookWordsProvider).value?[WordMatch.normalize(lookup.word)];
    final entry = lookup.entry;
    final firstEn = en.expand((e) => e.meanings).firstOrNull;
    final input = switch ((entry?.senses.firstOrNull, firstEn)) {
      (final s?, _) => _inputOf(lookup, s),
      (null, final m?) when m.definitions.isNotEmpty => VocabInput(
        word: lookup.word,
        ipa: en.map((e) => e.phonetic).nonNulls.firstOrNull,
        pos: m.partOfSpeech,
        meaning: m.definitions.first.definition,
        example: m.definitions.first.example,
        topic: ownTopic,
      ),
      _ => null,
    };
    return IconButton.filledTonal(
      tooltip: saved != null ? 'Bỏ khỏi sổ từ' : 'Lưu vào sổ từ',
      isSelected: saved != null,
      icon: const Icon(Icons.bookmark_add_outlined),
      selectedIcon: const Icon(Icons.bookmark_rounded),
      onPressed: switch ((saved, input)) {
        (final v?, _) => () => _removeFromNotebook(context, ref, v),
        (null, final i?) => () => _saveToNotebook(context, ref, i),
        _ => null,
      },
    );
  }
}

VocabInput _inputOf(DictLookup lookup, DictSense s) => VocabInput(
  word: lookup.word,
  ipa: lookup.entry?.ipa,
  pos: s.pos,
  meaning: s.meaning,
  example: s.example,
  topic: ownTopic,
);

Future<void> _saveToNotebook(BuildContext context, WidgetRef ref, VocabInput input) async {
  final messenger = ScaffoldMessenger.of(context);
  final router = GoRouter.of(context);
  input = _withOrigin(ref, input, LookupOriginScope.maybeOf(context));
  try {
    await ref.read(vocabListProvider.notifier).saveOwn(input);
    showAppSnackBarOn(
      messenger,
      'Đã lưu "${input.word}" vào Sổ từ của tôi',
      tone: AppTone.success,
      actionLabel: 'Xem',
      onAction: () => router.push(Routes.vocabWords(deck: const VocabDeck.topic(ownTopic).key)),
    );
  } catch (e) {
    showAppSnackBarOn(messenger, AppException.from(e).message, tone: AppTone.danger);
  }
}

/// Tra từ trong đề → câu ví dụ là câu chứa từ đó, nguồn "Tên đề · Part 7 · câu 147".
/// Bỏ qua khi người học đã chuyển sang tra từ khác không có trong câu.
VocabInput _withOrigin(WidgetRef ref, VocabInput input, LookupOrigin? origin) {
  if (origin == null || !ContextSentence.contains(origin.sentence, input.word)) return input;
  final title = switch (origin.testId) {
    final id? => ref.read(testListProvider).value?.where((t) => t.id == id).firstOrNull?.title,
    null => null,
  };
  final source = [?title, ?origin.label].join(' · ');
  return VocabInput(
    word: input.word,
    ipa: input.ipa,
    pos: input.pos,
    meaning: input.meaning,
    example: origin.sentence,
    topic: input.topic,
    source: source.isEmpty ? input.source : source,
    userId: input.userId,
  );
}

Future<void> _removeFromNotebook(BuildContext context, WidgetRef ref, VocabItem item) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await ref.read(vocabListProvider.notifier).delete(item.id);
    showAppSnackBarOn(messenger, 'Đã bỏ "${item.word}" khỏi sổ từ');
  } catch (e) {
    showAppSnackBarOn(messenger, AppException.from(e).message, tone: AppTone.danger);
  }
}

// ---------- Từ có trong kho ETS ----------

class _BankMatches extends ConsumerWidget {
  const _BankMatches({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matches = ref.watch(bankMatchesProvider(query));
    final isAdmin = ref.watch(myPlanProvider).value?.isAdmin ?? false;
    if (matches.isEmpty) {
      if (!isAdmin) return const SizedBox.shrink();
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.s8),
          child: TextButton.icon(
            icon: const Icon(Icons.add_rounded),
            label: const Text('Thêm vào kho từ ETS (admin)'),
            onPressed: () => showVocabForm(context, initialWord: WordMatch.normalize(query)),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s16),
      child: AppListGroup(
        children: [
          for (final v in matches)
            ListTile(
              leading: const IconBadge(icon: Icons.school_rounded, tone: AppTone.info),
              title: Text('${v.word} · ${v.meaning}', maxLines: 2, overflow: TextOverflow.ellipsis),
              subtitle: Text(v.source ?? 'Có trong kho từ ${topicLabel(v.topic)}'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => showWordDetail(context, v),
            ),
        ],
      ),
    );
  }
}

// ---------- Anh – Việt ----------

class _ViSenses extends ConsumerStatefulWidget {
  const _ViSenses({required this.entry});

  final DictEntry entry;

  @override
  ConsumerState<_ViSenses> createState() => _ViSensesState();
}

class _ViSensesState extends ConsumerState<_ViSenses> {
  final _expanded = <String?>{};

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;
    final saved = ref.watch(notebookWordsProvider).value?[entry.wordKey];
    final lookup = DictLookup(query: entry.wordKey, entry: entry);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final MapEntry(key: pos, value: senses) in entry.byPos.entries) ...[
          SectionHeader(title: posLabel(pos)),
          AppListGroup(
            children: [
              for (final (i, s) in senses.indexed.take(
                _expanded.contains(pos) ? senses.length : _collapsedSenses,
              ))
                _SenseTile(
                  index: i + 1,
                  meaning: s.meaning,
                  example: s.example,
                  saved: saved != null && saved.meaning == s.meaning,
                  onSave: () => saved != null && saved.meaning == s.meaning
                      ? _removeFromNotebook(context, ref, saved)
                      : _saveToNotebook(context, ref, _inputOf(lookup, s)),
                ),
              if (senses.length > _collapsedSenses && !_expanded.contains(pos))
                TextButton(
                  onPressed: () => setState(() => _expanded.add(pos)),
                  child: Text('Xem thêm ${senses.length - _collapsedSenses} nghĩa'),
                ),
            ],
          ),
          Gaps.v16,
        ],
      ],
    );
  }
}

class _SenseTile extends ConsumerWidget {
  const _SenseTile({
    required this.index,
    required this.meaning,
    this.example,
    this.saved,
    this.onSave,
  });

  final int index;
  final String meaning;
  final String? example;

  /// null = không có nút lưu (định nghĩa Anh–Anh).
  final bool? saved;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final muted = context.colors.onSurfaceVariant;
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(
        AppSpacing.s16,
        AppSpacing.s12,
        AppSpacing.s4,
        AppSpacing.s12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$index.', style: context.textStyles.titleMedium?.copyWith(color: muted)),
          Gaps.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(meaning, style: context.textStyles.bodyLarge),
                if (example case final ex? when ex.isNotEmpty) ...[
                  Gaps.v4,
                  InkWell(
                    borderRadius: AppRadius.brSm,
                    onTap: () => ref.read(ttsServiceProvider).speak(ex),
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: ex),
                          const TextSpan(text: '  '),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Icon(
                              Icons.volume_up_outlined,
                              size: AppSizes.iconXs,
                              color: muted,
                            ),
                          ),
                        ],
                      ),
                      style: context.textStyles.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                        color: muted,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (saved != null)
            IconButton(
              tooltip: saved! ? 'Bỏ nghĩa này khỏi sổ từ' : 'Lưu nghĩa này vào sổ từ',
              isSelected: saved,
              icon: const Icon(Icons.bookmark_border_rounded),
              selectedIcon: Icon(Icons.bookmark_rounded, color: context.colors.primary),
              onPressed: onSave,
            )
          else
            Gaps.h12,
        ],
      ),
    );
  }
}

// ---------- Anh – Anh ----------

class _EnSection extends ConsumerStatefulWidget {
  const _EnSection({required this.word, required this.onLookup});

  final String word;
  final ValueChanged<String> onLookup;

  @override
  ConsumerState<_EnSection> createState() => _EnSectionState();
}

class _EnSectionState extends ConsumerState<_EnSection> {
  final _expanded = <int>{};

  @override
  Widget build(BuildContext context) {
    return ref
        .watch(enEntriesProvider(widget.word))
        .when(
          loading: () => const DictSkeleton(),
          error: (e, _) => DictInlineError(
            message: AppException.from(e).message,
            onRetry: () => ref.invalidate(enEntriesProvider(widget.word)),
          ),
          data: (entries) {
            final meanings = entries.expand((e) => e.meanings).toList();
            if (meanings.isEmpty) {
              return const AppBanner(message: 'Chưa có định nghĩa Anh – Anh cho từ này.');
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (mi, m) in meanings.indexed) ...[
                  SectionHeader(title: '${posLabel(m.partOfSpeech)} · ${m.partOfSpeech}'),
                  AppListGroup(
                    children: [
                      for (final (i, d) in m.definitions.indexed.take(
                        _expanded.contains(mi) ? m.definitions.length : _collapsedSenses,
                      ))
                        _SenseTile(index: i + 1, meaning: d.definition, example: d.example),
                      if (m.definitions.length > _collapsedSenses && !_expanded.contains(mi))
                        TextButton(
                          onPressed: () => setState(() => _expanded.add(mi)),
                          child: Text('Xem thêm ${m.definitions.length - _collapsedSenses} nghĩa'),
                        ),
                    ],
                  ),
                  if ({...m.synonyms, for (final d in m.definitions) ...d.synonyms} case final syn
                      when syn.isNotEmpty) ...[
                    Gaps.v8,
                    Text('Đồng nghĩa', style: context.textStyles.labelLarge),
                    Gaps.v4,
                    Wrap(
                      spacing: AppSpacing.s8,
                      runSpacing: AppSpacing.s8,
                      children: [
                        for (final s in syn.take(8))
                          ActionChip(label: Text(s), onPressed: () => widget.onLookup(s)),
                      ],
                    ),
                  ],
                  Gaps.v16,
                ],
              ],
            );
          },
        );
  }
}

// ---------- Trạng thái ----------

class DictSkeleton extends StatelessWidget {
  const DictSkeleton({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppSkeletonCard(height: AppSizes.ringMd),
      Gaps.v12,
      AppSkeletonCard(height: AppSizes.ringLg),
    ],
  );
}

class DictInlineError extends StatelessWidget {
  const DictInlineError({super.key, required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AppBanner(message: message, tone: AppTone.danger),
      Gaps.v8,
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: TextButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Thử lại'),
        ),
      ),
    ],
  );
}

/// Không có cả Anh–Việt lẫn Anh–Anh → gợi ý từ gần đúng.
class _NotFound extends ConsumerWidget {
  const _NotFound({required this.query, required this.onLookup});

  final String query;
  final ValueChanged<String> onLookup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final near = ref.watch(dictSuggestionsProvider(query)).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Gaps.v24,
        AppEmptyView(
          icon: Icons.search_off_rounded,
          message: 'Không tìm thấy "$query".\nKiểm tra chính tả hoặc thử dạng gốc của từ.',
        ),
        if (near.isNotEmpty) ...[
          Gaps.v16,
          Text('Có phải bạn muốn tìm', style: context.textStyles.labelLarge),
          Gaps.v8,
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              for (final s in near.take(8))
                ActionChip(label: Text(s.word), onPressed: () => onLookup(s.word)),
            ],
          ),
        ],
      ],
    );
  }
}
