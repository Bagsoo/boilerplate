import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme(); // ① build에서 로드
    return ThemeMode.light; // 로드 전 기본값
  }

  static const _key = 'theme_mode';

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false; // 저장된 값 없으면 false(라이트)
    state = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDark() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_key, true);
    state = ThemeMode.dark;
  }

  Future<void> setLight() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(_key, false);
    state = ThemeMode.light;
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(() {
  return ThemeNotifier();
});
