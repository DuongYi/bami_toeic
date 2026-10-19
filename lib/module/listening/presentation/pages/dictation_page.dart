import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/handwriting/handwriting_recognizer.dart';
import '../../../../core/network/app_exception.dart';
import '../../../../helper/dictation.dart';
import '../../../../helper/format.dart';
import '../../../goals/data/study_store.dart';
import '../../../test/data/models/test_models.dart';
import '../../../vocab/presentation/widgets/word_lookup_sheet.dart';
import '../../../../core/speech/speech_service.dart';
import '../controllers/dictation_providers.dart';
import '../widgets/shadowing_panel.dart';

/// Chép chính tả từng đoạn audio: nghe → gõ → kiểm tra → xem transcript & nói theo (Shadowing).
class DictationPage extends ConsumerWidget {
  const DictationPage({super.key, required this.testId, required this.part});

  final String testId;
  final int part;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clips = ref.watch(dictationClipsProvider(testId, part));
    if (clips.value case final list?) {
      return list.isEmpty
          ? Scaffold(
              appBar: AppBar(),
              body: const AppEmptyView(
                icon: Icons.subtitles_off_outlined,
                message: 'Part này của đề chưa có transcript.\nHãy chọn Part hoặc đề khác.',
              ),
            )
          : _DictationSession(clips: list, part: part);
    }
    return Scaffold(
      appBar: AppBar(),
      body: AsyncView(
        value: clips,
        loading: (_) => const TestTakingSkeleton(),
        onRetry: () => ref.invalidate(dictationClipsProvider(testId, part)),
        data: (_) => const SizedBox.shrink(),
      ),
    );
  }
}

class _DictationSession extends ConsumerStatefulWidget {
  const _DictationSession({required this.clips, required this.part});

  final List<QuestionGroup> clips;
  final int part;

  @override
  ConsumerState<_DictationSession> createState() => _DictationSessionState();
}

class _DictationSessionState extends ConsumerState<_DictationSession> {
  final _player = AudioPlayer();
  final _input = TextEditingController();
  final _focusNode = FocusNode();
  int _index = 0;
  DictationResult? _result;
  bool _showTranscript = false;
  double _currentSpeed = 1.0;
  bool _autoPlay = true;
  String? _playerError;

  bool _useHandwriting = false;
  bool _useCanvasMode = false;
  bool _recognizing = false;
  final _handwritingStrokes = <int, List<DrawStroke>>{};

  /// Điểm từng đoạn đã chấm (index → tỉ lệ đúng).
  final _scores = <int, double>{};

  QuestionGroup get _clip => widget.clips[_index];

  @override
  void initState() {
    super.initState();
    _input.addListener(_onTextChanged);
    _loadClip(play: _autoPlay);
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(_DictationSession old) {
    super.didUpdateWidget(old);
    if (old.clips != widget.clips) {
      _loadClip(play: _autoPlay);
    }
  }

  Future<void> _loadClip({bool play = false}) async {
    final url = _clip.audioUrl;
    if (url == null || url.isEmpty) return;
    try {
      setState(() => _playerError = null);
      await _player.setUrl(url);
      await _player.setSpeed(_currentSpeed);
      if (play && mounted) {
        await _player.play();
      }
    } catch (_) {
      if (mounted) {
        setState(() => _playerError = 'Không tải được audio');
      }
    }
  }

  @override
  void dispose() {
    _player.dispose();
    _input.removeListener(_onTextChanged);
    _input.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _togglePlay() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      if (_player.processingState == ProcessingState.completed) {
        await _player.seek(Duration.zero);
      }
      await _player.play();
    }
  }

  Future<void> _replay3Seconds() async {
    final cur = _player.position;
    final target = cur - const Duration(seconds: 3);
    await _player.seek(target < Duration.zero ? Duration.zero : target);
    if (!_player.playing) await _player.play();
  }

  Future<void> _replayFromStart() async {
    await _player.seek(Duration.zero);
    await _player.play();
  }

  Future<void> _setSpeed(double speed) async {
    setState(() => _currentSpeed = speed);
    await _player.setSpeed(speed);
  }

  Future<void> _startShadowing() async {
    setState(() {
      _currentSpeed = 0.75;
      _showTranscript = true;
    });
    await _player.setSpeed(0.75);
    await _player.seek(Duration.zero);
    await _player.play();
  }

