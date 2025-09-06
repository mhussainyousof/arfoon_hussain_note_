import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeState { system, light, dark }

class ThemeCubit extends Cubit<ThemeState> {
   static const _key = 'themeMode';
  ThemeCubit(super.initialState);

  


  static Future<ThemeCubit> loadThemePreference() async{
    final prefs = await SharedPreferences.getInstance();
    final String? storedTheme = prefs.getString(_key);
    ThemeState initialState;

    switch(storedTheme){
      case 'dark':
       initialState = ThemeState.dark;
       break;
      case 'light':
        initialState = ThemeState.light;
        break;
      default:
        initialState = ThemeState.system;
    }
    return ThemeCubit(initialState);
  }

  void setThemeMode(ThemeState themeState)async {
    emit(themeState);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_key, themeState.name);

  }
}
