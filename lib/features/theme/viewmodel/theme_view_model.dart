// lib/features/theme/viewmodels/theme_view_model.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // Constructor
  ThemeViewModel() {
    _loadThemeMode();
  }

  // Metode untuk memuat tema dari Shared Preferences
  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex =
        prefs.getInt('themeMode') ?? 0; // Default ke sistem jika tidak ada data

    _themeMode = ThemeMode.values[themeIndex];
    notifyListeners();
  }

  // Metode untuk mengubah dan menyimpan tema
  void setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();

      // Simpan tema ke Shared Preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('themeMode', mode.index);
    }
  }
}
