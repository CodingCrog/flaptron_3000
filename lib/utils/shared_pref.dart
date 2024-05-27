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
}
