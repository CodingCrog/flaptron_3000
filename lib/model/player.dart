import 'package:flaptron_3000/model/bird.dart';
import 'package:flaptron_3000/services/firestore_service.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';
import 'package:flutter/foundation.dart';

class PlayerM with ChangeNotifier {
  final String id;
  final String username;
  final String? email;
  final String? ethAddress;
  Bird bird;
  int score;
  int highScore;

  PlayerM(
      {required this.id,
      required this.username,
      this.email,
      required this.bird,
      this.ethAddress,
      this.highScore = 0})
      : score = 0;


  void decreaseScore() {
    score--;
  }

  void resetScore() {
    score = 0;
  }

  void increase(int value) {
    score += value;
    notifyListeners();
  }

  void updateHighScore() async {
    if (score > highScore) {
      highScore = score;
      LocalStorage.setHighScore(highScore);
      await FireStoreServiceM().updateHighScore(this, highScore);
    }
  }

  void updateBird(String birdPath) {
    bird = Bird(gifPath: birdPath);
    FireStoreServiceM().updateBird(this, birdPath);
    notifyListeners();
  }

  factory PlayerM.fromJson(Map<String, dynamic> json) {
    final birdPath = json['birdPath'] ?? 'assets/gifs/bird.gif';
    return PlayerM(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      bird: Bird(gifPath: birdPath),
      highScore: json['highScore'],
      ethAddress: json['ethAddress'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'highScore': highScore,
      'ethAddress': ethAddress,
      'birdPath': bird.gifPath,
    };
  }
}
