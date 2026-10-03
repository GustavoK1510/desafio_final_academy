import 'package:flutter/material.dart';

import 'marquee_text.dart';

/// Builds a menu card for the home page.
Widget menuCard(
    BuildContext context, {
      required String id,
      required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap,
    }) {
  final theme = Theme.of(context);

  return Card(
    elevation: 10,
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 25,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const Spacer(),
            MarqueeText(
              id: '$id-title',
              text: title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            MarqueeText(
              id: '$id-subtitle',
              text: subtitle,
              speed: 30,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.bottomRight,
              child: Icon(
                Icons.arrow_forward_rounded,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}