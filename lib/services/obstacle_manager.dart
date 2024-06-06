import 'dart:math';

import 'package:flaptron_3000/components/obstacles.dart';
import 'package:flaptron_3000/services/speed_manager.dart';
import 'package:flutter/material.dart';

class ObstacleManager {
  List<Obstacle> obstacles = [];

  void generateObstacle(Size screenSize) {
    double screenHeight = screenSize.height;
    double screenWidth = screenSize.width;
    double gapHeight = screenHeight * (0.15 + Random().nextDouble() * 0.1);
    double obstacleTopHeight = screenHeight * (0.2 + Random().nextDouble() * 0.15);
    double obstacleBottomHeight = screenHeight - obstacleTopHeight - gapHeight;
    obstacles.add(Obstacle(
      gapHeight: gapHeight,
      topHeight: obstacleTopHeight,
      bottomHeight: obstacleBottomHeight,
      xPos: screenWidth,
      width: 60,
    ));
  }

  void moveObstacles(Size screenSize) {
    for (int i = 0; i < obstacles.length; i++) {
      Obstacle obs = obstacles[i];
      double newXPos = obs.xPos - (SpeedManager.speed); // Apply speed multiplier here

      obstacles[i] = Obstacle(
        gapHeight: obs.gapHeight,
        topHeight: obs.topHeight,
        bottomHeight: obs.bottomHeight,
        xPos: newXPos,
        width: obs.width,
      );

      // Remove obstacle if it moves off screen
      if (newXPos < -60) {
        obstacles.removeAt(i);
        i--;
        generateObstacle(screenSize); // Pass screenSize here
      }
    }
  }
}
