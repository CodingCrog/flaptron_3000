import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:lottie/lottie.dart';

class BitCoin extends StatefulWidget {
  BitCoin({required this.pos, super.key});
  Offset pos;

  @override
  State<BitCoin> createState() => _BitCoinState();
}

class _BitCoinState extends State<BitCoin> {
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
