import 'package:flutter/material.dart';

class BackgroundNFT extends StatelessWidget {
  const BackgroundNFT({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Container(
        // Use the entire space of the container
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_web5.png'),
            fit: BoxFit.cover,  // Cover the entire widget space
          ),
        ),
      ),
    );
  }
}