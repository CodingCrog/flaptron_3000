import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TapHintAnimation extends StatelessWidget {
  final double birdYAxi;
  const TapHintAnimation({super.key, required this.birdYAxi});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * birdYAxi + 60,
      left: MediaQuery.of(context).size.width *
          0.5, //
      child: Lottie.asset(
        'assets/lottiefiles/tap.json',
        width: 80,
        height: 80,
        frameRate: const FrameRate(30), // Optional: Adjust based on your animation's needs
      ),
    );
  }
}
