import 'package:flutter/material.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/widgets/common/app_dialog.dart';

Future<bool?> showAppConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'OK',
  String cancelLabel = 'キャンセル',
  bool isDestructive = false,
}) {
  return showAppDialog<bool>(
    context: context,
    barrierLabel: 'app_confirm_dialog',
    builder: (dialogContext) {
      return AppDialog(
        title: title,
        message: message,
        actions: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  cancelLabel,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color:
                        isDestructive ? Colors.red.shade200 : Colors.grey.shade300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                child: Text(
                  confirmLabel,
                  style: TextStyle(
                    color: isDestructive ? Colors.red : AppTheme.textMain,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
