import 'package:flutter/material.dart';
import 'package:off_training_note/widgets/sheet/common/select_sheet.dart';

class SpinSelectSheet extends StatelessWidget {
  final List<String> options;
  final String? selectedValue;

  const SpinSelectSheet({
    super.key,
    required this.options,
    required this.selectedValue,
  });

  @override
  Widget build(BuildContext context) {
    return AppSelectSheet(
      title: 'スピンを選択',
      options: options,
      selectedValue: selectedValue,
      enableSearch: false,
      maxHeightFactor: 0.8,
    );
  }
}
