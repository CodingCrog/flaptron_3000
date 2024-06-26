import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:lottie/lottie.dart';
import '../model/bird.dart';

class BirdWidget extends StatelessWidget {
  final Bird bird;
  final ValueNotifier<bool> notify = ValueNotifier(false);

  BirdWidget({
    Key? key,
    required this.bird,
  }) : super(key: key);

  final controller = GifController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Stack(
        children: [
          if (bird.gifPath.startsWith('assets/gifs/')) ...[
            Image.asset(
              bird.gifPath,
              width: bird.width.toDouble(),
              height: bird.height.toDouble(),
            ),
          ] else ...[
            Image.network(
              bird.gifPath,
              width: bird.width.toDouble(),
              height: bird.height.toDouble(),
            ),
          ],
          ValueListenableBuilder(
            valueListenable: notify,
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
            },
          ),
        ],
      ),
    );
  }
}
