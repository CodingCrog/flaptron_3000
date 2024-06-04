import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showDialogGameOver(BuildContext context, int score, Function restartGame) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: Center(
          child: Lottie.asset(
            'assets/lottiefiles/rip.json',
            width: 160,
            height: 160,
            frameRate: const FrameRate(20),
            repeat: false,
          ),
        ),
        content: Text(
          'Your score: $score',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18, // Optional: Adjust text size
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade100, padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Adds padding around the text
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                restartGame();
              },
              child: const Text(
                'Play Again',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
}