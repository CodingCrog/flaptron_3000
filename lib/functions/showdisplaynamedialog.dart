import 'dart:async';
import 'package:flutter/material.dart';

Future<Map<String, String?>> showDisplayNameDialog(BuildContext context) {
  Completer<Map<String, String?>> completer = Completer();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return _DisplayNameDialog(completer: completer);
    },
  );

  return completer.future;
}

class _DisplayNameDialog extends StatefulWidget {
  final Completer<Map<String, String?>> completer;

  const _DisplayNameDialog({required this.completer});

  @override
  __DisplayNameDialogState createState() => __DisplayNameDialogState();
}

class __DisplayNameDialogState extends State<_DisplayNameDialog> {
  String name = '';
  String? email;

  @override
  Widget build(BuildContext context) {
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
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Email (Optional)',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              setState(() {
                email = value.isEmpty ? null : value;
              });
            },
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
            onPressed: name.isNotEmpty
                ? () {
              Navigator.of(context).pop();
              widget.completer.complete({'name': name, 'email': email});
            }
                : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    "Please enter a gamer name!",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.orangeAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 150,
                      right: 20,
                      left: 20),
                ),
              );
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
  }
}
