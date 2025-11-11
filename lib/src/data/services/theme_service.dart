import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _key = 'theme_mode'; // 'light' | 'dark' | 'system'

  Future<String> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key) ?? 'system';
  }

  Future<void> saveThemeMode(String mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode);
  }
}


