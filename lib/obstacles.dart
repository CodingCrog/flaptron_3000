import 'package:flutter/material.dart';

class Obstacle extends StatelessWidget {
  final double gapHeight; // Gap between top and bottom obstacles
  final double topHeight; // Height of the top obstacle
  final double bottomHeight; // Height of the bottom obstacle
  final double xPos; // Horizontal position of the obstacle

  const Obstacle({
    Key? key,
    required this.gapHeight,
    required this.topHeight,
    required this.bottomHeight,
    required this.xPos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: xPos,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            color: Colors.green,
            width: 50, // Obstacle width
            height: topHeight,
          ),
          SizedBox(height: gapHeight), // Gap between obstacles
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 50, // Obstacle width
            height: bottomHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(

                image: AssetImage("assets/images/pipe.jpeg"),
                fit: BoxFit.fitHeight, // This will cover the container without changing the aspect ratio of the image
              ),
            ),
          ),
        ],
      ),
    );
  }
}