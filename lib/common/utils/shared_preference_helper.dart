
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {

  static final String _isLogin = "isLogin";

  static final String fcmToken = "fcm_token";

  static final String userId = "userId";
  static final String name = "name";
  static final String mobileNumber = "mobileNumber";
  static final String age = "age";
  static final String gender = "gender";
  static final String email = "email";
  static final String dob = "dob";
  static final String profileImage = "profileImage";

  static Future<String> getIsLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_isLogin) ?? 'false';
  }

  static Future<bool> setLogin(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setString(_isLogin, value);
  }

}