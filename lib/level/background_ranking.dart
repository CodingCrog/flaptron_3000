import 'package:flutter/material.dart';

class BackgroundRanking extends StatelessWidget {
  const BackgroundRanking({super.key});

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
            image: AssetImage('assets/images/background_web3.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
