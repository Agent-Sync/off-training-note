import 'package:flutter/material.dart';
import 'package:off_training_note/models/jib_trick.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:timeago/timeago.dart' as timeago;

class JibTrickCard extends StatelessWidget {
  final JibTrick jibTrick;
  final VoidCallback? onTap;

  const JibTrickCard({super.key, required this.jibTrick, this.onTap});

  @override
  Widget build(BuildContext context) {
    final createdAtLabel = timeago.format(jibTrick.createdAt, locale: 'ja');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              jibTrick.customName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              createdAtLabel,
              style: const TextStyle(fontSize: 12, color: AppTheme.textHint),
            ),
          ],
        ),
      ),
    );
  }
}
