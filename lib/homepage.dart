import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flaptron_3000/background.dart';
import 'package:flaptron_3000/bird.dart';
import 'package:flaptron_3000/lowerbackground.dart';

import 'obstacles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double birdYAxis = 0.5; // Initialize directly
  double time = 0;
  double initialHeight = 1;
  bool gameHasStarted = false;
  Timer? jumpTimer;
  List<Obstacle> obstacles = [];
  double obstacleXPos = 1.0;
  static const double birdWidth = 40.0;
  static const double birdHeight = 40.0;

  void jump() {
    time = 0; // Reset time each jump
    initialHeight = birdYAxis; // Reset initialHeight to current position
  }

  void restartGame() {
    setState(() {
      birdYAxis = 0.5; // Reset bird position
      time = 0; // Reset time
      initialHeight = 0.5; // Reset initial height
      gameHasStarted = false; // Allow the game to be started again
    });
  }

  void showDialogGameOver() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text('Your score: ${time.toStringAsFixed(2)}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                restartGame();  // Restart game logic
              },
              child: const Text('Play Again'),
            ),
          ],
        );
      },
    );

  }

  void startGame() {
    if (!gameHasStarted) {
      gameHasStarted = true;
      obstacles.clear();
      generateObstacle(); // Generate the first obstacle
      jumpTimer?.cancel();
      jumpTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
        time += 0.04;
        double height = -4.5 * time * time + 1.5 * time;

        setState(() {
          double newY = initialHeight - height;
          birdYAxis = newY.clamp(0.0, 1.0);
          moveObstacles(); // Move obstacles each tick

          if (birdYAxis >= 1 || checkCollision()) {
            timer.cancel();
            showDialogGameOver();
          }
        });
      });
    }
  }

  void generateObstacle() {
    double screenHeight = MediaQuery.of(context).size.height;
    double maxTopHeight = screenHeight * 0.4;  // Max height for top obstacle
    double minGapHeight = screenHeight * 0.15; // Min gap height
    double obstacleTopHeight = Random().nextDouble() * (maxTopHeight - minGapHeight) + minGapHeight;
    double gapHeight = screenHeight * (0.15 + Random().nextDouble() * 0.1);
    double obstacleBottomHeight = screenHeight - obstacleTopHeight - gapHeight;

    Obstacle newObstacle = Obstacle(
      gapHeight: gapHeight,
      topHeight: obstacleTopHeight,
      bottomHeight: obstacleBottomHeight,
      xPos: MediaQuery.of(context).size.width,
    );
    obstacles.add(newObstacle);
  }
  void moveObstacles() {
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
        generateObstacle(); // Generate a new obstacle
      }
    }
  }

  bool checkCollision() {
    double padding = 5.0;  // Reduce the collision size by 5 pixels on all sides
    Rect birdRect = Rect.fromLTWH(
      MediaQuery.of(context).size.width * 0.4 + padding,
      MediaQuery.of(context).size.height * birdYAxis + padding,
      birdWidth - 2 * padding,
      birdHeight - 2 * padding,
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

      if (birdRect.overlaps(topObstacleRect) || birdRect.overlaps(bottomObstacleRect)) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!gameHasStarted) {
          startGame();
        } else {
          jump();
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  const Positioned(top: 0, child: LowerBackGround()),
                  const Positioned(bottom: 0, child: BackGround()),
                  Positioned(
                    top: MediaQuery.of(context).size.height * birdYAxis,
                    left: MediaQuery.of(context).size.width * 0.4, // Horizontal center
                    child: const MyBird(),
                  ),
                  ...obstacles,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}