import 'package:arfoon_note/client/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppTheme { light, dark, system }

class ThemeState {
  final String _key = 'themeMode';

  Future<AppTheme> loadTheme([Filter? filter]) async {
    final prefs = await SharedPreferences.getInstance();
    final storedTheme = prefs.getString(_key);

    switch (storedTheme) {
      case 'dark':
        return AppTheme.dark;
      case 'light':
        return AppTheme.light;
      default:
       return AppTheme.system;
    }
  }

  Future<void> saveTheme(AppTheme themeState)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, themeState.name);
  }
  
}
