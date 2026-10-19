import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../module/settings/presentation/controllers/settings_controller.dart';

part 'tts_service.g.dart';

/// Phát âm tiếng Anh bằng giọng đọc có sẵn của máy (không cần file audio).
@Riverpod(keepAlive: true)
TtsService ttsService(Ref ref) {
  final speed = ref.watch(ttsSpeedProvider);
  final accent = ref.watch(ttsAccentProvider);
  final s = TtsService(FlutterTts(), speed: speed, accent: accent);
  ref.onDispose(s.stop);
  return s;
}

class TtsService {
  TtsService(this._tts, {this.speed = 0.45, this.accent = TtsAccent.us});

  final FlutterTts _tts;
  final double speed;
  final TtsAccent accent;
  Future<void>? _ready;

  /// Giọng máy có cài (chế độ trộn chỉ xoay giữa các giọng này); luôn có ít nhất en-US.
  List<String> _locales = const ['en-US'];
  String? _current;
  int _turn = 0;

  Future<void> _init() async {
    final wanted = accent.locale == null ? TtsAccent.rotation : [accent.locale!];
    final available = <String>[];
    for (final l in wanted) {
      try {
        if (await _tts.isLanguageAvailable(l) == true) available.add(l);
      } catch (_) {}
    }
    if (available.isNotEmpty) _locales = available;
    // Chậm hơn mặc định một chút cho người học hoặc theo thiết lập.
    await _tts.setSpeechRate(speed);
    await _tts.awaitSpeakCompletion(false);
  }

  /// Lỗi (máy không có giọng tiếng Anh, plugin không hỗ trợ) thì bỏ qua – phát âm là phụ.
  Future<void> speak(String text) async {
    try {
      await (_ready ??= _init());
      await _tts.stop();
      final locale = _locales[_turn++ % _locales.length];
      if (locale != _current) {
        await _tts.setLanguage(locale);
        _current = locale;
      }
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
