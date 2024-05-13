import 'dart:math';
import 'package:flutter/material.dart';

class Obstacle extends StatelessWidget {
  final double gapHeight; // Gap between top and bottom obstacles
  final double topHeight; // Height of the top obstacle
  final double bottomHeight; // Height of the bottom obstacle
  final double xPos; // Horizontal position of the obstacle
  final double width;

  // Expanded list of colors including futuristic pink and purple
  final List<Color> colors = const [
    Color(0xFF1CC0FF), // Teal
    Color(0xFFB131FA), // Dark Blue
    Color(0xFF4A0074), // Dark Grey
    Color(0xFF1C3AFF),
    Colors.white,
    Colors.black, // Futuristic Pink
    //Color(0xFF9C27B0), // Futuristic Purple
  ];

  const Obstacle(
      {Key? key,
      required this.gapHeight,
      required this.topHeight,
      required this.bottomHeight,
      required this.xPos,
      required this.width})
      : super(key: key);

  // Function to get a random gradient
  List<Color> getRandomGradient() {
    final random = Random();
    // Shuffle colors and take the first three for the gradient
    List<Color> shuffledColors = List.from(colors)..shuffle(random);
    return shuffledColors.take(3).toList();
  }

  @override
  Widget build(BuildContext context) {
    //final topGradient = getRandomGradient();
    //final bottomGradient = getRandomGradient();

    return Positioned(
      left: xPos,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: 60, // Obstacle width
            height: topHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
              color: Colors.lightGreen,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ), // Rounded corners at the top
            ),
          ),
          SizedBox(height: gapHeight), // Gap between obstacles
          AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            width: width, // Obstacle width
            height: bottomHeight,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 3,
              ),
              color: Colors.lightGreen,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ), // Rounded corners at the bottom
            ),
          ),
        ],
      ),
    );
  }
}
