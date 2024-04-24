import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flaptron_3000/level/background.dart';
import 'package:flaptron_3000/components/bird.dart';
import 'package:flaptron_3000/level/lowerbackground.dart';
import 'components/bitcoin.dart';
import 'components/obstacles.dart';
import 'services/audiomanager.dart';
import 'services/bitcoinmanager.dart';
import 'functions/checkcollision.dart';
import 'functions/gameoverdialog.dart';
import 'functions/spawnobstacles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AudioManager audioManager = AudioManager();
  double birdYAxis = 0.5; // Initialize position of bird
  double time = 0;
  double initialHeight = 1;
  bool gameHasStarted = false;
  Timer? jumpTimer;
  List<Obstacle> obstacles = [];
  double obstacleXPos = 1.0;
  static const double birdWidth = 40.0;
  static const double birdHeight = 40.0;

  int score = 0;
  late BitcoinManager bitcoinManager;

  @override
  void initState() {
    super.initState();
    // Initialize with default or initial values
    bitcoinManager = BitcoinManager(
      screenWidth: 0,
      screenHeight: 0,
    );

    // Update the dimensions when the context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        bitcoinManager.screenWidth = MediaQuery.of(context).size.width;
        bitcoinManager.screenHeight = MediaQuery.of(context).size.height;
      }
    });
  }

  @override
  void dispose() {
    audioManager.dispose();
    super.dispose();
  }

  void pauseGame() {
    audioManager.pause();
  }

  void toggleSound() {
    audioManager.toggleMute();
  }

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

  void startGame() {
    audioManager.play("MegaMan2.mp3");

    if (!gameHasStarted) {
      gameHasStarted = true;
      obstacles.clear();
      bitcoinManager.bitcoinPositions.clear(); // Clear previous bitcoins
      generateObstacle(context, obstacles); // Generate the first obstacle
      bitcoinManager.spawnRandomBitcoin(); // Spawn the first bitcoin
      jumpTimer?.cancel();
      jumpTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
        time += 0.04;

        // Periodically spawn bitcoins
        if (Random().nextDouble() > 0.95) {
          // Approximately every 2 seconds at 50fps
          bitcoinManager.spawnRandomBitcoin();
        }

        double height = -4.5 * time * time + 1.5 * time;
        setState(() {
          double newY = initialHeight - height;
          birdYAxis = newY.clamp(0.0, 1.0);
          moveObstacles(context, obstacles);
          bitcoinManager.moveBitcoins();

          // Update score based on bitcoin collision
          int collidedCount = checkBitCoinCollision(context, birdYAxis,
              birdWidth, birdHeight, bitcoinManager.bitcoinPositions);
          score += collidedCount *
              10; // Increment score by 10 for each bitcoin collected

          if (birdYAxis >= 1 ||
              checkObstacleCollision(
                  context, birdYAxis, birdWidth, birdHeight, obstacles)) {
            timer.cancel();
            showDialogGameOver(context, score, restartGame);
          }
        });
      });
    }
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
                    left: MediaQuery.of(context).size.width *
                        0.4, // Horizontal center
                    child: const MyBird(),
                  ),
                  ...obstacles.map((obs) => obs.build(context)).toList(),
                  ...bitcoinManager.bitcoinPositions
                      .map((pos) => Positioned(
                            left: pos.dx,
                            top: pos.dy,
                            child: const BitCoin(),
                          ))
                      .toList(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 16),
              child: Text(
                'Score: $score',
              ),
            ), // Display the current score
          ],
        ),
      ),
    );
  }
}
