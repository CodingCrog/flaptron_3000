import 'dart:ui';
import 'package:flaptron_3000/functions/checkcollision.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flaptron_3000/services/audiomanager.dart';
import 'package:flaptron_3000/services/bitcoinmanager.dart';
import 'package:flaptron_3000/services/obstacle_manager.dart';
import 'package:flaptron_3000/services/physics_manager.dart';
import 'package:flaptron_3000/services/speed_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../model/bird.dart';

enum GameState { MENU, PLAYING, GAMEOVER, PAUSED }

class GameHandler extends ChangeNotifier {
  final PlayerM player;
  double gameTime = 0.0;
  Ticker? ticker;
  GameState gameState = GameState.MENU;
  AudioManager audioManager = AudioManager();
  ObstacleManager obstacleManager = ObstacleManager();
  BitcoinManager bitcoinManager = BitcoinManager();
  PhysicsManager physicsManager = PhysicsManager();
  final Size screenSize;

  final int fps = 60;
  late final int frameTime = (1000 / fps).round();
  late final int bitcoinSpawnTime = frameTime * fps * 2;
  final double obstacleIncrementPerCoin = 0.025;

  bool isFallingPaused = false;
  bool isSpeedBoostActive = false;

  GameHandler(this.player, this.screenSize);

  bool get isGamePaused => gameState == GameState.PAUSED;

  bool get isPlaying => gameState == GameState.PLAYING;

  bool get isGameOver => gameState == GameState.GAMEOVER;

  bool get isMenu => gameState == GameState.MENU;

  void startGame() {
    if (gameState == GameState.MENU) {
      player.resetScore();
      SpeedManager.resetObstacleSpeed();
      physicsManager.resetPhysics(player);
      gameState = GameState.PLAYING;
      audioManager.play("sounds/MegaMan2.mp3");
      obstacleManager.generateObstacle(screenSize);
      bitcoinManager.spawnRandomBitcoin();
      startTicker();
    }
  }

  void resetGame() {
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

  void toggleMute() {
    audioManager.toggleMute();
    notifyListeners();
  }

  void pauseGame() {
    gameState = GameState.PAUSED;
    audioManager.pause();
    ticker?.stop();
    notifyListeners();
  }

  void resumeGame() {
    gameState = GameState.PLAYING;
    audioManager.resume();
    startTicker();
    notifyListeners();
  }

  void startTicker() {
    ticker?.stop();
    ticker = Ticker((elapsed) {
      final deltaTime = frameTime / 1000;
      physicsManager.updatePhysics(deltaTime, isFallingPaused, player);
      updateGame();
    });
    ticker?.start();
  }

  void updateGame() {
    gameTime += frameTime;

    if ((gameTime % bitcoinSpawnTime) == 0) {
      bitcoinManager.spawnRandomBitcoin();
    }

    obstacleManager.moveObstacles(screenSize);
    bitcoinManager.moveBitcoins();

    if (isBirdOffScreen(player.bird)) {
      handleGameOver();
    }

    final bitcoinCount = checkBitCoinCollision(
        bird: player.bird, bitcoinManager: bitcoinManager, size: screenSize);
    increaseCount(bitcoinCount);

    final obstacleCollision = checkObstacleCollision(
        bird: player.bird, obstacleManager: obstacleManager, size: screenSize);
    if (obstacleCollision) {
      handleGameOver();
    }

    notifyListeners();
  }

  bool isBirdOffScreen(Bird bird) {
    final dy = bird.pos.dy * screenSize.height;
   // debugPrint('Bird position: $dy, Screen height: ${screenSize.height}');
    return dy <= 0 || dy >= screenSize.height;
  }

  void handleGameOver() {
    player.updateHighScore();
    gameState = GameState.GAMEOVER;
    ticker?.stop();
    notifyListeners();
  }

  void increaseCount(int bitcoinCount) {
    player.increase(bitcoinCount);
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

    SpeedManager.updateObstacleSpeed(speed: currentSpeed * 4);
    notifyListeners();

    Future.delayed(const Duration(milliseconds: 200), () {
      SpeedManager.updateObstacleSpeed(speed: currentSpeed);
      isSpeedBoostActive = false;
      isFallingPaused = false;
      notifyListeners();
    });
  }
}
