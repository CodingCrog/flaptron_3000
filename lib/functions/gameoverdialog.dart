import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

void showDialogGameOver(BuildContext context, int score, Function restartGame) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents closing the dialog by tapping outside of it
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), // Optional: adds rounded corners to the dialog box
        ),
        title: Center(
          child: Lottie.asset(
            'assets/lottiefiles/rip.json',
            width: 160,
            height: 160,
            frameRate: const FrameRate(60), // Optional: Adjust based on your animation's needs
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
                backgroundColor: Colors.orangeAccent, // This ensures the text color contrasts with the button color
                shape: RoundedRectangleBorder( // Rounded corners for the button
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                restartGame(); // Restart game logic
              },
              child: const Text(
                'Play Again',
                style: TextStyle(
                  fontSize: 16, // Adjust the font size according to your design
                ),
              ),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.center, // Center aligns the button within the actions area
      );
    },
  );
}