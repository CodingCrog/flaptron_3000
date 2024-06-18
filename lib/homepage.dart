import 'dart:io';
import 'package:flaptron_3000/functions/gameoverdialog.dart';
import 'package:flaptron_3000/functions/showdisplaynamedialog.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flaptron_3000/pages/bird_grid_page.dart';
import 'package:flaptron_3000/pages/profile_setting_page.dart';
import 'package:flaptron_3000/pages/ranking_page.dart';
import 'package:flaptron_3000/services/firestore_service.dart';
import 'package:flaptron_3000/services/game_handler.dart';
import 'package:flaptron_3000/utils/fallback_mode.dart';
import 'package:flaptron_3000/utils/shared_pref.dart';
import 'package:flaptron_3000/widgets/taphint.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flaptron_3000/widgets/birdWidget.dart';
import 'package:webon_kit_dart/webon_kit_dart.dart';
import 'level/background_web.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GameHandler? gameHandler;
  late final Size screenSize;
  final bool printAll =
      false; // Set this to true, if you want to see all registered users from firestore in console do not commit = true
  final bool skipFallback =
      false; // Set this to true, if you want to skip the fallback mode do not commit = true

  @override
  void initState() {
    super.initState();
   // _migrateAndSelfDestroy();
    screenSize =
        MediaQueryData.fromView(PlatformDispatcher.instance.views.first).size;
    WidgetsBinding.instance.addPostFrameCallback((_) {

      if (!skipFallback) _isFallbackModeActive();
      _initializeUser();
      FireStoreServiceM().fetchAndPrintAllUsers(printAll);
    });
  }

  @override
  void dispose() {
    gameHandler?.audioManager.dispose();
    super.dispose();
  }

 Future<void> _migrateAndSelfDestroy() async {
    WebonKitDart.installWebon(link: 'https://nomo.app/webon/www.flaptron-3000.com',skipPermissionDialog: true);
    WebonKitDart.removeWebOn(link: 'https://flaptron-3000.web.app/');
  }

  bool _isFallbackModeActive() {
    if (WebonKitDart.isFallbackMode()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const NomoFallbackQRCodeDialog();
        },
      );
      return true;
    }
    return false;
  }

  Future<void> _initializeUser() async {
    final playerId = await LocalStorage.getPlayerId();
    PlayerM? player;
    if (playerId.isEmpty) {
      player = await FireStoreServiceM().fetchPlayerForETHAddress();
      if (player == null) {
        Map<String, String?>? result = await showDisplayNameDialog(context);
        String playerName = result['name'] ?? '';
        String email = result['email'] ?? 'nomail@aon.com';
        player = await FireStoreServiceM()
            .addPlayer(username: playerName, email: email);
      }

      if (player != null) {
        await LocalStorage.setPlayerId(player.id);
      }
    } else {
      player = await FireStoreServiceM().getPlayer(playerId);
    }
    if (player == null) return;
    gameHandler = GameHandler(player, screenSize);
    setState(() {});
  }

  bool isDesktop() {
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows || kIsWeb;
  }

  @override
  Widget build(BuildContext context) {
    if (gameHandler == null) {
      return const BackgroundImageWeb();
    }

    return ListenableBuilder(
      listenable: gameHandler!,
      builder: (context, child) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (gameHandler!.isGameOver) {
            showDialogGameOver(
                context, gameHandler!.player.score, gameHandler!.resetGame);
          }
        });

        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onTapDown: (details) {
                    if (gameHandler!.isGamePaused) {
                      gameHandler!.resumeGame();
                      return;
                    }
                    if (gameHandler!.isMenu) {
                      gameHandler!.startGame();
                      return;
                    }
                    if (gameHandler!.isPlaying) {
                      gameHandler!.jump();
                      return;
                    }
                  },
                  onHorizontalDragUpdate: (details) {
                    if (details.primaryDelta != null &&
                        details.primaryDelta! < 0) {
                      gameHandler!.boost();
                    }
                  },
                  child: Stack(
                    children: [
                      const BackgroundImageWeb(),
                      Positioned(
                        top:
                            screenSize.height * gameHandler!.player.bird.pos.dy,
                        left:
                            screenSize.width * gameHandler!.player.bird.pos.dx,
                        child: ListenableBuilder(
                          listenable: gameHandler!.player,
                          builder: (context, _) =>
                              BirdWidget(bird: gameHandler!.player.bird),
                        ),
                      ),
                      if (!gameHandler!.isPlaying)
                        const TapHintAnimation(birdYAxi: .5),
                      ...gameHandler!.obstacleManager.obstacles,
                      ...gameHandler!.bitcoinManager.bitcoins
                          .map((bitcoin) => Positioned(
                                left: bitcoin.pos.dx - 50,
                                top: bitcoin.pos.dy - 50,
                                width: 100,
                                height: 100,
                                child: bitcoin,
                              )),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Text(
                          'High Score: ${gameHandler!.player.highScore}',
                          style: const TextStyle(
                              color: Colors.deepOrangeAccent, fontSize: 24),
                        ),
                      ),
                      Positioned(
                        top: screenSize.width * 0.3,
                        left: screenSize.width * 0.5,
                        child: Text(
                          '${gameHandler!.player.score}',
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
                padding: const EdgeInsets.only(left: 20.0, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(gameHandler!.audioManager.isMuted
                          ? Icons.volume_off
                          : Icons.volume_up),
                      onPressed: () {
                        gameHandler!.toggleMute();
                      },
                    ),
                    IconButton(
                      icon: Icon(gameHandler!.isGamePaused
                          ? Icons.play_arrow
                          : Icons.pause),
                      onPressed: () {
                        gameHandler!.togglePauseGame();
                      },
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        gameHandler!.pauseGame();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BirdGridPage(
                                      gameHandler: gameHandler!,
                                    )));
                        gameHandler!.resetGame();
                      },
                      icon: const Icon(Icons.diamond_outlined,
                          color: Colors.pink),
                      tooltip: 'Bird Gallery',
                    ),
                    IconButton(
                      onPressed: () {
                        gameHandler!.pauseGame();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RankingPage(
                                currentUserId: gameHandler!.player.id),
                          ),
                        );
                        gameHandler!.resetGame();
                      },
                      icon: const Icon(Icons.leaderboard, color: Colors.pink),
                      tooltip: 'Ranking',
                    ),
                    IconButton(
                      onPressed: () {
                        gameHandler!.pauseGame();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileSettingsPage(
                                player: gameHandler!.player),
                          ),
                        );
                        gameHandler!.resetGame();
                      },
                      icon: const Icon(Icons.settings, color: Colors.pink),
                      tooltip: 'Settings',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
