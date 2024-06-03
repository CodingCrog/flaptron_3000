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
    this.height = 80,
    this.width = 80,
    this.screenXPos = 0.4,
    this.coins = 0.0,
    this.dead = false,
    Offset? pos,
  }) : pos = pos ?? Offset(screenXPos, 0.5);
}
