import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:lottie/lottie.dart';

class MyBird extends StatefulWidget {
   bool showSpeedBoost = false;
   MyBird({super.key, required this.showSpeedBoost});


  @override
  State<MyBird> createState() => _MyBirdState();
}

class _MyBirdState extends State<MyBird> {
  final controller = GifController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          GifView.asset(
            'assets/gifs/bird.gif',
            controller: controller,
            width: 80,
            height: 80,
            frameRate: 30,
          ),
          Visibility(
            visible: widget.showSpeedBoost,
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
          ),

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
