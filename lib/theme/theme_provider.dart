import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'theme.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeBoxName = "themeBox";
  static const String _themeModeKey = "themeMode";
  static const String _useSystemThemeKey = "useSystemTheme";

  ThemeMode _themeMode = ThemeMode.light;
  bool _useSystemTheme = false;

  ThemeProvider() {
    _loadThemeMode();
  }

  ThemeMode get themeMode => _useSystemTheme ? ThemeMode.system : _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  bool get useSystemTheme => _useSystemTheme;

  void toggleTheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    _saveThemeMode();
    notifyListeners();
  }

  void toggleSystemTheme(bool value) {
    _useSystemTheme = value;
    _saveThemeMode();
    notifyListeners();
  }

  ThemeData get themeData {
    return _themeMode == ThemeMode.light ? lightMode : darkMode;
  }

  void _loadThemeMode() async {
    var box = await Hive.openBox(_themeBoxName);
    String? themeModeString = box.get(_themeModeKey);
    if (themeModeString != null) {
      _themeMode = ThemeMode.values.firstWhere((e) => e.toString() == themeModeString);
    }
    _useSystemTheme = box.get(_useSystemThemeKey, defaultValue: false);
    notifyListeners();
  }

  void _saveThemeMode() async {
    var box = await Hive.openBox(_themeBoxName);
    box.put(_themeModeKey, _themeMode.toString());
    box.put(_useSystemThemeKey, _useSystemTheme);
  }
}
