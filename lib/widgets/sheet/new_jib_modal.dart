import 'package:flutter/material.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/utils/content_filter.dart';
import 'package:off_training_note/widgets/common/app_banner.dart';
import 'package:off_training_note/widgets/sheet/common/app_bottom_sheet.dart';

class NewJibModal extends StatefulWidget {
  final ValueChanged<String> onAdd;

  const NewJibModal({super.key, required this.onAdd});

  @override
  State<NewJibModal> createState() => _NewJibModalState();
}

class _NewJibModalState extends State<NewJibModal> {
  final TextEditingController _nameController = TextEditingController();
  bool _showValidation = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '新しいジブトリックを追加',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textMain,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(height: 1, color: Colors.grey.shade200),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'トリック名を入力',
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorText: _showValidation && _nameController.text.trim().isEmpty
                  ? '入力してください'
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() => _showValidation = true);
              final name = _nameController.text.trim();
              if (name.isEmpty) {
                return;
              }
              if (containsObjectionableContent(name)) {
                showAppBanner(context, '不適切な内容が含まれています');
                return;
              }
              widget.onAdd(name);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
            child: const Text(
              '作成する',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }
}
