import 'dart:async';
import 'dart:io';
import 'package:flaptron_3000/pages/bird_grid_page.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';
import 'package:flaptron_3000/widgets/taphint.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flaptron_3000/components/bird.dart';
import 'components/obstacles.dart';
import 'level/background_web.dart';
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
  bool gameHasStarted = false;
  Timer? jumpTimer;
  List<Obstacle> obstacles = [];
  double obstacleXPos = 1.0;
  bool showCoinAnimation = false;
  Offset coinAnimationPosition = Offset.zero;
  bool isGamePaused = false;
  int score = 0;
  late BitcoinManager bitcoinManager;
  double gravity = 1.0; // 120% of display per square-second
  double velocity = -0.2;
  double fallSpeedLimit = 0.5; // 50% of display per second
  double jumpStrength = -0.4; // 50% of display per second
  late double obstacleSpeedMultiplier = startObstacleSpeedMultiplier;
  final double startObstacleSpeedMultiplier = 0.5;
  bool isFallingPaused = false;
  bool showSpeedBoost = false;
  int highScore = 0;
  final int fps = 60;
  late final int frameTime =
      (1000 / fps).round(); // defines the time each frame has
  late final int bitcoinSpawnTime = frameTime *
      fps *
      2; // defines the spawn time of bitcoins. the frametime is multiplied by the fps which should come up to 1000ms this times 2 is 2 seconds
  final double obstacleIncrementPerCoin =
      0.025; // the increment for each coin the player collects
  MyBird bird = MyBird(
      //showSpeedBoost: showSpeedBoost,
      );

  bool isSpeedBoostActive = false;
  void speedBoost() {
    if (isSpeedBoostActive) return;
    isSpeedBoostActive = true;
    final currentSpeed = obstacleSpeedMultiplier;

    updateObstacleSpeed(
        speed: currentSpeed * 4); // Increase speed significantly
    setState(() {
      showSpeedBoost = true;
      isFallingPaused = true; // Ensure this is set to true to pause falling
      bird.action(showSpeedBoost);
    });

    // Schedule a future to reset the falling and speed after a short duration
    Future.delayed(const Duration(milliseconds: 200), () {
      updateObstacleSpeed(speed: currentSpeed);
      setState(() {
        isFallingPaused = false; // Resume normal falling
        showSpeedBoost = false;
        bird.action(showSpeedBoost);
        isSpeedBoostActive = false;
      });
    });
  }

  void resetObstacleSpeed() {
    updateObstacleSpeed(speed: startObstacleSpeedMultiplier);
  }

  void updateObstacleSpeed({double? speed}) {
    if (mounted) {
      setState(() {
        obstacleSpeedMultiplier =
            speed ?? startObstacleSpeedMultiplier; // Reset to normal speed
        bitcoinManager
            .setSpeedMultiplier(obstacleSpeedMultiplier); // Reset bitcoin speed
      });
    }
  }

  void updatePhysics(double deltaTime) {
    if (!isFallingPaused) {
      velocity +=
          gravity * deltaTime; // Increment velocity by gravity over time
    } else {
      velocity =
          0; // Ensure velocity is zeroed to prevent any downward movement
    }
    velocity > fallSpeedLimit ? velocity = fallSpeedLimit : velocity;
    birdYAxis += velocity * deltaTime; // Update position by velocity over time

    bird.pos = Offset(bird.pos.dx, birdYAxis.clamp(0.0, 1.0));
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
    bitcoinManager = BitcoinManager(
      screenWidth: 400,
      screenHeight: 800,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        bitcoinManager.screenWidth = MediaQuery.of(context).size.width;
        bitcoinManager.screenHeight = MediaQuery.of(context).size.height;
      }
    });
  }

  void initPrefs() async {
    await SharedPreferencesHelper.init();
    int savedHighScore = await SharedPreferencesHelper.getHighScore();
    setState(() {
      highScore = savedHighScore;
    });
  }

  void updateHighScore() {
    if (score > highScore) {
      setState(() {
        highScore = score;
        SharedPreferencesHelper.setHighScore(highScore);
      });
    }
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
      setJumptimer();
      audioManager.play("sounds/MegaMan2.mp3");
      isGamePaused = false;
    }
  }

  void updateGame() {
    time += frameTime;

    // Periodically spawn bitcoins
    // Spawn every 2 seconds at 50fps
    if ((time % bitcoinSpawnTime) == 0) {
      bitcoinManager.spawnRandomBitcoin();
    }

    setState(() {
      moveObstacles(context, obstacles, obstacleSpeedMultiplier);

      checkCollision(bird, bitcoinManager, obstacles);

      // Update score based on bitcoin collision
      score = (bird.coins * 10).toInt();

      increaseObstacleSpeedIfRequired();

      if (bird.pos.dy >= 1 || bird.dead) {
        jumpTimer?.cancel();
        showDialogGameOver(context, score, restartGame);
      }
    });
  }

  double lastIncrementCoin = 0;
  void increaseObstacleSpeedIfRequired() {
    // prevent multiple speed boosts for the same coin increment
    if (bird.coins == lastIncrementCoin) {
      return;
    }
    final newSpeed = obstacleSpeedMultiplier + obstacleIncrementPerCoin;
    updateObstacleSpeed(speed: newSpeed);
    lastIncrementCoin = bird.coins;
  }

  void toggleSound() {
    audioManager.toggleMute();
  }

  void jump() {
    velocity = jumpStrength;
    // time = 0; // Reset time each jump
  }

  void restartGame() {
    updateHighScore();
    gameHasStarted = false;
    resetGameStats();
    setState(() {});
  }

  void resetGameStats() {
    bird.reset();
    resetObstacleSpeed();
    velocity = -0.2;
    birdYAxis = 0.5; // Reset bird position
    time = 0; // Reset time
    obstacles.clear();
    bitcoinManager.bitcoins.clear();
    score = 0;
    lastIncrementCoin = 0;
  }

  void startGame() {
    if (!gameHasStarted) {
      resetGameStats();
      audioManager.play("sounds/MegaMan2.mp3");
      gameHasStarted = true;
      generateObstacle(context, obstacles); // Generate the first obstacle
      bitcoinManager.spawnRandomBitcoin(); // Spawn the first bitcoin
      setJumptimer();
    }
  }

  void setJumptimer() {
    jumpTimer?.cancel();

    final deltaTime =
        frameTime / 1000; // Assume each frame is approximately 16ms
    jumpTimer = Timer.periodic(Duration(milliseconds: frameTime), (timer) {
      updatePhysics(deltaTime);
      updateGame();
    });
  }

  bool isDesktop() {
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows || kIsWeb;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTapDown: (details) {
                if (!gameHasStarted) {
                  startGame();
                } else if (!isGamePaused) {
                  jump();
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.primaryDelta != null && details.primaryDelta! < 0) {
                  // Only increase speed if swiping right
                  speedBoost();
                }
              },
              child: Stack(
                children: [
                  const BackgroundImageWeb(),
                  Positioned(
                    top: bitcoinManager.screenHeight * bird.pos.dy - 50,
                    left: bitcoinManager.screenWidth * bird.pos.dx - 50,
                    // Horizontal center
                    width: 100,
                    height: 100,
                    child: bird,
                  ),
                  if (!gameHasStarted) TapHintAnimation(birdYAxi: bird.pos.dy),
                  ...obstacles.map((obs) => obs.build(context)).toList(),
                  ...bitcoinManager.bitcoins
                      .map((bitcoin) => Positioned(
                            left: bitcoin.pos.dx - 50,
                            top: bitcoin.pos.dy - 50,
                            width: 100,
                            height: 100,
                            child: bitcoin,
                          ))
                      .toList(),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Text(
                      'High Score: $highScore',
                      style: const TextStyle(
                          color: Colors.deepOrangeAccent, fontSize: 24),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width * 0.3,
                    left: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      '$score',
                      style: const TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0),
            child: Row(
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
                const Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BirdGridPage()));
                  },
                  icon: const Icon(
                    Icons.diamond_outlined,
                    color: Colors.pink,
                  ),
                  tooltip: 'Bird Gallery',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
