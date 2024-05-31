import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setHighScore(int value) async {
    await _preferences?.setInt('highScore', value);
  }

  static int getHighScore() {
    return _preferences?.getInt('highScore') ?? 0;
  }

  static bool isDisplayNameSet() {
    return _preferences?.containsKey('displayName') ?? false;
  }

  static Future<void> setDisplayName(String name) async {
    await _preferences?.setString('displayName', name);
  }

  static String? getDisplayName() {
    return _preferences?.getString('displayName');
  }

  static Future<void> setEmail(String email) async {
    await _preferences?.setString('email', email);
  }

  static String? getEmail() {
    return _preferences?.getString('email');
  }
}
