import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/providers/tricks_provider.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/utils/trick_helpers.dart';
import 'package:off_training_note/widgets/new_log_modal.dart';
import 'package:timeago/timeago.dart' as timeago;

class TrickDetailSheet extends ConsumerWidget {
  final Trick trick;

  const TrickDetailSheet({super.key, required this.trick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = trick.displayName();
    final tags = trick.tagLabels();

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 20),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Title Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textMain,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Tags
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: tags.map(_buildTag).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Divider(height: 1, color: Colors.grey.shade200),

              // Content List
              Expanded(
                child: trick.logs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.edit_note,
                                  size: 48, color: Colors.grey.shade300),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'まだメモがありません',
                              style: TextStyle(
                                  color: AppTheme.textHint, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '練習の意識を記録しましょう！',
                              style: TextStyle(
                                  color: AppTheme.textHint, fontSize: 12),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.all(24),
                        itemCount: trick.logs.length + 1, // +1 for spacer
                        itemBuilder: (context, index) {
                          if (index == trick.logs.length) {
                            return const SizedBox(height: 80); // Fab spacer
                          }
                          final log = trick.logs[index];
                          return IntrinsicHeight(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Timeline
                                Column(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: AppTheme.focusColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 2),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.focusColor
                                                .withOpacity(0.3),
                                            blurRadius: 4,
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Container(
                                        width: 2,
                                        color: Colors.grey.shade100,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 16),
                                
                                // Content
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          timeago.format(log.createdAt,
                                              locale: 'ja'),
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.textSecondary,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            border: Border.all(
                                                color: Colors.grey.shade100),
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                                log.focus,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppTheme.textMain,
                                                  height: 1.5,
                                                ),
                                              ),

                                              // Divider
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                        child: Container(
                                                            height: 1,
                                                            color: Colors.grey
                                                                .shade200)),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 8),
                                                      child: Icon(
                                                          Icons.arrow_downward,
                                                          size: 14,
                                                          color: Colors.grey),
                                                    ),
                                                    Expanded(
                                                        child: Container(
                                                            height: 1,
                                                            color: Colors.grey
                                                                .shade200)),
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
                                                log.outcome,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppTheme.textMain,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Bottom Button
              Padding(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  top: 16,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => NewLogModal(
                        onAdd: (focus, outcome) {
                           ref
                              .read(tricksProvider.notifier)
                              .addLog(trick.id, focus, outcome);
                           // Stay on detail sheet, it will update
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: Colors.black.withOpacity(0.3),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'メモを追加',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: AppTheme.textSecondary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
