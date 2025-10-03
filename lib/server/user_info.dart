import 'package:arfoon_note/client/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
static const String _userNameKey = 'user_name';
static const String _firstTimeKey = 'first_time';


   Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userNameKey, name);
  }


   Future<String?> getUserName(Filter? filter)async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userNameKey);
  }

  
  static  Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool(_firstTimeKey) ?? true;
    if (isFirstTime) {
      await prefs.setBool(_firstTimeKey, false);
    }
    return isFirstTime;
  }

}