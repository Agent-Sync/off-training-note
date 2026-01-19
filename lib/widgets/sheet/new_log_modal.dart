import 'package:flutter/material.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/widgets/sheet/common/app_bottom_sheet.dart';

class NewLogModal extends StatefulWidget {
  final Function(String focus, String outcome) onAdd;

  const NewLogModal({super.key, required this.onAdd});

  @override
  State<NewLogModal> createState() => _NewLogModalState();
}

class _NewLogModalState extends State<NewLogModal> {
  final TextEditingController _focusController = TextEditingController();
  final TextEditingController _outcomeController = TextEditingController();

  bool get _isValid =>
      _focusController.text.trim().isNotEmpty &&
      _outcomeController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _focusController.dispose();
    _outcomeController.dispose();
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
                '新しい技術メモ',
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
          const SizedBox(height: 24),

          // Focus Input
          const Text(
            '意識 (Focus)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _focusController,
            onChanged: (_) => setState(() {}),
            maxLines: 3,
            decoration: _inputDecoration('例: 早めにランディングを見る、肩を水平に...'),
          ),

          const SizedBox(height: 16),
          const Center(
            child: Icon(Icons.arrow_downward, color: Colors.grey),
          ),
          const SizedBox(height: 16),

          // Outcome Input
          const Text(
            'どう変わったか (Result)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _outcomeController,
            onChanged: (_) => setState(() {}),
            maxLines: 3,
            decoration: _inputDecoration('例: 回転がスムーズになった、着地が決まった...'),
          ),

          const SizedBox(height: 32),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    'キャンセル',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _isValid
                      ? () {
                          widget.onAdd(
                            _focusController.text,
                            _outcomeController.text,
                          );
                          Navigator.pop(context);
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _isValid ? 4 : 0,
                  ),
                  child: const Text(
                    '追加する',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.textHint),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppTheme.focusColor, width: 2),
      ),
    );
  }
}
