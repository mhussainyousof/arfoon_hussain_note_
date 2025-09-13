import 'package:arfoon_note/client/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeState { light, dark, system }

class ThemeRepo {
  final String _key = 'themeMode';

  Future<ThemeState> loadTheme([Filter? filter]) async {
    final prefs = await SharedPreferences.getInstance();
    final storedTheme = prefs.getString(_key);

    switch (storedTheme) {
      case 'dark':
        return ThemeState.dark;
      case 'light':
        return ThemeState.light;
      default:
       return ThemeState.system;
    }
  }

  Future<void> saveTheme(ThemeState themeState)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, themeState.name);
  }

  
  
}
