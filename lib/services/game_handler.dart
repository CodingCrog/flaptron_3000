import 'dart:async';

import 'package:flaptron_3000/functions/checkcollision.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flaptron_3000/services/audiomanager.dart';
import 'package:flaptron_3000/services/bitcoinmanager.dart';
import 'package:flaptron_3000/services/obstacle_manager.dart';
import 'package:flaptron_3000/services/physics_manager.dart';
import 'package:flaptron_3000/services/speed_manager.dart';
import 'package:flutter/material.dart';

enum GameState { MENU, PLAYING, GAMEOVER, PAUSED }

class GameHandler extends ChangeNotifier {
  final Player player;
  double gameTime = 0.0;
  Timer? gameTimer; // is responsible for updating the game constantly (fps)
  GameState gameState = GameState.MENU;
  AudioManager audioManager = AudioManager();
  ObstacleManager obstacleManager = ObstacleManager();
  BitcoinManager bitcoinManager = BitcoinManager();
  PhysicsManager physicsManager = PhysicsManager();

  final int fps = WidgetsBinding
      .instance.platformDispatcher.views.first.display.refreshRate
      .round();
  late final int frameTime = (1000 / fps).round(); // defines the time each frame has
  late final int bitcoinSpawnTime = frameTime *
      fps *
      2; // defines the spawn time of bitcoins. the frametime is multiplied by the fps which should come up to 1000ms this times 2 is 2 seconds
  final double obstacleIncrementPerCoin =
      0.025; // the increment for each coin the player collects

  bool isFallingPaused = false; // used so the bird does not fall when boosting
  bool isSpeedBoostActive = false; // used to check if the speed boost is active

  GameHandler(this.player);
  bool get isGamePaused => gameState == GameState.PAUSED;
  bool get isPlaying => gameState == GameState.PLAYING;
  bool get isGameOver => gameState == GameState.GAMEOVER;
  bool get isMenu => gameState == GameState.MENU;

  void startGame() {
    if (gameState == GameState.MENU) {
      SpeedManager.resetObstacleSpeed();
      physicsManager.resetPhysics(player);
      gameState = GameState.PLAYING;
      audioManager.play("sounds/MegaMan2.mp3");
      obstacleManager.generateObstacle();
      bitcoinManager.spawnRandomBitcoin();
      startGameTimer();
    }
  }

  void resetGame() async {
    gameState = GameState.MENU;
    SpeedManager.resetObstacleSpeed();
    physicsManager.resetPhysics(player);
    audioManager.pause();
    obstacleManager.obstacles.clear();
    bitcoinManager.bitcoins.clear();
    notifyListeners();
  }

  void togglePauseGame() {
    if (gameState == GameState.PLAYING) {
      pauseGame();
    } else if (gameState == GameState.PAUSED) {
      resumeGame();
    }
  }

  void toggleMute(){
    audioManager.toggleMute();
    notifyListeners();
  }

  void pauseGame() {
    gameState = GameState.PAUSED;
    audioManager.pause();
    gameTimer?.cancel();
    notifyListeners();
  }

  void resumeGame() {
    gameState = GameState.PLAYING;
    audioManager.resume();
    startGameTimer();
    notifyListeners();
  }

  void startGameTimer() {
    gameTimer?.cancel();

    final deltaTime =
        frameTime / 1000; // Assume each frame is approximately 16ms
    gameTimer = Timer.periodic(Duration(milliseconds: frameTime), (timer) {
      physicsManager.updatePhysics(deltaTime, isFallingPaused, player);
      updateGame();
    });
  }

  void updateGame() {
    gameTime +=
        frameTime; // add the [frameTime] to the [gameTime] each frame so we get the whole playing time over time

    // Periodically spawn bitcoins
    // Spawn every 2 seconds at 50fps
    if ((gameTime % bitcoinSpawnTime) == 0) {
      bitcoinManager.spawnRandomBitcoin();
    }

    // Move the obstacles and bitcoins
    obstacleManager.moveObstacles();
    bitcoinManager.moveBitcoins();

    // after moving the obstacles and bitcoins, check if the player has collected a coin or collided with an obstacle
    final bitcoinCount = checkBitCoinCollision(
        bird: player.bird, bitcoinManager: bitcoinManager);
    increaseCount(bitcoinCount);

    final obstacleCollision = checkObstacleCollision(
        bird: player.bird, obstacleManager: obstacleManager);
    if (obstacleCollision) {
      player.setHighscore("Test Player");
      player.resetScore();
      player.resetScore();
      gameState = GameState.GAMEOVER;
      gameTimer?.cancel();
    }
    notifyListeners();
  }

  void increaseCount(int bitcoinCount) {
    player.incresase(bitcoinCount);
    increaseSpeedIfRequired(bitcoinCount);
  }

  void increaseSpeedIfRequired(int bitcoinCount) {
    SpeedManager.increaseSpeedBy(
        speed: bitcoinCount * obstacleIncrementPerCoin);
  }

  void jump() {
    physicsManager.jump();
  }

  void boost() {
    if (isSpeedBoostActive) return;
    isSpeedBoostActive = true;
    isFallingPaused = true;
    final currentSpeed = SpeedManager.speedMultiplier;

    SpeedManager.updateObstacleSpeed(
        speed: currentSpeed * 4); // Increase speed significantly
    notifyListeners();

    // Schedule a future to reset the falling and speed after a short duration
    Future.delayed(const Duration(milliseconds: 200), () {
      SpeedManager.updateObstacleSpeed(speed: currentSpeed);
      isSpeedBoostActive = false;
      isFallingPaused = false;
      notifyListeners();
    });
  }
}
