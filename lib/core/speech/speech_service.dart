import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_to_text.dart';

part 'speech_service.g.dart';

@Riverpod(keepAlive: true)
SpeechService speechService(Ref ref) {
  final s = SpeechService();
  ref.onDispose(s.cancel);
  return s;
}

/// Nhận dạng giọng nói tiếng Anh (Shadowing) bằng dịch vụ có sẵn của máy.
/// `speech_to_text` chỉ nhận listener ở lần initialize đầu → service giữ listener và chuyển tiếp.
class SpeechService {
  final _stt = SpeechToText();
  Future<bool>? _ready;
  String? _locale;

  void Function()? _onDone;
  void Function(String message)? _onError;

  static bool get supported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  /// Nói xong câu, im lặng bấy lâu thì tự dừng.
  static const _pauseFor = Duration(seconds: 3);
  static const _listenFor = Duration(seconds: 40);

  bool get isListening => _stt.isListening;

  Future<bool> _init() async {
    try {
      final ok = await _stt.initialize(
        onStatus: (s) {
          if (s == SpeechToText.doneStatus || s == SpeechToText.notListeningStatus) {
            final done = _onDone;
            _onDone = null;
            done?.call();
          }
        },
        onError: (SpeechRecognitionError e) {
          // Không nghe thấy gì / hết giờ: kết thúc bình thường, không báo lỗi.
          final quiet = e.errorMsg == 'error_no_match' || e.errorMsg == 'error_speech_timeout';
          if (!quiet) _onError?.call(_message(e.errorMsg));
          final done = _onDone;
          _onDone = null;
          done?.call();
        },
      );
      if (ok) {
        final locales = await _stt.locales();
        String norm(String id) => id.replaceAll('-', '_').toLowerCase();
        _locale =
            locales.where((l) => norm(l.localeId) == 'en_us').firstOrNull?.localeId ??
            locales.where((l) => norm(l.localeId).startsWith('en')).firstOrNull?.localeId;
      }
      return ok;
    } catch (_) {
      return false;
    }
  }

  /// false = máy không hỗ trợ hoặc người dùng chưa cho phép micro / nhận dạng giọng nói.
  Future<bool> listen({
    required void Function(String words, bool isFinal) onText,
    required void Function() onDone,
    required void Function(String message) onError,
  }) async {
    if (!supported) return false;
    final ok = await (_ready ??= _init());
    if (!ok) {
      _ready = null; // cho phép thử lại sau khi người dùng cấp quyền trong Cài đặt
      return false;
    }
    _onDone = onDone;
    _onError = onError;
    await _stt.listen(
      onResult: (r) => onText(r.recognizedWords, r.finalResult),
      listenOptions: SpeechListenOptions(
        partialResults: true,
        listenMode: ListenMode.dictation,
        pauseFor: _pauseFor,
        listenFor: _listenFor,
        localeId: _locale,
      ),
    );
    return true;
  }

  Future<void> stop() async {
    try {
      await _stt.stop();
    } catch (_) {}
  }

  Future<void> cancel() async {
    _onDone = null;
    _onError = null;
    try {
      await _stt.cancel();
    } catch (_) {}
  }

  static String _message(String code) => switch (code) {
    'error_network' ||
    'error_network_timeout' ||
    'error_server' => 'Nhận dạng giọng nói cần mạng. Kiểm tra kết nối rồi thử lại.',
    'error_permission' ||
    'error_insufficient_permissions' => 'Hãy cho phép micro và nhận dạng giọng nói trong Cài đặt.',
    'error_busy' => 'Micro đang bận. Thử lại sau giây lát.',
    _ => 'Không nhận dạng được giọng nói. Thử lại nhé.',
  };
}
