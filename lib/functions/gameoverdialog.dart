import 'package:flutter/material.dart';

void showDialogGameOver(BuildContext context, int score, Function restartGame) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Game Over'),
        content: Text('Your score: ${score.toString()}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              restartGame(); // Restart game logic
            },
            child: const Text('Play Again'),
          ),
        ],
      );
    },
  );
}
