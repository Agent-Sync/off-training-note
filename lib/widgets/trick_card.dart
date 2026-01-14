import 'package:flutter/material.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/utils/trick_helpers.dart';
import 'package:timeago/timeago.dart' as timeago;

class TrickCard extends StatelessWidget {
  final Trick trick;
  final VoidCallback onTap;

  const TrickCard({
    super.key,
    required this.trick,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final latestLog = trick.logs.isNotEmpty ? trick.logs.first : null;
    final name = trick.displayName();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
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
            // Title
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppTheme.textMain,
              ),
            ),
            const SizedBox(height: 12),

            if (latestLog != null) ...[
              // Log Content Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade50.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Focus
                    const Text(
                      '意識',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.focusColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      latestLog.focus,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMain,
                        height: 1.4,
                      ),
                    ),

                    // Divider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                              child:
                                  Container(height: 1, color: Colors.grey.shade300)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.arrow_downward,
                                size: 12, color: Colors.grey),
                          ),
                          Expanded(
                              child:
                                  Container(height: 1, color: Colors.grey.shade300)),
                        ],
                      ),
                    ),

                    // Outcome
                    const Text(
                      'どう変わったか',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.outcomeColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      latestLog.outcome,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textMain,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    timeago.format(latestLog.createdAt, locale: 'ja'),
                    style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade100),
                    ),
                    child: Text(
                      '${trick.logs.length} notes',
                      style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Empty State
              Container(
                width: double.infinity,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: Colors.grey.shade100, style: BorderStyle.solid),
                ),
                child: const Center(
                  child: Text(
                    'メモなし',
                    style: TextStyle(fontSize: 12, color: AppTheme.textHint),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
