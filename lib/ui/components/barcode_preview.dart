import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';

/// Displays a product barcode.
class BarcodePreview extends StatelessWidget {
  
  /// Class constructor.
  const BarcodePreview({
    required this.value,
    super.key,
  });

  /// Barcode value.
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BarcodeWidget(
          barcode: Barcode.code128(),
          data: value,
          height: 90,
          drawText: true,
          errorBuilder: (context, error) {
            return Text(
              error,
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
              ),
            );
          },
        ),
      ),
    );
  }
}