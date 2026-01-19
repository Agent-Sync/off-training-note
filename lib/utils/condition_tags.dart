import 'package:flutter/material.dart';

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
  static const String snow = 'snow';
  static const String brush = 'brush';

  static ConditionTagStyle? style(String? condition) {
    switch (condition) {
      case snow:
        return ConditionTagStyle(
          label: '雪',
          background: Colors.blue.shade50,
          text: Colors.blue.shade700,
          border: Colors.blue.shade200,
        );
      case brush:
        return ConditionTagStyle(
          label: 'ブラシ',
          background: Colors.green.shade50,
          text: Colors.green.shade700,
          border: Colors.green.shade200,
        );
      default:
        return null;
    }
  }
}
