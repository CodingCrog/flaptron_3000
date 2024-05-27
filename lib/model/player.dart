import 'package:flaptron_3000/model/bird.dart';

class Player {
  String name;
  int score;
  Bird bird;

  Player({required this.name, required this.score, required this.bird});

  void incrementScore() {
    score++;
  }

  void decrementScore() {
    score--;
  }

  void resetScore() {
    score = 0;
  }
}
