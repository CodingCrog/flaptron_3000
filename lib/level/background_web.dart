import 'package:flutter/material.dart';

class BackgroundImageWeb extends StatelessWidget {
  const BackgroundImageWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background_web.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}