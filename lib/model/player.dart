import 'package:flaptron_3000/model/bird.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';

class Player {
  String name;
  int score;
  Bird bird;
  int highScore;

  Player({required this.name, required this.score, required this.bird})
      : highScore = LocalStorage.getHighScore();

  void increasementScore() {
    score++;
  }

  void decreaseScore() {
    score--;
  }

  void resetScore() {
    score = 0;
  }

  void incresase(int value) {
    score += value;
  }

  void setHighscore() {
    if (score > highScore) {
      highScore = score;
      LocalStorage.setHighScore(highScore);
    }
  }
}
