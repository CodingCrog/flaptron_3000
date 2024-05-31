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

  static Future<void> removeDisplayName() async {
    await _preferences?.remove('displayName');
  }

  static String? getDisplayName() {
    return _preferences?.getString('displayName');
  }

  static Future<void> setEmail(String email) async {
    await _preferences?.setString('email', email);
  }

  static Future<void> removeEmail() async {
    await _preferences?.remove('email');
  }

  static String? getEmail() {
    return _preferences?.getString('email');
  }

  static Future<void> setBool(String key, bool value) async {
    await _preferences?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _preferences?.getBool(key);
  }
}
