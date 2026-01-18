import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'parchment_theme.dart';
import 'pitch_black_theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  bool _isParchmentMode = true;
  SharedPreferences? _prefs;

  ThemeProvider() {
    _loadThemePreference();
  }

  bool get isParchmentMode => _isParchmentMode;

  ThemeData get currentTheme =>
      _isParchmentMode ? buildParchmentTheme() : buildPitchBlackTheme();

  String get themeName => _isParchmentMode ? '羊皮纸模式' : '极夜模式';

  Future<void> _loadThemePreference() async {
    _prefs = await SharedPreferences.getInstance();
    _isParchmentMode = _prefs?.getBool(_themeKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    _isParchmentMode = !_isParchmentMode;
    notifyListeners();
    await _saveThemePreference();
  }

  Future<void> _saveThemePreference() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setBool(_themeKey, _isParchmentMode);
  }

  // 设置为羊皮纸模式
  Future<void> setParchmentMode() async {
    if (!_isParchmentMode) {
      await toggleTheme();
    }
  }

  // 设置为极夜模式
  Future<void> setPitchBlackMode() async {
    if (_isParchmentMode) {
      await toggleTheme();
    }
  }
}