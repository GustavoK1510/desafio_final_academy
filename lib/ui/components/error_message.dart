import 'package:flutter/material.dart';

/// Component for error messages
class ErrorMessage extends StatelessWidget {

  /// Class constructor
  const ErrorMessage({
    super.key,
    required this.message,
  });

  /// Message
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Text(
        message,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }
}