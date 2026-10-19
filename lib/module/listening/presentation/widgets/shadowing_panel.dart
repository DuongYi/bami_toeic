import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/speech/speech_service.dart';
import '../../../../core/tts/tts_service.dart';
import '../../../../helper/dictation.dart';
import '../../../../helper/format.dart';

/// Nói theo từng câu của transcript: máy nhận dạng giọng nói rồi chấm từng từ khớp với câu gốc.
class ShadowingPanel extends ConsumerStatefulWidget {
  const ShadowingPanel({super.key, required this.transcript, this.onBeforeSpeak});

  final String transcript;

  /// Dừng audio đoạn hội thoại trước khi bật micro / đọc mẫu.
  final Future<void> Function()? onBeforeSpeak;

  @override
  ConsumerState<ShadowingPanel> createState() => _ShadowingPanelState();
}

class _ShadowingPanelState extends ConsumerState<ShadowingPanel> {
  late List<String> _lines = Dictation.lines(widget.transcript);
  int _index = 0;
  bool _listening = false;
  String _heard = '';

  /// Kết quả tốt nhất của từng câu.
  final _results = <int, DictationResult>{};
  DictationResult? _last;

  SpeechService get _speech => ref.read(speechServiceProvider);

  @override
  void didUpdateWidget(ShadowingPanel old) {
    super.didUpdateWidget(old);
    if (old.transcript != widget.transcript) {
      _speech.cancel();
      setState(() {
        _lines = Dictation.lines(widget.transcript);
        _index = 0;
        _listening = false;
        _heard = '';
        _results.clear();
        _last = null;
      });
    }
  }

  @override
  void dispose() {
    if (_listening) _speech.cancel();
    super.dispose();
  }

  void _go(int i) {
    if (_listening) _speech.cancel();
    setState(() {
      _index = i;
      _listening = false;
      _heard = '';
      _last = null;
    });
  }

  Future<void> _playSample() async {
    await widget.onBeforeSpeak?.call();
    await ref.read(ttsServiceProvider).speak(_lines[_index]);
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      await _speech.stop();
      return;
    }
    await widget.onBeforeSpeak?.call();
    await ref.read(ttsServiceProvider).stop();
    final index = _index;
    setState(() {
      _heard = '';
      _last = null;
      _listening = true;
    });
    final started = await _speech.listen(
      onText: (words, _) {
        if (mounted && _index == index) setState(() => _heard = words);
      },
      onDone: () {
        if (mounted && _index == index) _score(index);
      },
      onError: (message) {
        if (mounted) showAppSnackBar(context, message, tone: AppTone.danger);
      },
    );
    if (!started && mounted) {
      setState(() => _listening = false);
      showAppSnackBar(
        context,
        'Chưa dùng được micro. Hãy cho phép micro và nhận dạng giọng nói cho Bami TOEIC trong Cài đặt.',
        tone: AppTone.warning,
      );
    }
  }

  void _score(int index) {
    setState(() {
      _listening = false;
      if (_heard.trim().isEmpty) return;
      final r = Dictation.check(_lines[index], _heard);
      _last = r;
      if (r.ratio >= (_results[index]?.ratio ?? -1)) _results[index] = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lines.isEmpty) return const SizedBox.shrink();
    final muted = context.colors.onSurfaceVariant;
    final done = _results.length;
    final avg = done == 0 ? 0.0 : _results.values.fold(0.0, (s, r) => s + r.ratio) / done;
    final last = _index == _lines.length - 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Câu ${_index + 1}/${_lines.length}',
                style: context.textStyles.labelLarge?.copyWith(color: muted),
              ),
            ),
            if (done > 0)
              StatusBadge(
                label: 'Đã nói $done câu · TB ${Fmt.percent(avg)}',
                tone: AppTone.fromRatio(avg),
                icon: AppTone.fromRatio(avg).icon,
              ),
          ],
        ),
        Gaps.v8,
        if (_last case final r?)
          _Tokens(result: r)
        else
          Text(_lines[_index], style: context.textStyles.bodyLarge),
        if (_listening || (_last == null && _heard.isNotEmpty)) ...[
          Gaps.v8,
          IconLabel(
            icon: Icons.graphic_eq_rounded,
            label: _heard.isEmpty ? 'Đang nghe… hãy đọc to câu trên' : _heard,
            color: context.colors.primary,
          ),
        ],
        if (_last case final r?) ...[
          Gaps.v12,
          LabeledProgress(
            label: 'Độ khớp',
            value: r.ratio,
            trailing: '${r.correct}/${r.total} từ · ${Fmt.percent(r.ratio)}',
          ),
          Gaps.v8,
          Text(
            'Máy nghe được: "${_heard.trim()}"',
            style: context.textStyles.bodySmall?.copyWith(
              color: muted,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
        Gaps.v12,
        Row(
          children: [
            IconButton(
              tooltip: 'Câu trước',
              onPressed: _index == 0 ? null : () => _go(_index - 1),
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.volume_up_outlined, size: AppSizes.iconSm),
                label: const Text('Nghe mẫu'),
                onPressed: _listening ? null : _playSample,
              ),
            ),
            Gaps.h8,
            Expanded(
              child: FilledButton.icon(
                icon: Icon(
                  _listening ? Icons.stop_rounded : Icons.mic_rounded,
                  size: AppSizes.iconSm,
                ),
                label: Text(_listening ? 'Dừng' : (_last == null ? 'Nói theo' : 'Nói lại')),
                onPressed: _toggleMic,
              ),
            ),
            IconButton(
              tooltip: 'Câu sau',
              onPressed: last ? null : () => _go(_index + 1),
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        Gaps.v4,
        Text(
          'Giọng mẫu là giọng đọc của máy. Chấm theo từng từ máy nhận ra, nói rõ và đủ câu nhé.',
          style: context.textStyles.bodySmall?.copyWith(color: muted),
        ),
      ],
    );
  }
}

/// Câu gốc, từ chưa khớp tô đỏ gạch chân (không chỉ dựa vào màu).
class _Tokens extends StatelessWidget {
  const _Tokens({required this.result});

  final DictationResult result;

  @override
  Widget build(BuildContext context) {
    final danger = AppTone.danger.colorsOf(context);
    return Text.rich(
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
                    ),
            ),
        ],
      ),
      style: context.textStyles.bodyLarge,
    );
  }
}
