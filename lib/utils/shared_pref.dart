import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setHighScore(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', value);
  }

  static Future<int> getHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('highScore') ?? 0;
  }
}
