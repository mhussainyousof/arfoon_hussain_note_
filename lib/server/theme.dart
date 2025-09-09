import 'package:arfoon_note/client/client.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum NoteTheme { light, dark, system }

class ThemeState {
  final String _key = 'themeMode';

  Future<NoteTheme> loadTheme([Filter? filter]) async {
    final prefs = await SharedPreferences.getInstance();
    final storedTheme = prefs.getString(_key);

    switch (storedTheme) {
      case 'dark':
        return NoteTheme.dark;
      case 'light':
        return NoteTheme.light;
      default:
       return NoteTheme.system;
    }
  }

  Future<void> saveTheme(NoteTheme themeState)async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, themeState.name);
  }
  
}
