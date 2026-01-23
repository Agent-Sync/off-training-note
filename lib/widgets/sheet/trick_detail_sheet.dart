import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/providers/tricks_provider.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/widgets/dialog/app_confirm_dialog.dart';
import 'package:off_training_note/utils/condition_tags.dart';
import 'package:off_training_note/utils/trick_helpers.dart';
import 'package:off_training_note/widgets/sheet/log_form_sheet.dart';
import 'package:off_training_note/widgets/sheet/common/app_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

class TrickDetailSheet extends ConsumerWidget {
  final Trick trick;

  const TrickDetailSheet({super.key, required this.trick});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTrick = trick.map(
      air: (air) => ref
          .watch(tricksProvider)
          .whereType<AirTrick>()
          .firstWhere((item) => item.id == air.id, orElse: () => air),
      jib: (jib) => ref
          .watch(tricksProvider)
          .whereType<JibTrick>()
          .firstWhere((item) => item.id == jib.id, orElse: () => jib),
    );
    final name = currentTrick.displayName();
    final tags = currentTrick.tagLabels();
    final showAirFields = currentTrick is AirTrick;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return AppBottomSheetContainer(
          useKeyboardInset: false,
          child: Column(
            children: [
              // Title Header
              Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: Text(
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
                      ),
                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        // Tags
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: tags.map(_buildTag).toList(),
                        ),
                      ],
                    ],
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      onPressed: () => _showTrickActionMenu(
                        context,
                        ref,
                        currentTrick,
                      ),
                      style: ButtonStyle(
                        overlayColor:
                            WidgetStateProperty.all(Colors.transparent),
                      ),
                      icon: const Icon(
                        Icons.more_vert,
                        color: Colors.grey,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Divider(height: 1, color: Colors.grey.shade200),

              // Content List
              Expanded(
                child: currentTrick.memos.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.edit_note,
                                size: 48,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'まだメモがありません',
                              style: TextStyle(
                                color: AppTheme.textHint,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              '練習の意識を記録しましょう！',
                              style: TextStyle(
                                color: AppTheme.textHint,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(top: 16, bottom: 24),
                        itemCount:
                            currentTrick.memos.length + 1, // +1 for spacer
                        itemBuilder: (context, index) {
                          if (index == currentTrick.memos.length) {
                            return const SizedBox(height: 80); // Fab spacer
                          }
                          final memo = currentTrick.memos[index];
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
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppTheme.focusColor
                                                .withValues(alpha: 0.3),
                                            blurRadius: 4,
                                          ),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              timeago.format(
                                                memo.createdAt,
                                                locale: 'ja',
                                              ),
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.textSecondary,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Builder(
                                                  builder: (context) {
                                                    final conditionStyle =
                                                        memo.map(
                                                          air: (airMemo) =>
                                                              _getConditionStyle(
                                                                airMemo
                                                                    .condition,
                                                              ),
                                                          jib: (_) => null,
                                                        );
                                                    final sizeLabel = memo.map(
                                                      air: (airMemo) =>
                                                          _getSizeLabel(
                                                            airMemo.size,
                                                          ),
                                                      jib: (_) => null,
                                                    );
                                                    return Wrap(
                                                      spacing: 4,
                                                      children: [
                                                        if (conditionStyle !=
                                                            null)
                                                          _buildLogTag(
                                                            conditionStyle
                                                                .label,
                                                            backgroundColor:
                                                                conditionStyle
                                                                    .background,
                                                            textColor:
                                                                conditionStyle
                                                                    .text,
                                                            borderColor:
                                                                conditionStyle
                                                                    .border,
                                                          ),
                                                        if (sizeLabel != null)
                                                          _buildLogTag(
                                                            sizeLabel,
                                                          ),
                                                      ],
                                                    );
                                                  },
                                                ),
                                                const SizedBox(width: 8),
                                                if (memo.likeCount > 0) ...[
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        memo.likedByMe
                                                            ? Icons.favorite
                                                            : Icons
                                                                .favorite_border,
                                                        size: 14,
                                                        color: memo.likedByMe
                                                            ? Colors.redAccent
                                                            : Colors.grey,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        '${memo.likeCount}',
                                                        style: const TextStyle(
                                                          fontSize: 11,
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                const SizedBox(width: 0),
                                                ],
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.more_vert,
                                                    size: 16,
                                                    color: Colors.grey,
                                                  ),
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  style: ButtonStyle(
                                                    overlayColor:
                                                        WidgetStateProperty.all(
                                                      Colors.transparent,
                                                    ),
                                                  ),
                                                  splashRadius: 20,
                                                  onPressed: () =>
                                                      _showMemoActionMenu(
                                                        context,
                                                        ref,
                                                        memo,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade100,
                                            ),
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
                                                memo.focus,
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
                                                      vertical: 12,
                                                    ),
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        height: 1,
                                                        color: Colors
                                                            .grey
                                                            .shade200,
                                                      ),
                                                    ),
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 8,
                                                          ),
                                                      child: Icon(
                                                        Icons.arrow_downward,
                                                        size: 14,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        height: 1,
                                                        color: Colors
                                                            .grey
                                                            .shade200,
                                                      ),
                                                    ),
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
                                                memo.outcome,
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
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                  top: 16,
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    showAppBottomSheet(
                      context: context,
                      builder: (context) => LogFormSheet(
                        showAirFields: showAirFields,
                        onAdd: (focus, outcome, {condition, size}) {
                          ref
                              .read(tricksProvider.notifier)
                              .addMemo(
                                trick.id,
                                focus,
                                outcome,
                                condition: condition,
                                size: size,
                              );
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
                    shadowColor: Colors.black.withValues(alpha: 0.3),
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

  void _showTrickActionMenu(BuildContext context, WidgetRef ref, Trick trick) {
    showAppBottomSheet(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentTrick = ref
              .watch(tricksProvider)
              .firstWhere((t) => t.id == trick.id, orElse: () => trick);

          return AppBottomSheetContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPublicSwitchItem(context, ref, currentTrick),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPublicSwitchItem(
    BuildContext context,
    WidgetRef ref,
    Trick trick,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.85, end: 1.0)
                      .animate(animation),
                  child: child,
                ),
              );
            },
            child: Icon(
              trick.isPublic ? Icons.lock_open : Icons.lock,
              key: ValueKey<bool>(trick.isPublic),
              color: AppTheme.textMain,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            '公開設定',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textMain,
            ),
          ),
          const Spacer(),
          Switch.adaptive(
            value: trick.isPublic,
            activeThumbColor: Colors.black,
            onChanged: (val) {
              ref
                  .read(tricksProvider.notifier)
                  .updateTrickStatus(trick.id, val);
            },
          ),
        ],
      ),
    );
  }

  void _showMemoActionMenu(BuildContext context, WidgetRef ref, TechMemo memo) {
    showAppBottomSheet(
      context: context,
      builder: (context) => AppBottomSheetContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionItem(
              context,
              icon: Icons.edit_outlined,
              label: 'メモを編集',
              onTap: () {
                Navigator.pop(context); // Close menu
                showAppBottomSheet(
                  context: context,
                  builder: (context) => LogFormSheet(
                    initialMemo: memo,
                    showAirFields: memo is AirTechMemo,
                    onAdd: (focus, outcome, {condition, size}) {
                      final updatedMemo = memo.map(
                        air: (airMemo) => airMemo.copyWith(
                          focus: focus,
                          outcome: outcome,
                          condition: condition ?? MemoCondition.none,
                          size: size ?? MemoSize.none,
                        ),
                        jib: (jibMemo) => jibMemo.copyWith(
                          focus: focus,
                          outcome: outcome,
                        ),
                      );
                      ref
                          .read(tricksProvider.notifier)
                          .updateMemo(trick.id, updatedMemo);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            _buildActionItem(
              context,
              icon: Icons.delete_outline,
              label: 'メモを削除',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context); // Close menu
                _showDeleteMemoConfirmDialog(context, ref, memo);
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteMemoConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    TechMemo memo,
  ) async {
    final shouldDelete = await showAppConfirmDialog(
      context: context,
      title: '本当に削除しますか？',
      message: '削除すると元に戻せません。',
      confirmLabel: '削除',
      cancelLabel: 'キャンセル',
      isDestructive: true,
    );
    if (shouldDelete == true) {
      ref.read(tricksProvider.notifier).deleteMemo(trick.id, memo.id);
    }
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : AppTheme.textMain,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDestructive ? Colors.red : AppTheme.textMain,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
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

  Widget _buildLogTag(
    String label, {
    Color? backgroundColor,
    Color? textColor,
    Color? borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderColor ?? Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor ?? AppTheme.textSecondary,
        ),
      ),
    );
  }

  ConditionTagStyle? _getConditionStyle(MemoCondition condition) {
    return ConditionTags.style(condition);
  }

  String? _getSizeLabel(MemoSize size) {
    switch (size) {
      case MemoSize.small:
        return 'スモール';
      case MemoSize.middle:
        return 'ミドル';
      case MemoSize.big:
        return 'ビッグ';
      case MemoSize.none:
        return null;
    }
  }
}
