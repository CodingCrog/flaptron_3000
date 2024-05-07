import 'package:flutter/material.dart';

import '../components/obstacles.dart';

bool checkObstacleCollision(BuildContext context, double birdYAxis,
    double birdWidth, double birdHeight, List<Obstacle> obstacles) {
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
  return false;
}

int checkBitCoinCollision(BuildContext context, double birdYAxis,
    double birdWidth, double birdHeight, List<Offset> bitcoinPositions) {
  Rect birdRect = Rect.fromCenter(
    center: Offset(MediaQuery.of(context).size.width * 0.4,
        MediaQuery.of(context).size.height * birdYAxis),
    width: birdWidth,
    height: birdHeight,
  );

  int count = 0;
  bitcoinPositions.removeWhere((pos) {
    return pos.dx <= 0;
  });
  bitcoinPositions.removeWhere((pos) {
    bool collides = birdRect.overlaps(Rect.fromCircle(center: pos, radius: 10));
    if (collides) {
      count++; // Increment count for each collision
    }
    return collides;
  });

  return count;
}
