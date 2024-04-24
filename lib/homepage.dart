import 'dart:async';
import 'dart:math';
import 'package:flaptron_3000/widgets/taphint.dart';
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
  bool showCoinAnimation = false;
  Offset coinAnimationPosition = Offset.zero;
  bool isGamePaused = false;
  int score = 0;
  late BitcoinManager bitcoinManager;
  double gravity = 9.8; // Earth's gravity in m/s^2
  double velocity = 0;
  double jumpStrength = -50; // Upward strength of jump

  void updatePhysics(double deltaTime) {
    velocity += gravity * deltaTime; // Increment velocity by gravity over time
    birdYAxis += velocity * deltaTime; // Update position by velocity over time

    if (birdYAxis > 1) {
      birdYAxis = 1; // Prevent bird from falling below the screen
    }
  }

  @override
  void initState() {
    super.initState();
    bitcoinManager = BitcoinManager(
      screenWidth: 0,
      screenHeight: 0,
    );

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

  void togglePauseGame() {
    if (!isGamePaused) {
      // Pause the game
      jumpTimer?.cancel(); // Stop the game timer
      audioManager.pause(); // Optionally pause the game sound
      isGamePaused = true;
    } else {
      // Resume the game
      jumpTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
        updatePhysics(0.080); // Assume each frame is approximately 16ms
        updateGame();
      });
      audioManager.play("sounds/MegaMan2.mp3"); // Optionally resume the music
      isGamePaused = false;
    }
  }

  void updateGame() {
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
      int collidedCount = checkBitCoinCollision(context, birdYAxis, birdWidth,
          birdHeight, bitcoinManager.bitcoinPositions);
      score += collidedCount *
          10; // Increment score by 10 for each bitcoin collected

      if (birdYAxis >= 1 ||
          checkObstacleCollision(
              context, birdYAxis, birdWidth, birdHeight, obstacles)) {
        jumpTimer?.cancel();
        showDialogGameOver(context, score, restartGame);
      }
    });
  }

  void toggleSound() {
    audioManager.toggleMute();
  }

  void jump() {
    velocity = jumpStrength;
    time = 0; // Reset time each jump
    initialHeight = birdYAxis; // Reset initialHeight to current position
  }

  void restartGame() {
    setState(() {
      birdYAxis = 0.5; // Reset bird position
      time = 0; // Reset time
      initialHeight = 0.5;
      obstacles.clear();
      bitcoinManager.bitcoinPositions.clear();
      score = 0; // Reset score
      gameHasStarted = false; // Allow the game to be started again
    });
  }

  void startGame() {
    if (!gameHasStarted) {
      audioManager.play("sounds/MegaMan2.mp3");
      gameHasStarted = true;
      obstacles.clear();
      bitcoinManager.bitcoinPositions.clear(); // Clear previous bitcoins
      generateObstacle(context, obstacles); // Generate the first obstacle
      bitcoinManager.spawnRandomBitcoin(); // Spawn the first bitcoin
      jumpTimer?.cancel();
      jumpTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
        updatePhysics(0.080); // Assume each frame is approximately 16ms
        updateGame();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!gameHasStarted) {
          startGame();
        } else if (!isGamePaused) {
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
                  if (!gameHasStarted) TapHintAnimation(birdYAxi: birdYAxis),
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
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF212121),
                    Color(0xFF2196F3),
                    Color(0xFF212121),
                  ],
                  // Define the stops for color transition
                  stops: [0.0, 0.5, 1.0],
                  // Define the direction of the gradient, top to bottom
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Text(
                  'Score: $score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(audioManager.isMuted
                      ? Icons.volume_off
                      : Icons.volume_up),
                  onPressed: () {
                    setState(() {
                      audioManager.toggleMute();
                    });
                  },
                ),
                IconButton(
                  icon: Icon(isGamePaused ? Icons.play_arrow : Icons.pause),
                  onPressed: () {
                    setState(() {
                      togglePauseGame();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
