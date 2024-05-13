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
    width: 60,
  ));
}

void moveObstacles(
    BuildContext context, List<Obstacle> obstacles, double speedMultiplier) {
  double baseMove = 5.0; // Base movement speed to the left

  for (int i = 0; i < obstacles.length; i++) {
    Obstacle obs = obstacles[i];
    double newXPos =
        obs.xPos - (baseMove * speedMultiplier); // Apply speed multiplier here

    obstacles[i] = Obstacle(
      gapHeight: obs.gapHeight,
      topHeight: obs.topHeight,
      bottomHeight: obs.bottomHeight,
      xPos: newXPos,
      width: 60,
    );

    // Remove obstacle if it moves off screen
    if (newXPos < -60) {
      obstacles.removeAt(i);
      i--;
      generateObstacle(context, obstacles); // Generate a new obstacle
    }
  }
}
