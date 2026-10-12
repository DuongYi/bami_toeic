import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/word_match.dart';
import '../../../../routes/app_router.dart';
import '../../../vocab/data/vocab_decks.dart';
import '../../data/models/dict_models.dart';
import '../controllers/dictionary_controller.dart';
import 'dict_entry_view.dart';
import 'translation_view.dart';

const _debounce = Duration(milliseconds: 250); // ds-ignore: chờ gõ xong, không phải animation

/// Ô tra + nội dung: chưa gõ → tra gần đây & sổ từ; đang gõ → gợi ý; chọn từ → mục từ;
/// câu dài (> [maxLookupWords] từ) → bản dịch.
/// Dùng cho màn Từ điển và sheet tra nhanh.
class DictionaryBrowser extends ConsumerStatefulWidget {
  const DictionaryBrowser({super.key, this.initialWord, this.autofocus = false, this.trailing});

  /// Mở sẵn mục từ này (tra nhanh khi bôi đen chữ).
  final String? initialWord;
  final bool autofocus;

  /// Nút cạnh ô tra (vd. "Mở toàn màn hình" trong sheet), nhận từ đang xem.
  final Widget Function(String? word)? trailing;

  @override
  ConsumerState<DictionaryBrowser> createState() => _DictionaryBrowserState();
}

class _DictionaryBrowserState extends ConsumerState<DictionaryBrowser> {
  late final _controller = TextEditingController(text: widget.initialWord);
  final _focus = FocusNode();
  Timer? _timer;

  /// Chữ đã debounce để lấy gợi ý.
  String _query = '';

  /// Từ đang xem; null = đang ở danh sách gợi ý / màn chính.
  String? _word;

  /// [_word] được dịch (Google Dịch) thay vì tra từ điển.
  bool _translate = false;

  /// Gợi ý gần nhất – giữ lại khi đang tải gợi ý mới để danh sách không nháy.
  List<DictSuggestion> _lastSuggestions = const [];

