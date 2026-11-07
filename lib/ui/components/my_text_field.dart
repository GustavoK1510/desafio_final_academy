import 'package:flutter/material.dart';

/// A text field component
Widget myTextField({
  required TextEditingController controller,
  required String label,
  IconData? icon,
  bool? enabled,
  int? maxLength,
  TextInputType? keyboardType,
}) {
  if(icon != null) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        counterText: '',
      ),
    );
  }
  else {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        counterText: '',
      ),
    );
  }

}