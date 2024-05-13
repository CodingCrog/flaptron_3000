import 'package:flaptron_3000/services/bitcoinmanager.dart';
import 'package:flutter/material.dart';

import '../components/obstacles.dart';
import '../components/bird.dart';

bool checkObstacleCollision(BuildContext context, double birdYAxis,
    double birdWidth, double birdHeight, List<Obstacle> obstacles) {
  if (MediaQuery.of(context).size.width * 0.4 - 60 - birdWidth / 2 <=
          obstacles[0].xPos &&
      obstacles[0].xPos <=
          MediaQuery.of(context).size.width * 0.4 + birdWidth / 2) {
    double padding = 10.0; // Reduce the collision size by 5 pixels on all sides
    Rect birdRect = Rect.fromCenter(
      center: Offset(MediaQuery.of(context).size.width * 0.4,
          MediaQuery.of(context).size.height * birdYAxis),
      width: birdWidth - 2 * padding,
      height: birdHeight - 2 * padding,
    );

    for (Obstacle obstacle in obstacles) {
      Rect topObstacleRect = Rect.fromLTWH(
        obstacle.xPos + padding,
        0,
        60 - 2 * padding,
        obstacle.topHeight - padding,
      );

      Rect bottomObstacleRect = Rect.fromLTWH(
        obstacle.xPos + padding,
        MediaQuery.of(context).size.height - obstacle.bottomHeight,
        60 - 2 * padding,
        obstacle.bottomHeight - padding,
      );

      if (birdRect.overlaps(topObstacleRect) ||
          birdRect.overlaps(bottomObstacleRect)) {
        return true;
      }
    }
  }
  return false;
}

int checkBitCoinCollision(BuildContext context, double birdYAxis,
    double birdWidth, double birdHeight, BitcoinManager bitcoinManager) {
  Rect birdRect = Rect.fromCenter(
    center: Offset(MediaQuery.of(context).size.width * 0.4,
        MediaQuery.of(context).size.height * birdYAxis),
    width: birdWidth,
    height: birdHeight,
  );

  int count = 0;

  for (int i = 0; i < bitcoinManager.bitcoins.length; i++) {
    bitcoinManager.bitcoins[i].pos = Offset(
        bitcoinManager.bitcoins[i].pos.dx - 5 * bitcoinManager.speedMultiplier,
        bitcoinManager.bitcoins[i].pos.dy);
    if (bitcoinManager.bitcoins[i].pos.dx <
        MediaQuery.of(context).size.width * 0.4 + 50) {
      bool collides = birdRect.overlaps(
          Rect.fromCircle(center: bitcoinManager.bitcoins[i].pos, radius: 10));
      if (collides) {
        count++; // Increment count for each collision
      }
      if (collides || bitcoinManager.bitcoins[i].pos.dx <= 100) {
        bitcoinManager.bitcoins.removeAt(i);
        i--;
      }
    }
  }

  return count;
}

void checkCollision(
    MyBird bird, BitcoinManager btcManager, List<Obstacle> obstacles) {
  double padding = 10.0; // Reduce the collision size by 5 pixels on all sides
  Rect birdRect = Rect.fromCenter(
    center: Offset(btcManager.screenWidth * bird.pos.dx,
        btcManager.screenHeight * bird.pos.dy),
    width: bird.width - 2 * padding,
    height: bird.height - 2 * padding,
  );
  if (btcManager.screenWidth * bird.pos.dx -
              obstacles[0].width -
              bird.width / 2 <=
          obstacles[0].xPos &&
      obstacles[0].xPos <=
          btcManager.screenWidth * bird.pos.dx + bird.width / 2) {
    for (Obstacle obstacle in obstacles) {
      Rect topObstacleRect = Rect.fromLTWH(
        obstacle.xPos + padding,
        0,
        obstacles[0].width - 2 * padding,
        obstacle.topHeight - padding,
      );

      Rect bottomObstacleRect = Rect.fromLTWH(
        obstacle.xPos + padding,
        btcManager.screenHeight - obstacle.bottomHeight,
        obstacles[0].width - 2 * padding,
        obstacle.bottomHeight - padding,
      );

      if (birdRect.overlaps(topObstacleRect) ||
          birdRect.overlaps(bottomObstacleRect)) {
        bird.onObstacleCollision();
      }
    }
  }

  for (int i = 0; i < btcManager.bitcoins.length; i++) {
    btcManager.bitcoins[i].pos = Offset(
        btcManager.bitcoins[i].pos.dx - 5 * btcManager.speedMultiplier,
        btcManager.bitcoins[i].pos.dy);
    if (btcManager.bitcoins[i].pos.dx <
        btcManager.screenWidth * bird.pos.dx + 50) {
      bool collides = birdRect.overlaps(
          Rect.fromCircle(center: btcManager.bitcoins[i].pos, radius: 20));
      if (collides) {
        bird.onCoinCollision();
      }
      if (collides || btcManager.bitcoins[i].pos.dx <= 0) {
        btcManager.bitcoins.removeAt(i);
        i--;
      }
    }
  }
}
