import 'dart:async';

import 'package:flutter/material.dart';

Future<Map<String, String?>> showDisplayNameDialog(BuildContext context) async {
  String name = '';
  String? email;

  Completer<Map<String, String?>> completer = Completer();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey.shade100,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        title: const Center(
          child: Text(
            'Set Display Name',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => name = value,
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email (Optional)',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => email = value.isEmpty ? null : value,
            ),
          ],
        ),
        actions: [
          Center(
            child: TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey.shade100,
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop({'name': name, 'email': email});
              },
              child: const Text(
                'START',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      );
    },
  ).then((value) {
    completer.complete(value);
  });

  return completer.future;
}
