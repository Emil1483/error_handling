import 'package:flutter/material.dart';

class ErrorSheet extends StatelessWidget {
  final String message;

  const ErrorSheet(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.grey[300],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.error, color: Colors.red, size: 64.0),
            SizedBox(height: 24.0),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              child: const Text('Ok'),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ),
      ),
    );
  }
}
