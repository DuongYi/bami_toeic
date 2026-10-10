import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../test/data/in_progress_store.dart';

/// Quản lý giao diện: Hệ thống / Sáng / Tối.
class AppThemeModeNotifier extends Notifier<ThemeMode> {
  static const _key = 'settings_theme_mode';

  @override
  ThemeMode build() {
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final value = prefs.getString(_key);
    if (value == 'light') {
      state = ThemeMode.light;
    } else if (value == 'dark') {
      state = ThemeMode.dark;
    } else {
      state = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_key, mode.name);
  }
}

final appThemeModeProvider = NotifierProvider<AppThemeModeNotifier, ThemeMode>(
  AppThemeModeNotifier.new,
);

/// Tốc độ phát âm tiếng Anh (TTS speech rate). Mặc định 0.45.
class TtsSpeedNotifier extends Notifier<double> {
  static const _key = 'settings_tts_speed';
  static const double defaultSpeed = 0.45;
  static const double slowSpeed = 0.35;
  static const double fastSpeed = 0.60;

  @override
  double build() {
    _load();
    return defaultSpeed;
  }

  Future<void> _load() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final val = prefs.getDouble(_key);
    if (val != null) state = val;
  }

  Future<void> setSpeed(double speed) async {
    state = speed;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setDouble(_key, speed);
  }
}

final ttsSpeedProvider = NotifierProvider<TtsSpeedNotifier, double>(
  TtsSpeedNotifier.new,
);

/// Tự động phát âm khi lật thẻ từ vựng flashcard.
class AutoPlayAudioNotifier extends Notifier<bool> {
  static const _key = 'settings_auto_play_audio';

  @override
  bool build() {
    _load();
    return true;
  }

  Future<void> _load() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    final val = prefs.getBool(_key);
    if (val != null) state = val;
  }

  Future<void> setAutoPlay(bool value) async {
    state = value;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setBool(_key, value);
  }
}

final autoPlayAudioProvider = NotifierProvider<AutoPlayAudioNotifier, bool>(
  AutoPlayAudioNotifier.new,
);

/// Quản lý font chữ hiển thị trong app: Manrope, Be Vietnam Pro, Hệ thống.
class AppFontFamilyNotifier extends Notifier<String?> {
  static const _key = 'settings_font_family';
  static const String fontManrope = 'Manrope';
  static const String fontBeVietnamPro = 'Be Vietnam Pro';
  static const String fontSystem = 'system';

  @override
  String? build() {
    _load();
    return fontManrope;
  }

  Future<void> _load() async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    state = prefs.getString(_key) ?? fontManrope;
  }

  Future<void> setFontFamily(String? font) async {
    state = font ?? fontSystem;
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_key, state!);
  }
}

final appFontFamilyProvider = NotifierProvider<AppFontFamilyNotifier, String?>(
  AppFontFamilyNotifier.new,
);
