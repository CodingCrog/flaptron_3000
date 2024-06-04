import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class BitCoin extends StatelessWidget {
  Offset pos;
  BitCoin({required this.pos, super.key});

  final controller = GifController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Lottie.asset(
        'assets/lottiefiles/bitcoin.json',
        width: 100,
        height: 100,
        frameRate: const FrameRate(
            20), // Optional: Adjust based on your animation's needs
      ),
    );
  }
}
