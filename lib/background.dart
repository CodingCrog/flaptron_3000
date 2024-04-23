import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class BackGround extends StatefulWidget {
  const BackGround({super.key});

  @override
  State<BackGround> createState() => _BackGroundState();
}

class _BackGroundState extends State<BackGround> {

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:  0.7,
      child: GifView.asset(
          'assets/gifs/background1.gif',
        frameRate: 20,
        color: Colors.black.withOpacity(0.5), // Adjust opacity to your preference
         colorBlendMode: BlendMode.lighten,
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
