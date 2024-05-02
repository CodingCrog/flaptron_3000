import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

class LowerBackGround extends StatefulWidget {
  const LowerBackGround({super.key});

  @override
  State<LowerBackGround> createState() => _LowerBackGroundState();
}

class _LowerBackGroundState extends State<LowerBackGround> {
  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: GifView.asset(
        'assets/gifs/background1.gif',
        frameRate: 10,
        //color: Colors.black.withOpacity(0.9),
       // colorBlendMode: BlendMode.lighten,
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
