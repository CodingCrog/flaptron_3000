import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class MyBird extends StatefulWidget {
  const MyBird({super.key});

  @override
  State<MyBird> createState() => _MyBirdState();
}

class _MyBirdState extends State<MyBird> {
  final controller = GifController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GifView.asset(
          'assets/gifs/bird.gif',
          controller: controller,
        width: 80,
        height: 80,
        frameRate: 15,
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
