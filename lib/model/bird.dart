import 'dart:ui';
import 'package:flaptron_3000/model/bird_card.dart';

class Bird {
  BirdCard? birdCard;
  final String gifPath;
  final int height;
  final int width;
  final double screenXPos;
  double coins;
  bool dead;
  Offset pos;

  Bird({
    this.birdCard,
    required this.gifPath,
    this.height = 40,
    this.width = 40,
    required this.screenXPos,
    this.coins = 0.0,
    this.dead = false,
    Offset? pos,
  }) : pos = pos ?? Offset(screenXPos, 0.5);
}
