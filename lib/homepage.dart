import 'dart:io';
import 'package:flaptron_3000/functions/gameoverdialog.dart';
import 'package:flaptron_3000/model/bird.dart';
import 'package:flaptron_3000/model/player.dart';
import 'package:flaptron_3000/pages/bird_grid_page.dart';
import 'package:flaptron_3000/services/game_handler.dart';
import 'package:flaptron_3000/widgets/taphint.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flaptron_3000/widgets/birdWidget.dart';
import 'level/background_web.dart';

final gameHandler = GameHandler(Player(
    name: 'Test',
    score: 0,
    bird: Bird(
        gifPath: 'assets/gifs/bird.gif',
        screenXPos: 0.4,
        height: 80,
        width: 80)));

final size =
    MediaQueryData.fromView(PlatformDispatcher.instance.views.first).size;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void dispose() {
    gameHandler.audioManager.dispose();
    super.dispose();
  }

  bool isDesktop() {
    return Platform.isMacOS || Platform.isLinux || Platform.isWindows || kIsWeb;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
        listenable: gameHandler,
        builder: (context, child) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            if (gameHandler.isGameOver) {
              showDialogGameOver(
                  context, gameHandler.player.score, gameHandler.resetGame);
            }
          });
          return Scaffold(
            body: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTapDown: (details) {
                      if (gameHandler.isGamePaused) {
                        gameHandler.resumeGame();
                        return;
                      }
                      if (gameHandler.isMenu) {
                        gameHandler.startGame();
                        return;
                      }
                      if (gameHandler.isPlaying) {
                        gameHandler.jump();
                        return;
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (details.primaryDelta != null &&
                          details.primaryDelta! < 0) {
                        // Only increase speed if swiping right
                        gameHandler.boost();
                      }
                    },
                    child: Stack(
                      children: [
                        const BackgroundImageWeb(),
                        Positioned(
                          top: size.height * gameHandler.player.bird.pos.dy,
                          left: size.height * gameHandler.player.bird.pos.dx,
                          child: BirdWidget(bird: gameHandler.player.bird),
                        ),
                        if (!gameHandler.isPlaying)
                          const TapHintAnimation(birdYAxi: .5),
                        ...gameHandler.obstacleManager.obstacles,
                        ...gameHandler.bitcoinManager.bitcoins
                            .map((bitcoin) => Positioned(
                                  left: bitcoin.pos.dx,
                                  top: bitcoin.pos.dy,
                                  width: 100,
                                  height: 100,
                                  child: bitcoin,
                                ))
                            .toList(),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Text(
                            'High Score: ${gameHandler.player.highScore}',
                            style: const TextStyle(
                                color: Colors.deepOrangeAccent, fontSize: 24),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.width * 0.3,
                          left: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            '${gameHandler.player.score}',
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
                        icon: Icon(gameHandler.audioManager.isMuted
                            ? Icons.volume_off
                            : Icons.volume_up),
                        onPressed: () {
                          gameHandler.audioManager.toggleMute();
                        },
                      ),
                      IconButton(
                        icon: Icon(gameHandler.isGamePaused
                            ? Icons.play_arrow
                            : Icons.pause),
                        onPressed: () {
                          gameHandler.togglePauseGame();
                        },
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          gameHandler.pauseGame();
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
        });
  }
}
