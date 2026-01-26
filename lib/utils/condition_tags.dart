import 'package:flutter/material.dart';
import 'package:off_training_note/models/tech_memo.dart';

class ConditionTagStyle {
  final String label;
  final Color background;
  final Color text;
  final Color border;

  const ConditionTagStyle({
    required this.label,
    required this.background,
    required this.text,
    required this.border,
  });
}

class ConditionTags {
  static ConditionTagStyle? style(MemoCondition condition) {
    switch (condition) {
      case MemoCondition.snow:
        return ConditionTagStyle(
          label: '雪',
          background: Colors.blue.shade50,
          text: Colors.blue.shade700,
          border: Colors.blue.shade200,
        );
      case MemoCondition.brush:
        return ConditionTagStyle(
          label: 'ブラシ',
          background: Colors.green.shade50,
          text: Colors.green.shade700,
          border: Colors.green.shade200,
        );
      case MemoCondition.trampoline:
        return ConditionTagStyle(
          label: 'トランポリン',
          background: Colors.orange.shade50,
          text: Colors.orange.shade700,
          border: Colors.orange.shade200,
        );
      case MemoCondition.none:
        return null;
    }
  }
}