  /// Nhận dạng chữ viết tay trên bảng vẽ bằng Vision (iOS) rồi đưa vào ô trả lời để người học soát lại.
  Future<void> _convertHandwritingToText({bool silent = false}) async {
    final strokes = _handwritingStrokes[_index] ?? const [];
    if (strokes.isEmpty) {
      if (!silent) {
        showAppSnackBar(context, 'Hãy viết lên bảng trước khi chuyển thành chữ.', tone: AppTone.warning);
      }
      return;
    }
    final recognizer = ref.read(handwritingRecognizerProvider);
    if (!recognizer.isSupported) {
      showAppSnackBar(
        context,
        'Nhận dạng nét vẽ chỉ có trên iPad / iPhone. Hãy dùng "Vở Scribble" hoặc gõ phím.',
        tone: AppTone.warning,
      );
      return;
    }
    setState(() => _recognizing = true);
    try {
      final text = await recognizer.recognize(strokes);
      if (!mounted) return;
      if (text.isEmpty) {
        showAppSnackBar(
          context,
          'Chưa đọc được chữ. Viết to, rõ, mỗi từ cách nhau một chút rồi thử lại.',
          tone: AppTone.warning,
        );
        return;
      }
      _input.text = text;
      if (!silent) {
        showAppSnackBar(context, 'Đã nhận dạng – soát và sửa lại nếu sai trước khi kiểm tra.', tone: AppTone.success);
      }
    } catch (e) {
      if (mounted) showAppSnackBar(context, AppException.from(e).message, tone: AppTone.danger);
    } finally {
      if (mounted) setState(() => _recognizing = false);
    }
  }

  Future<void> _check() async {
    final transcript = _clip.transcript;
    if (transcript == null || transcript.isEmpty) return;
    final target = Dictation.lines(transcript).join(' ');

    // Viết trên bảng vẽ mà chưa chuyển thành chữ → nhận dạng trước rồi mới chấm.
    if (_useHandwriting &&
        _useCanvasMode &&
        _input.text.trim().isEmpty &&
        (_handwritingStrokes[_index]?.isNotEmpty ?? false)) {
      await _convertHandwritingToText(silent: true);
      if (!mounted) return;
    }

    final hasTyped = _input.text.trim().isNotEmpty;
    final r = hasTyped
        ? Dictation.check(target, _input.text)
        : DictationResult(tokens: [(target, true)], correct: 1, total: 1);
    if (!_scores.containsKey(_index)) {
      ref.read(studyStoreProvider).record(StudyEvent.dictations);
    }
    setState(() {
      _result = r;
      if (hasTyped) {
        _scores[_index] = r.ratio;
      }
      _showTranscript = true;
    });
  }

  void _go(int i) {
    setState(() {
      _index = i;
      _input.clear();
      _result = null;
      _showTranscript = false;
    });
    _loadClip(play: _autoPlay);
  }

