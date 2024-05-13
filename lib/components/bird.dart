import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:lottie/lottie.dart';

class MyBird extends StatefulWidget {
  final int height = 40;
  final int width = 40;
  static double screenXPos = 0.4; // in percent from the left
  double coins = 0.0;
  bool dead = false;
  Offset pos = Offset(screenXPos, 0.5);
  final ValueNotifier<bool> notify = ValueNotifier(false);

  MyBird({
    super.key,
  });

  void onObstacleCollision() {
    dead = true;
  }

  void onCoinCollision() {
    coins += 1;
  }

  void action(dynamic data) {
    notify.value = data as bool;
  }

  void reset() {
    dead = false;
    coins = 0.0;
    pos = Offset(screenXPos, 0.5);
  }

  @override
  State<MyBird> createState() => _MyBirdState();
}

class _MyBirdState extends State<MyBird> {
  final controller = GifController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          GifView.asset(
            'assets/gifs/bird.gif',
            controller: controller,
            width: 100,
            height: 100,
            frameRate: 10,
          ),
          ValueListenableBuilder(
              valueListenable: widget.notify,
              builder: (context, value, child) {
                return Visibility(
                  visible: value,
                  child: Positioned(
                    left: -50,
                    bottom: -10,
                    child: Lottie.asset(
                      'assets/lottiefiles/speedboost.json',
                      width: 100,
                      height: 60,
                      frameRate: const FrameRate(20),
                    ),
                  ),
                );
              }),
        ],
      ),
    );
    /*  floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.status == GifStatus.playing) {
            controller.pause();
          } else {
            controller.play();
          }
        },
      ); */
  }
}
