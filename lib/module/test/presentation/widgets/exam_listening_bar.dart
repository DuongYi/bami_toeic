import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/design_system/design_system.dart';
import '../../data/models/test_models.dart';

/// Thi thử: phát liền mạch audio Part 1–4 như phòng thi (không tua, không nghe lại).
/// Mỗi khi sang đoạn audio mới → [onGroupStarted] để màn làm bài nhảy tới nhóm câu đó.
class ExamListeningBar extends StatefulWidget {
  const ExamListeningBar({
    super.key,
    required this.groups,
    required this.startIndex,
    required this.onGroupStarted,
    required this.onFinished,
  });

  /// Toàn bộ nhóm câu của bài làm (chỉ nhóm Part 1–4 có audio được phát).
  final List<QuestionGroup> groups;

  /// Bắt đầu từ nhóm này (khôi phục bài làm dở → phát lại từ đầu đoạn đang dở).
  final int startIndex;
  final ValueChanged<int> onGroupStarted;
  final VoidCallback onFinished;

  /// Các nhóm sẽ được phát, tính từ [start].
  static List<int> playableFrom(List<QuestionGroup> groups, int start) => [
    for (final (i, g) in groups.indexed)
      if (i >= start && g.part <= 4 && g.audioUrl != null) i,
  ];

  @override
  State<ExamListeningBar> createState() => _ExamListeningBarState();
}

class _ExamListeningBarState extends State<ExamListeningBar> {
  final _player = AudioPlayer();
  late final List<int> _playlist = ExamListeningBar.playableFrom(widget.groups, widget.startIndex);
  final _subs = <StreamSubscription<Object?>>[];
  int _track = 0;
  bool _finished = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _subs
      ..add(
        _player.currentIndexStream.listen((i) {
          if (i == null || i >= _playlist.length) return;
          setState(() => _track = i);
          widget.onGroupStarted(_playlist[i]);
        }),
      )
      ..add(
        _player.processingStateStream.listen((s) {
          if (s == ProcessingState.completed && !_finished) {
            _finished = true;
            widget.onFinished();
          }
        }),
      );
    _start();
  }

  Future<void> _start() async {
    try {
      await _player.setAudioSources([
        for (final i in _playlist) AudioSource.uri(Uri.parse(widget.groups[i].audioUrl!)),
      ]);
      await _player.play();
    } catch (_) {
      if (mounted) setState(() => _error = 'Không tải được audio phần nghe');
    }
  }

  @override
  void dispose() {
    for (final s in _subs) {
      s.cancel();
    }
    _player.dispose();
    super.dispose();
  }

  String _label(QuestionGroup g) {
    final first = g.questions.first.number, last = g.questions.last.number;
    return first == last ? 'Câu $first' : 'Câu $first–$last';
  }

  @override
  Widget build(BuildContext context) {
    if (_playlist.isEmpty) return const SizedBox.shrink();
    final muted = context.textStyles.bodySmall?.copyWith(color: context.colors.onSurfaceVariant);
    if (_error != null) {
      return Padding(
        padding: AppInsets.screenH,
        child: AppBanner(message: _error!, tone: AppTone.danger),
      );
    }
    final group = widget.groups[_playlist[_track]];
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.screen, AppSpacing.s8, AppSpacing.screen, 0),
      child: AppCard(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4,
          AppSpacing.s4,
          AppSpacing.s16,
          AppSpacing.s8,
        ),
        child: Column(
          children: [
            Row(
              children: [
                StreamBuilder<bool>(
                  stream: _player.playingStream,
                  builder: (context, snap) {
                    final playing = snap.data ?? false;
                    return IconButton(
                      tooltip: playing ? 'Tạm dừng phần nghe' : 'Phát tiếp phần nghe',
                      icon: Icon(playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                      onPressed: playing ? _player.pause : _player.play,
                    );
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đang phát · ${_label(group)}', style: context.textStyles.titleSmall),
                      Text(
                        'Đoạn ${_track + 1}/${_playlist.length} · không tua lại như thi thật',
                        style: muted,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            StreamBuilder<Duration>(
              stream: _player.positionStream,
              builder: (context, snap) {
                final total = _player.duration?.inMilliseconds ?? 0;
                final pos = snap.data?.inMilliseconds ?? 0;
                return Padding(
                  padding: const EdgeInsets.only(left: AppSpacing.s12),
                  child: AppProgressBar(
                    value: total == 0 ? 0 : (pos / total).clamp(0, 1),
                    tone: AppTone.info,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