  @override
  Widget build(BuildContext context) {
    final clip = _clip;
    final r = _result;
    final last = _index == widget.clips.length - 1;
    final avg = _scores.isEmpty ? null : _scores.values.reduce((a, b) => a + b) / _scores.length;
    final first = clip.questions.first.number;
    final lastQ = clip.questions.last.number;
    final isWide = MediaQuery.sizeOf(context).width >= 768;

    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.space, control: true): _togglePlay,
        const SingleActivator(LogicalKeyboardKey.space, alt: true): _togglePlay,
        const SingleActivator(LogicalKeyboardKey.space, meta: true): _togglePlay,
        const SingleActivator(LogicalKeyboardKey.arrowLeft, control: true): _replay3Seconds,
        const SingleActivator(LogicalKeyboardKey.arrowLeft, alt: true): _replay3Seconds,
        const SingleActivator(LogicalKeyboardKey.keyR, control: true): _replay3Seconds,
        const SingleActivator(LogicalKeyboardKey.keyR, alt: true): _replay3Seconds,
        const SingleActivator(LogicalKeyboardKey.enter, control: true): () {
          if (_result == null && _input.text.trim().isNotEmpty) _check();
        },
        const SingleActivator(LogicalKeyboardKey.enter, meta: true): () {
          if (_result == null && _input.text.trim().isNotEmpty) _check();
        },
        const SingleActivator(LogicalKeyboardKey.digit1, control: true): () => _setSpeed(0.75),
        const SingleActivator(LogicalKeyboardKey.digit2, control: true): () => _setSpeed(1.0),
        const SingleActivator(LogicalKeyboardKey.digit3, control: true): () => _setSpeed(1.25),
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Đoạn ${_index + 1}/${widget.clips.length}'),
          actions: [
            IconButton(
              tooltip: _autoPlay ? 'Tự động phát: BẬT' : 'Tự động phát: TẮT',
              icon: Icon(
                _autoPlay ? Icons.play_circle_filled_rounded : Icons.pause_circle_outline_rounded,
                color: _autoPlay ? context.colors.primary : null,
              ),
              onPressed: () => setState(() => _autoPlay = !_autoPlay),
            ),
            if (avg != null)
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.s16),
                child: Center(
                  child: StatusBadge(label: 'TB ${Fmt.percent(avg)}', tone: AppTone.fromRatio(avg)),
                ),
              ),
          ],
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: isWide
                ? _buildWideLayout(context, clip, r, first, lastQ)
                : _buildMobileLayout(context, clip, r, first, lastQ),
          ),
        ),
        bottomNavigationBar: AppBottomBar(
          child: Row(
            children: [
              IconButton(
                tooltip: 'Đoạn trước',
                onPressed: _index == 0 ? null : () => _go(_index - 1),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Gaps.h8,
              Expanded(
                child: r == null
                    ? AppPrimaryButton(
                        icon: Icons.spellcheck_rounded,
                        label: 'Kiểm tra',
                        onPressed: (_useHandwriting
                                ? ((_handwritingStrokes[_index]?.isNotEmpty ?? false) ||
                                    _input.text.trim().isNotEmpty)
                                : _input.text.trim().isNotEmpty)
                            ? _check
                            : null,
                      )
                    : AppPrimaryButton(
                        icon: last ? Icons.check_rounded : Icons.arrow_forward_rounded,
                        label: last ? 'Hoàn thành' : 'Đoạn tiếp theo',
                        onPressed: last
                            ? () => Navigator.of(context).maybePop()
                            : () => _go(_index + 1),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    BuildContext context,
    QuestionGroup clip,
    DictationResult? r,
    int first,
    int lastQ,
  ) {
    return ListView(
      padding: AppInsets.screen,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: [
        _buildQuestionHeader(context, first, lastQ),
        Gaps.v12,
        _buildPlayerCard(context),
        Gaps.v16,
        _buildInputCard(context, r),
        if (r != null) ...[
          Gaps.v16,
          _ResultCard(
            result: r,
            userTyped: _input.text,
            handwritingStrokes: _handwritingStrokes[_index],
          ),
        ],
        if (_showTranscript) ...[
          Gaps.v16,
          _buildTranscriptCard(context, clip),
        ] else if (r == null) ...[
          Gaps.v8,
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: const Icon(Icons.visibility_outlined),
              label: const Text('Bỏ qua, xem transcript'),
              onPressed: () => setState(() => _showTranscript = true),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildWideLayout(
    BuildContext context,
    QuestionGroup clip,
    DictationResult? r,
    int first,
    int lastQ,
  ) {
    return Padding(
      padding: AppInsets.screen,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cột trái: Trình phát audio + Transcript / Shadowing
          Expanded(
            flex: 5,
            child: ListView(
              children: [
                _buildQuestionHeader(context, first, lastQ),
                Gaps.v12,
                _buildPlayerCard(context),
                if (_showTranscript) ...[
                  Gaps.v16,
                  _buildTranscriptCard(context, clip),
                ],
              ],
            ),
          ),
          Gaps.h24,
          // Cột phải: Ô gõ chép chính tả + Kết quả
          Expanded(
            flex: 6,
            child: ListView(
              children: [
                _buildInputCard(context, r),
                if (r != null) ...[
                  Gaps.v16,
                  _ResultCard(
                    result: r,
                    userTyped: _input.text,
                    handwritingStrokes: _handwritingStrokes[_index],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionHeader(BuildContext context, int first, int lastQ) {
    return Row(
      children: [
        StatusBadge(
          label: 'Part ${widget.part}',
          tone: AppTone.info,
          icon: Icons.headphones_rounded,
        ),
        Gaps.h8,
        Text(
          first == lastQ ? 'Câu $first' : 'Câu $first–$lastQ',
          style: context.textStyles.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildPlayerCard(BuildContext context) {
    final colors = context.colors;
    final surfaces = context.surfaces;

    if (_playerError != null) {
      return AppCard(
        tone: AppTone.danger,
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: colors.error),
            Gaps.h12,
            Expanded(child: Text(_playerError!)),
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => _loadClip(play: true),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: surfaces.raised,
        borderRadius: AppRadius.brLg,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Hàng 1: Nút điều khiển audio và hiển thị thời gian
          Row(
            children: [
              // Nút Play / Pause
              StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snap) {
                  final state = snap.data;
                  final loading = state == null ||
                      state.processingState == ProcessingState.loading ||
                      state.processingState == ProcessingState.buffering;
                  final completed = state?.processingState == ProcessingState.completed;

                  if (loading) {
                    return const SizedBox.square(
                      dimension: AppSizes.touchTarget,
                      child: Center(
                        child: SizedBox.square(
                          dimension: AppSizes.iconSm,
                          child: CircularProgressIndicator(strokeWidth: AppSizes.strokeThin),
                        ),
                      ),
                    );
                  }

                  return IconButton.filled(
                    tooltip: completed
                        ? 'Nghe lại'
                        : (state.playing ? 'Tạm dừng (Ctrl+Space)' : 'Phát (Ctrl+Space)'),
                    icon: Icon(
                      completed
                          ? Icons.replay_rounded
                          : (state.playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                      size: AppSizes.iconMd,
                    ),
                    onPressed: _togglePlay,
                  );
                },
              ),
              Gaps.h8,
              // Nút tua lùi 3 giây
              Tooltip(
                message: 'Tua lùi 3s (Ctrl+←)',
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s8,
                    ),
                  ),
                  icon: const Icon(Icons.replay_rounded, size: AppSizes.iconSm),
                  label: const Text('3s'),
                  onPressed: _replay3Seconds,
                ),
              ),
              Gaps.h4,
              IconButton(
                tooltip: 'Nghe lại từ đầu',
                icon: const Icon(Icons.first_page_rounded),
                onPressed: _replayFromStart,
              ),
              // Thời gian phát – co lại khi màn hẹp (điện thoại) thay vì tràn hàng.
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: StreamBuilder<Duration>(
                      stream: _player.positionStream,
                      builder: (context, snap) {
                        final pos = snap.data ?? Duration.zero;
                        final total = _player.duration ?? Duration.zero;
                        return Text(
                          '${Fmt.clock(pos)} / ${Fmt.clock(total)}',
                          style: context.textStyles.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gaps.v4,
          // Hàng 2: Thanh kéo timeline
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snap) {
              final pos = snap.data ?? Duration.zero;
              final total = _player.duration ?? Duration.zero;
              final max = total.inMilliseconds.toDouble();
              return Slider(
                value: pos.inMilliseconds.clamp(0, max).toDouble(),
                max: max <= 0 ? 1 : max,
                onChanged: max <= 0
                    ? null
                    : (v) => _player.seek(Duration(microseconds: (v * 1000).round())),
              );
            },
          ),
          // Hàng 3: Tốc độ phát (0.75x, 1.0x, 1.25x)
          Row(
            children: [
              Text(
                'Tốc độ:',
                style: context.textStyles.labelSmall?.copyWith(
                  color: colors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.h8,
              Expanded(
                child: SegmentedButton<double>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: 0.75, label: Text('0.75x')),
                    ButtonSegment(value: 1.0, label: Text('1.0x')),
                    ButtonSegment(value: 1.25, label: Text('1.25x')),
                  ],
                  selected: {_currentSpeed},
                  onSelectionChanged: (set) => _setSpeed(set.first),
                ),
              ),
            ],
          ),
          Gaps.v8,
          // Hàng 4: Hướng dẫn phím tắt bàn phím
          Row(
            children: [
              Icon(
                Icons.keyboard_outlined,
                size: AppSizes.iconXs,
                color: colors.onSurfaceVariant,
              ),
              Gaps.h4,
              Expanded(
                child: Text(
                  'Ctrl+Space (Dừng/Phát) · Ctrl+← (Tua 3s) · Ctrl+Enter (Kiểm tra)',
                  style: context.textStyles.labelSmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(BuildContext context, DictationResult? r) {
    final wordCount = Dictation.words(_input.text).length;
    final strokes = _handwritingStrokes[_index] ?? const [];

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: SegmentedButton<bool>(
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      value: false,
                      icon: Icon(Icons.keyboard_outlined, size: AppSizes.iconSm),
                      label: Text('Gõ phím'),
                    ),
                    ButtonSegment(
                      value: true,
                      icon: Icon(Icons.draw_rounded, size: AppSizes.iconSm),
                      label: Text('Viết tay (Pencil)'),
                    ),
                  ],
                  selected: {_useHandwriting},
                  onSelectionChanged: (set) => setState(() => _useHandwriting = set.first),
                ),
              ),
              if (!_useHandwriting && _input.text.isNotEmpty && r == null) ...[
                Gaps.h8,
                TextButton.icon(
                  icon: const Icon(Icons.clear_rounded, size: AppSizes.iconSm),
                  label: const Text('Xoá hết'),
                  onPressed: () => _input.clear(),
                ),
              ],
            ],
          ),
          Gaps.v12,
          if (!_useHandwriting) ...[
            Row(
              children: [
                StatusBadge(
                  label: '$wordCount từ đã gõ',
                  icon: Icons.edit_note_rounded,
                  tone: wordCount > 0 ? AppTone.info : AppTone.neutral,
                ),
              ],
            ),
            Gaps.v12,
            TextField(
              controller: _input,
              focusNode: _focusNode,
              minLines: 4,
              maxLines: 8,
              enabled: r == null,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: false,
              decoration: InputDecoration(
                hintText: 'Nghe và gõ lại những gì bạn nghe được...',
                alignLabelWithHint: true,
                border: const OutlineInputBorder(borderRadius: AppRadius.brMd),
                helperText: r == null ? 'Mẹo: Nhấn Ctrl+Enter để kiểm tra nhanh' : null,
              ),
            ),
          ] else ...[
            // Thanh chuyển đổi giữa Vở Scribble (Apple Pencil) vs Bảng vẽ nét Canvas
            Row(
              children: [
                Expanded(
                  child: SegmentedButton<bool>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: false,
                        icon: Icon(Icons.draw_rounded, size: AppSizes.iconSm),
                        label: Text('Vở Scribble (Apple Pencil)'),
                      ),
                      ButtonSegment(
                        value: true,
                        icon: Icon(Icons.gesture_rounded, size: AppSizes.iconSm),
                        label: Text('Bảng vẽ nét (Canvas)'),
                      ),
                    ],
                    selected: {_useCanvasMode},
                    onSelectionChanged: (set) => setState(() => _useCanvasMode = set.first),
                  ),
                ),
              ],
            ),
            Gaps.v12,

            if (!_useCanvasMode) ...[
              // Chế độ Vở Scribble Apple Pencil chính gốc: Viết chữ trực tiếp lên dòng kẻ vở
              _buildScribbleNotebook(context, r),
              Gaps.v8,
              Row(
                children: [
                  Icon(
                    Icons.apple,
                    size: AppSizes.iconSm,
                    color: context.colors.onSurfaceVariant,
                  ),
                  Gaps.h4,
                  Expanded(
                    child: Text(
                      'Apple Pencil Scribble: Viết trực tiếp lên dòng kẻ, iPad sẽ tự nhận diện chữ viết tay của bạn thành văn bản tức thì.',
                      style: context.textStyles.labelSmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Chế độ Bảng vẽ nét mực tự do
              ClipRRect(
                borderRadius: AppRadius.brMd,
                child: HandwritingPad(
                  key: ValueKey('pad_$_index'),
                  initialStrokes: strokes,
                  enabled: r == null,
                  onStrokesChanged: (newStrokes) {
                    _handwritingStrokes[_index] = newStrokes;
                    setState(() {});
                  },
                  onReplay3s: _replay3Seconds,
                ),
              ),
              Gaps.v8,
              if (r == null) ...[
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: _recognizing
                            ? const AppInlineSpinner()
                            : const Icon(Icons.auto_fix_high_rounded, size: AppSizes.iconSm),
                        label: Text(_recognizing ? 'Đang nhận dạng…' : 'Chuyển nét vẽ thành văn bản (A→Text)'),
                        onPressed: strokes.isEmpty || _recognizing ? null : () => _convertHandwritingToText(),
                      ),
                    ),
                  ],
                ),
                Gaps.v8,
              ],
              // Chữ đã nhận dạng – sửa được (gõ phím hoặc viết Scribble) trước khi kiểm tra.
              if (_input.text.trim().isNotEmpty) ...[
                TextField(
                  controller: _input,
                  minLines: 2,
                  maxLines: 5,
                  enabled: r == null,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: 'Chữ đã nhận dạng (sửa nếu sai)',
                    prefixIcon: const Icon(Icons.text_fields_rounded),
                    suffixIcon: r == null
                        ? IconButton(
                            tooltip: 'Xoá chữ',
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: _input.clear,
                          )
                        : null,
                  ),
                ),
                Gaps.v8,
              ],
              Row(
                children: [
                  Icon(
                    Icons.apple,
                    size: AppSizes.iconSm,
                    color: context.colors.onSurfaceVariant,
                  ),
                  Gaps.h4,
                  Expanded(
                    child: Text(
                      'Bảng vẽ nét mực tự do · Bấm "Chuyển nét vẽ thành văn bản" hoặc chọn tab "Vở Scribble" để viết ra chữ thật.',
                      style: context.textStyles.labelSmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
          if (r == null && !_useHandwriting) ...[
            Gaps.v12,
            Wrap(
              spacing: AppSpacing.s8,
              runSpacing: AppSpacing.s8,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.replay_rounded, size: AppSizes.iconSm),
                  label: const Text('Nghe lại 3s'),
                  onPressed: _replay3Seconds,
                ),
                OutlinedButton.icon(
                  icon: const Icon(Icons.play_circle_outline_rounded, size: AppSizes.iconSm),
                  label: const Text('Phát / Dừng'),
                  onPressed: _togglePlay,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// Chiều cao 1 dòng vở Scribble = khoảng cách dòng kẻ; chữ được ép đúng chiều cao này để nằm trên dòng.
  static const _notebookLine = 38.0;

  Widget _buildScribbleNotebook(BuildContext context, DictationResult? r) {
    final colors = context.colors;
    final surfaces = context.surfaces;
    final textStyle = context.textStyles.titleMedium!;
    final fontSize = textStyle.fontSize ?? 16;

    return Container(
      decoration: BoxDecoration(
        color: surfaces.raised,
        borderRadius: AppRadius.brMd,
        border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Thanh mép vở
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s8,
            ),
            decoration: BoxDecoration(
              color: surfaces.raised,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
              border: Border(
                bottom: BorderSide(
                  color: colors.outlineVariant.withValues(alpha: 0.3),
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.edit_note_rounded, size: AppSizes.iconSm, color: colors.primary),
                Gaps.h8,
                Expanded(
                  child: Text(
                    'Vở viết Scribble (Apple Pencil)',
                    style: context.textStyles.labelSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.primary,
                    ),
                  ),
                ),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s8, vertical: AppSpacing.s4),
                    visualDensity: VisualDensity.compact,
                  ),
                  icon: const Icon(Icons.replay_rounded, size: AppSizes.iconXs),
                  label: const Text('3s'),
                  onPressed: _replay3Seconds,
                ),
                Gaps.h4,
                IconButton(
                  tooltip: 'Phát / Tạm dừng',
                  iconSize: AppSizes.iconSm,
                  visualDensity: VisualDensity.compact,
                  icon: Icon(_player.playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  onPressed: _togglePlay,
                ),
                if (_input.text.isNotEmpty && r == null) ...[
                  Gaps.h4,
                  IconButton(
                    tooltip: 'Xoá trang vở',
                    iconSize: AppSizes.iconSm,
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_sweep_rounded),
                    onPressed: () => _input.clear(),
                  ),
                ],
              ],
            ),
          ),

          // Khung giấy kẻ dòng có TextField hỗ trợ Scribble
          ClipRRect(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(AppRadius.md)),
            child: Stack(
              children: [
                // Các đường kẻ ngang mờ của cuốn vở
                Positioned.fill(
                  child: CustomPaint(
                    painter: RuledLinesPainter(
                      lineColor: colors.outlineVariant.withValues(alpha: 0.45),
                      lineSpacing: _notebookLine,
                      // Lề trên của ô chữ + chân chữ trong dòng 1 (chữ đứng ngay trên dòng kẻ).
                      firstLine: AppSpacing.s8 + _notebookLine * 0.78,
                    ),
                  ),
                ),

                // Ô nhập văn bản hỗ trợ Apple Pencil Scribble
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.s16, AppSpacing.s8, AppSpacing.s16, AppSpacing.s16),
                  child: TextField(
                    controller: _input,
                    focusNode: _focusNode,
                    minLines: 5,
                    maxLines: 8,
                    enabled: r == null,
                    stylusHandwritingEnabled: true,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: false,
                    style: textStyle.copyWith(letterSpacing: 0.4),
                    strutStyle: StrutStyle(
                      fontSize: fontSize, // ds-ignore: lấy từ textStyles.titleMedium, chỉ để ép chiều cao dòng
                      height: _notebookLine / fontSize,
                      forceStrutHeight: true,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Cầm Apple Pencil viết trực tiếp lên dòng kẻ vở (Scribble)...',
                      filled: false, // nền trong suốt để thấy dòng kẻ vở phía sau
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranscriptCard(BuildContext context, QuestionGroup clip) {
    final transcript = clip.transcript ?? '';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const IconBadge(
                icon: Icons.record_voice_over_outlined,
                tone: AppTone.success,
              ),
              Gaps.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Luyện nói theo (Shadowing)',
                      style: context.textStyles.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Nghe lại ở 0.75x, rồi nói theo từng câu để máy chấm phát âm.',
                      style: context.textStyles.bodySmall?.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v12,
          SelectableText(
            transcript,
            style: context.textStyles.bodyLarge,
            contextMenuBuilder: lookupContextMenu(
              context,
              testId: clip.testId,
              sourceLabel: 'Part ${clip.part} · câu ${clip.questions.first.number}',
            ),
          ),
          Gaps.v12,
          OutlinedButton.icon(
            icon: const Icon(Icons.slow_motion_video_rounded, size: AppSizes.iconSm),
            label: const Text('Nghe lại cả đoạn ở 0.75x'),
            onPressed: _startShadowing,
          ),
          if (SpeechService.supported) ...[
            Gaps.v12,
            const Divider(),
            Gaps.v12,
            const SectionHeader(
              title: 'Nói theo từng câu',
              subtitle: 'Bấm Nói theo, đọc to câu, máy chấm từng từ.',
            ),
            ShadowingPanel(
              key: ValueKey(clip.id),
              transcript: transcript,
              onBeforeSpeak: () => _player.pause(),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({
    required this.result,
    required this.userTyped,
    this.handwritingStrokes,
  });

  final DictationResult result;
  final String userTyped;
  final List<DrawStroke>? handwritingStrokes;

  @override
  Widget build(BuildContext context) {
    final tone = AppTone.fromRatio(result.ratio);
    final danger = AppTone.danger.colorsOf(context);
    final hasHandwriting = handwritingStrokes != null && handwritingStrokes!.isNotEmpty;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LabeledProgress(
            label: 'Độ chính xác',
            value: result.ratio,
            trailing: '${result.correct}/${result.total} từ · ${Fmt.percent(result.ratio)}',
          ),
          Gaps.v16,
          Text(
            'Đáp án đối chiếu:',
            style: context.textStyles.labelMedium?.copyWith(
              color: context.colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.v8,
          Text.rich(
            TextSpan(
              children: [
                for (final (word, ok) in result.tokens)
                  TextSpan(
                    text: '$word ',
                    style: ok
                        ? null
                        : TextStyle(
                            color: danger.main,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            backgroundColor: danger.container.withValues(alpha: 0.35),
                          ),
                  ),
              ],
            ),
            style: context.textStyles.bodyLarge,
          ),
          Gaps.v12,
          if (hasHandwriting) ...[
            Text(
              'Bài viết tay của bạn:',
              style: context.textStyles.labelMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v8,
            HandwritingViewer(
              strokes: handwritingStrokes!,
              height: 200,
            ),
            Gaps.v12,
          ],
          if (userTyped.trim().isNotEmpty) ...[
            Text(
              'Bạn đã gõ:',
              style: context.textStyles.labelMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v4,
            Text(
              userTyped.trim(),
              style: context.textStyles.bodyMedium?.copyWith(
                color: context.colors.onSurfaceVariant,
                fontStyle: FontStyle.italic,
              ),
            ),
            Gaps.v12,
          ],
          Row(
            children: [
              Icon(tone.icon, size: AppSizes.iconSm, color: tone.colorsOf(context).main),
              Gaps.h8,
              Expanded(
                child: Text(
                  hasHandwriting
                      ? 'Đối chiếu nét chữ viết tay với đáp án bên trên để tự kiểm tra lỗi chính tả.'
                      : 'Từ bôi đỏ và gạch chân là từ bạn nghe sai hoặc bỏ sót.',
                  style: context.textStyles.bodySmall?.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
