import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/design_system/design_system.dart';

/// Thanh phát audio cho một nhóm câu hỏi (Part 1-4).
class AudioBar extends StatefulWidget {
  const AudioBar({super.key, required this.url, this.autoPlay = false});

  final String url;
  final bool autoPlay;

  @override
  State<AudioBar> createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  final _player = AudioPlayer();
  String? _error;
  static const _speeds = [0.75, 1.0, 1.25];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(AudioBar old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url) _load();
  }

  Future<void> _load() async {
    try {
      await _player.setUrl(widget.url);
      if (widget.autoPlay) _player.play();
    } catch (e) {
      if (mounted) setState(() => _error = 'Không tải được audio');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) =>
      '${d.inMinutes.remainder(60).toString().padLeft(2, '0')}:${d.inSeconds.remainder(60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    if (_error != null) {
      return Card(
        child: ListTile(
          leading: Icon(Icons.error_outline, color: scheme.error),
          title: Text(_error!),
          trailing: IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _error = null);
              _load();
            },
          ),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4,
          AppSpacing.s4,
          AppSpacing.s12,
          AppSpacing.s4,
        ),
        child: Row(
          children: [
            StreamBuilder<PlayerState>(
              stream: _player.playerStateStream,
              builder: (context, snap) {
                final state = snap.data;
                final loading =
                    state == null ||
                    state.processingState == ProcessingState.loading ||
                    state.processingState == ProcessingState.buffering;
                final completed = state?.processingState == ProcessingState.completed;
                if (loading) {
                  return const Padding(
                    padding: EdgeInsets.all(AppSpacing.s12),
                    child: SizedBox.square(
                      dimension: AppSizes.iconMd,
                      child: CircularProgressIndicator(strokeWidth: AppSizes.strokeThin),
                    ),
                  );
                }
                if (completed) {
                  return IconButton(
                    tooltip: 'Nghe lại',
                    icon: const Icon(Icons.replay),
                    onPressed: () => _player.seek(Duration.zero).then((_) => _player.play()),
                  );
                }
                return IconButton(
                  tooltip: state.playing ? 'Tạm dừng' : 'Phát',
                  icon: Icon(state.playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
                  iconSize: AppSizes.iconLg,
                  onPressed: state.playing ? _player.pause : _player.play,
                );
              },
            ),
            Expanded(
              child: StreamBuilder<Duration>(
                stream: _player.positionStream,
                builder: (context, snap) {
                  final pos = snap.data ?? Duration.zero;
                  final total = _player.duration ?? Duration.zero;
                  final max = total.inMilliseconds.toDouble();
                  return Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: pos.inMilliseconds.clamp(0, max).toDouble(),
                          max: max <= 0 ? 1 : max,
                          onChanged: max <= 0
                              ? null
                              // Vị trí tua, không phải animation.
                              : (v) => _player.seek(Duration(microseconds: (v * 1000).round())),
                        ),
                      ),
                      Text('${_fmt(pos)} / ${_fmt(total)}', style: context.textStyles.labelSmall),
                    ],
                  );
                },
              ),
            ),
            StreamBuilder<double>(
              stream: _player.speedStream,
              builder: (context, snap) {
                final speed = snap.data ?? 1.0;
                return TextButton(
                  onPressed: () {
                    final i = _speeds.indexOf(speed);
                    _player.setSpeed(_speeds[(i + 1) % _speeds.length]);
                  },
                  child: Text('${speed}x'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
