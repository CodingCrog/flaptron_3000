import 'dart:math';

import 'package:flutter/cupertino.dart';

import '../components/obstacles.dart';

void generateObstacle(BuildContext context, List<Obstacle> obstacles) {
  double screenHeight = MediaQuery.of(context).size.height;
  double screenWidth = MediaQuery.of(context).size.width;
  double gapHeight = screenHeight * (0.15 + Random().nextDouble() * 0.1);
  double obstacleTopHeight =
      screenHeight * (0.2 + Random().nextDouble() * 0.15);
  double obstacleBottomHeight = screenHeight - obstacleTopHeight - gapHeight;
  obstacles.add(Obstacle(
    gapHeight: gapHeight,
    topHeight: obstacleTopHeight,
    bottomHeight: obstacleBottomHeight,
    xPos: screenWidth,
  ));
}

void moveObstacles(BuildContext context, List<Obstacle> obstacles) {
  for (int i = 0; i < obstacles.length; i++) {
    Obstacle obs = obstacles[i];
    double newXPos = obs.xPos - 5; // Move obstacles to the left
    obstacles[i] = Obstacle(
      gapHeight: obs.gapHeight,
      topHeight: obs.topHeight,
      bottomHeight: obs.bottomHeight,
      xPos: newXPos,
    );

    // Remove obstacle if it moves off screen
    if (newXPos < -60) {
      obstacles.removeAt(i);
      i--;
      generateObstacle(context, obstacles); // Generate a new obstacle
    }
  }
}