  @override
  void initState() {
    super.initState();
    if (widget.initialWord case final w? when w.trim().isNotEmpty) {
      _word = w.trim();
      _translate = wordCount(w) > maxLookupWords;
      WidgetsBinding.instance.addPostFrameCallback((_) => _remember(_word!));
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _focus.dispose();
    super.dispose();
  }

  /// Chỉ lưu từ / cụm ngắn vào lịch sử (câu dài làm danh sách khó đọc).
  void _remember(String word) {
    if (mounted && wordCount(word) <= maxLookupWords) {
      ref.read(dictHistoryProvider.notifier).add(word);
    }
  }

  void _onChanged(String text) {
    _timer?.cancel();
    setState(() => _word = null);
    _timer = Timer(_debounce, () {
      if (mounted) setState(() => _query = WordMatch.normalize(text));
    });
  }

  /// Mở mục từ; [translate] mặc định: dịch khi dài hơn [maxLookupWords] từ.
  void _open(String word, {bool? translate}) {
    final w = word.trim();
    if (w.isEmpty) return;
    _timer?.cancel();
    _focus.unfocus();
    _controller.value = TextEditingValue(
      text: w,
      selection: TextSelection.collapsed(offset: w.length),
    );
    setState(() {
      _word = w;
      _translate = translate ?? wordCount(w) > maxLookupWords;
      _query = WordMatch.normalize(w);
    });
    _remember(w);
  }

  void _clear() {
    _timer?.cancel();
    _controller.clear();
    setState(() {
      _word = null;
      _query = '';
    });
    _focus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final word = _word;
    return PopScope(
      // Đang xem 1 từ (không phải từ được mở sẵn) → Back quay về danh sách gợi ý.
      canPop: word == null || word == widget.initialWord?.trim(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _word = null);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              AppSpacing.s8,
              AppSpacing.screen,
              AppSpacing.s8,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ListenableBuilder(
                    listenable: _controller,
                    builder: (context, _) => TextField(
                      controller: _controller,
                      focusNode: _focus,
                      autofocus: widget.autofocus,
                      minLines: 1,
                      maxLines: 3,
                      autocorrect: false,
                      enableSuggestions: false,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search_rounded),
                        hintText: 'Tra từ hoặc dán câu cần dịch',
                        suffixIcon: _controller.text.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Xoá',
                                icon: const Icon(Icons.close_rounded),
                                onPressed: _clear,
                              ),
                      ),
                      onChanged: _onChanged,
                      onSubmitted: _open,
                    ),
                  ),
                ),
                ?widget.trailing?.call(word),
              ],
            ),
          ),
          Expanded(
            child: switch ((word, _query)) {
              (final w?, _) => ListView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  AppSpacing.s8,
                  AppSpacing.screen,
                  AppSpacing.s32,
                ),
                children: [
                  if (_translate)
                    TranslationView(text: w)
                  else
                    DictEntryView(query: w, onLookup: _open),
                ],
              ),
              (null, '') => _Home(onLookup: _open),
              (null, final q) => _suggestions(q),
            },
          ),
        ],
      ),
    );
  }

  /// Dòng "Dịch …" đứng đầu danh sách khi gõ nhiều từ.
  Widget _translateTile(String text) => AppListGroup(
    dividerIndent: AppSpacing.s16 + AppSizes.badgeMd + AppSpacing.s16,
    children: [
      ListTile(
        leading: const IconBadge(icon: Icons.g_translate_rounded, tone: AppTone.info),
        title: const Text('Dịch sang tiếng Việt'),
        subtitle: Text(text, maxLines: 2, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => _open(text, translate: true),
      ),
    ],
  );

  Widget _suggestions(String query) {
    final raw = _controller.text.trim();
    // Câu dài: không có trong từ điển → chỉ gợi ý dịch, khỏi gọi dict_suggest.
    if (wordCount(raw) > maxLookupWords) {
      return ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screen,
          AppSpacing.s8,
          AppSpacing.screen,
          AppSpacing.s32,
        ),
        children: [_translateTile(raw)],
      );
    }
    final async = ref.watch(dictSuggestionsProvider(query));
    if (async.value case final v?) _lastSuggestions = v;
    if (async.hasError && !async.isLoading) {
      return Padding(
        padding: AppInsets.screenH,
        child: AppErrorView(
          message: AppException.from(async.error!).message,
          onRetry: () => ref.invalidate(dictSuggestionsProvider(query)),
        ),
      );
    }
    final items = _lastSuggestions;
    final fuzzy = items.isNotEmpty && items.first.fuzzy;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (async.isLoading) const LinearProgressIndicator() else Gaps.v4,
        Expanded(
          child: items.isEmpty && !async.isLoading
              ? AppEmptyView(
                  icon: Icons.search_off_rounded,
                  message: 'Không có từ nào bắt đầu bằng "$query".',
                  action: wordCount(raw) >= 2
                      ? OutlinedButton.icon(
                          onPressed: () => _open(raw, translate: true),
                          icon: const Icon(Icons.g_translate_rounded),
                          label: const Text('Dịch cụm này'),
                        )
                      : OutlinedButton(onPressed: () => _open(query), child: Text('Tra "$query"')),
                )
              : ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screen,
                    AppSpacing.s4,
                    AppSpacing.screen,
                    AppSpacing.s32,
                  ),
                  children: [
                    if (wordCount(raw) >= 2) ...[_translateTile(raw), Gaps.v16],
                    if (fuzzy) const SectionHeader(title: 'Có phải bạn muốn tìm'),
                    if (items.isNotEmpty)
                      AppListGroup(
                        children: [
                          for (final s in items)
                            ListTile(
                              title: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(text: s.word, style: context.textStyles.titleMedium),
                                    if (s.ipa case final ipa? when ipa.isNotEmpty)
                                      TextSpan(
                                        text: '  $ipa',
                                        style: context.textStyles.bodySmall?.copyWith(
                                          color: context.colors.onSurfaceVariant,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              subtitle: s.meaning == null
                                  ? null
                                  : Text(s.meaning!, maxLines: 1, overflow: TextOverflow.ellipsis),
                              onTap: () => _open(s.word),
                            ),
                        ],
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

/// Chưa gõ gì: sổ từ của tôi + tra gần đây.
class _Home extends ConsumerWidget {
  const _Home({required this.onLookup});

  final ValueChanged<String> onLookup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(dictHistoryProvider).value ?? const [];
    final saved = ref.watch(notebookWordsProvider).value?.length ?? 0;
    const deck = VocabDeck.topic(ownTopic);
    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screen,
        AppSpacing.s8,
        AppSpacing.screen,
        AppSpacing.s32,
      ),
      children: [
        AppListGroup(
          dividerIndent: AppSpacing.s16 + AppSizes.badgeMd + AppSpacing.s16,
          children: [
            ListTile(
              leading: const IconBadge(icon: Icons.bookmark_rounded, tone: AppTone.info),
              title: const Text('Sổ từ của tôi'),
              subtitle: Text(
                saved == 0
                    ? 'Bấm biểu tượng lưu khi tra từ để thêm vào đây'
                    : '$saved từ · ôn bằng flashcard như từ ETS',
              ),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () => context.push(Routes.vocabWords(deck: deck.key)),
            ),
            if (saved > 0)
              ListTile(
                leading: const IconBadge(icon: Icons.style_rounded, tone: AppTone.success),
                title: const Text('Học sổ từ bằng flashcard'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => context.push(Routes.flashcards(deck: deck.key)),
              ),
          ],
        ),
        Gaps.v24,
        SectionHeader(
          title: 'Tra gần đây',
          trailing: history.isEmpty
              ? null
              : TextButton(
                  onPressed: () => ref.read(dictHistoryProvider.notifier).clear(),
                  child: const Text('Xoá hết'),
                ),
        ),
        if (history.isEmpty)
          const AppBanner(
            message:
                'Mẹo: khi làm bài, bôi đen một từ rồi chọn "Tra từ" để tra ngay không cần rời đề.',
          )
        else
          Wrap(
            spacing: AppSpacing.s8,
            runSpacing: AppSpacing.s8,
            children: [
              for (final w in history)
                InputChip(
                  label: Text(w),
                  onPressed: () => onLookup(w),
                  onDeleted: () => ref.read(dictHistoryProvider.notifier).remove(w),
                  deleteButtonTooltipMessage: 'Xoá khỏi lịch sử',
                ),
            ],
          ),
      ],
    );
  }
}
