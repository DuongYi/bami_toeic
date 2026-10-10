import 'package:flutter_tts/flutter_tts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../module/settings/presentation/controllers/settings_controller.dart';

part 'tts_service.g.dart';

/// Phát âm tiếng Anh bằng giọng đọc có sẵn của máy (không cần file audio).
@Riverpod(keepAlive: true)
TtsService ttsService(Ref ref) {
  final speed = ref.watch(ttsSpeedProvider);
  final s = TtsService(FlutterTts(), speed: speed);
  ref.onDispose(s.stop);
  return s;
}

class TtsService {
  TtsService(this._tts, {this.speed = 0.45});

  final FlutterTts _tts;
  final double speed;
  Future<void>? _ready;

  Future<void> _init() async {
    await _tts.setLanguage('en-US');
    // Chậm hơn mặc định một chút cho người học hoặc theo thiết lập.
    await _tts.setSpeechRate(speed);
    await _tts.awaitSpeakCompletion(false);
  }

  /// Lỗi (máy không có giọng tiếng Anh, plugin không hỗ trợ) thì bỏ qua – phát âm là phụ.
  Future<void> speak(String text) async {
    try {
      await (_ready ??= _init());
      await _tts.stop();
      await _tts.speak(text);
    } catch (_) {}
  }

  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
  }
}
