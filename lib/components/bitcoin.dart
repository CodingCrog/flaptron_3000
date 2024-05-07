import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:lottie/lottie.dart';

class BitCoin extends StatefulWidget {
  const BitCoin({super.key});

  @override
  State<BitCoin> createState() => _BitCoinState();
}

class _BitCoinState extends State<BitCoin> {
  final controller = GifController();
/*
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GifView.asset(
        'assets/gifs/bitcoin.gif',
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
}*/
@override
Widget build(BuildContext context) {
  return SizedBox(
    child: Lottie.asset(
      'assets/lottiefiles/bitcoin.json',
      width: 100,
      height: 100,
      frameRate: const FrameRate(20), // Optional: Adjust based on your animation's needs
    ),
  );
}
}