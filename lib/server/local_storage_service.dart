import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
static const String _userNameKey = 'user_name';
static const String _firstTimeKey = 'first_time';


  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }


  static Future<String?> getUserName()async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool(_firstTimeKey) ?? true;
    if (isFirstTime) {
      await prefs.setBool(_firstTimeKey, false);
    }
    return isFirstTime;
  }

}