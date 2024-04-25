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
  double jumpStrength = -50;
  double obstacleSpeedMultiplier = 1.0;
  bool isFallingPaused = false;
  bool showSpeedBoost = false;

  void increaseObstacleSpeed() {
    setState(() {
      obstacleSpeedMultiplier = 4; // Increase speed significantly
      bitcoinManager.setSpeedMultiplier(obstacleSpeedMultiplier);
      showSpeedBoost = true;
      isFallingPaused = true; // Ensure this is set to true to pause falling

      // Schedule a future to reset the falling and speed after a short duration
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            obstacleSpeedMultiplier = 1.0; // Reset to normal speed
            bitcoinManager.setSpeedMultiplier(1.0);  // Reset bitcoin speed
            isFallingPaused = false; // Resume normal falling
            showSpeedBoost = false;
          });
        }
      });
    });
  }

  void updatePhysics(double deltaTime) {
    if (!isFallingPaused) {
      velocity += gravity * deltaTime; // Increment velocity by gravity over time
    } else {
      velocity = 0; // Ensure velocity is zeroed to prevent any downward movement
    }
    birdYAxis += velocity * deltaTime; // Update position by velocity over time

    // Clamping birdYAxis to ensure it remains within screen bounds
    if (birdYAxis > 1) {
      birdYAxis = 1;
    } else if (birdYAxis < 0) {
      birdYAxis = 0;
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
      jumpTimer?.cancel();
      audioManager.pause();
      isGamePaused = true;
    } else {
      resetPhysicsState();
      jumpTimer = Timer.periodic(const Duration(milliseconds: 80), (timer) {
        updatePhysics(0.080);
        updateGame();
      });
      audioManager.play("sounds/MegaMan2.mp3");
      isGamePaused = false;
    }
  }

  void resetPhysicsState() {
    velocity = 0;  // Reset velocity when game is resumed
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
      moveObstacles(context, obstacles, obstacleSpeedMultiplier);
      bitcoinManager.moveBitcoins();

      // Update score based on bitcoin collision
      int collidedCount = checkBitCoinCollision(context, birdYAxis, birdWidth,
          birdHeight, bitcoinManager.bitcoinPositions);
      score += collidedCount *
          10; // Increment score by 10 for each bitcoin collected

      if (birdYAxis >= 1  || checkObstacleCollision(context, birdYAxis, birdWidth, birdHeight, obstacles))
        {
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
      gameHasStarted = false;
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
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta != null && details.primaryDelta! > 0) {
          // Only increase speed if swiping right
          increaseObstacleSpeed();
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
                    child: MyBird(showSpeedBoost: showSpeedBoost,),
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
