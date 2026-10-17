import 'package:flutter/material.dart';

/// Component
class ReadOnlyField extends StatelessWidget {

  /// Class constructor
  const ReadOnlyField({
    required this.label,
    required this.value,
    super.key,
  });

  /// Label
  final String label;

  /// Value
  final String value;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: ValueKey('$label-$value'),
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(),
      ),
    );
  }
}