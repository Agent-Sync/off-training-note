import 'package:flutter/material.dart';
import 'package:off_training_note/theme/app_theme.dart';

class TwoOptionToggle extends StatelessWidget {
  final String leftLabel;
  final String rightLabel;
  final bool isLeftSelected;
  final bool enabled;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const TwoOptionToggle({
    super.key,
    required this.leftLabel,
    required this.rightLabel,
    required this.isLeftSelected,
    required this.onLeftTap,
    required this.onRightTap,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ToggleButton(
          text: leftLabel,
          isSelected: isLeftSelected,
          onTap: enabled ? onLeftTap : null,
          enabled: enabled,
        ),
        const SizedBox(width: 12),
        _ToggleButton(
          text: rightLabel,
          isSelected: !isLeftSelected,
          onTap: enabled ? onRightTap : null,
          enabled: enabled,
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool enabled;

  const _ToggleButton({
    required this.text,
    required this.isSelected,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    final buttonEnabled = enabled;
    final backgroundColor = buttonEnabled
        ? (isSelected ? Colors.white : Colors.grey.shade100)
        : Colors.grey.shade50;
    final borderColor = buttonEnabled && isSelected
        ? AppTheme.focusColor.withValues(alpha: 0.5)
        : Colors.transparent;
    final textColor = buttonEnabled
        ? (isSelected ? AppTheme.focusColor : AppTheme.textHint)
        : AppTheme.textHint;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: buttonEnabled && isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.focusColor.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
