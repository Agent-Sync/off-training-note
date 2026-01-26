import 'package:flutter/material.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/utils/condition_tags.dart';
import 'package:off_training_note/widgets/sheet/common/app_bottom_sheet.dart';

class LogFormSheet extends StatefulWidget {
  final void Function(
    String focus,
    String outcome, {
    MemoCondition? condition,
    MemoSize? size,
  })
  onAdd;
  final TechMemo? initialMemo;
  final bool showAirFields;

  const LogFormSheet({
    super.key,
    required this.onAdd,
    this.initialMemo,
    required this.showAirFields,
  });

  @override
  State<LogFormSheet> createState() => _LogFormSheetState();
}

class _LogFormSheetState extends State<LogFormSheet> {
  late final TextEditingController _focusController;
  late final TextEditingController _outcomeController;
  MemoCondition _selectedCondition = MemoCondition.none;
  MemoSize _selectedSize = MemoSize.none;

  bool get _isEditing => widget.initialMemo != null;

  @override
  void initState() {
    super.initState();
    _focusController = TextEditingController(
      text: widget.initialMemo?.focus ?? '',
    );
    _outcomeController = TextEditingController(
      text: widget.initialMemo?.outcome ?? '',
    );
    if (widget.initialMemo != null) {
      widget.initialMemo!.map(
        air: (memo) {
          _selectedCondition = memo.condition;
          _selectedSize = memo.size;
        },
        jib: (_) {},
      );
    }
  }

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
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isEditing ? 'メモを編集' : '新しいメモ',
                    style: const TextStyle(
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
                '意識',
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
                decoration: _inputDecoration('例: 一旦ランディングを見る、肩を水平に...'),
              ),

              const SizedBox(height: 16),
              const Center(
                child: Icon(Icons.arrow_downward, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              // Outcome Input
              const Text(
                'どう変わったか',
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
                decoration: _inputDecoration('例: 後傾着地が直った、カウンターが...'),
              ),

              const SizedBox(height: 24),

              if (widget.showAirFields) ...[
                // Condition Tags
                const Text(
                  '状況タグ（任意）',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildConditionChip(
                      MemoCondition.snow,
                      _selectedCondition == MemoCondition.snow,
                      () {
                        setState(() {
                          _selectedCondition =
                              _selectedCondition == MemoCondition.snow
                              ? MemoCondition.none
                              : MemoCondition.snow;
                        });
                      },
                    ),
                    _buildConditionChip(
                      MemoCondition.brush,
                      _selectedCondition == MemoCondition.brush,
                      () {
                        setState(() {
                          _selectedCondition =
                              _selectedCondition == MemoCondition.brush
                              ? MemoCondition.none
                              : MemoCondition.brush;
                        });
                      },
                    ),
                    _buildConditionChip(
                      MemoCondition.trampoline,
                      _selectedCondition == MemoCondition.trampoline,
                      () {
                        setState(() {
                          _selectedCondition =
                              _selectedCondition == MemoCondition.trampoline
                              ? MemoCondition.none
                              : MemoCondition.trampoline;
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChoiceChip(
                      'スモール(~5m)',
                      _selectedSize == MemoSize.small,
                      () {
                        setState(() {
                          _selectedSize = _selectedSize == MemoSize.small
                              ? MemoSize.none
                              : MemoSize.small;
                        });
                      },
                    ),
                    _buildChoiceChip(
                      'ミドル(~9m)',
                      _selectedSize == MemoSize.middle,
                      () {
                        setState(() {
                          _selectedSize = _selectedSize == MemoSize.middle
                              ? MemoSize.none
                              : MemoSize.middle;
                        });
                      },
                    ),
                    _buildChoiceChip(
                      'ビッグ(10m~)',
                      _selectedSize == MemoSize.big,
                      () {
                        setState(() {
                          _selectedSize = _selectedSize == MemoSize.big
                              ? MemoSize.none
                              : MemoSize.big;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],

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
                                condition: widget.showAirFields
                                    ? _selectedCondition
                                    : null,
                                size:
                                    widget.showAirFields ? _selectedSize : null,
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
                      child: Text(
                        _isEditing ? '更新する' : '追加する',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionChip(
    MemoCondition conditionKey,
    bool selected,
    VoidCallback onSelected,
  ) {
    final style = ConditionTags.style(conditionKey);
    if (style == null) {
      return _buildChoiceChip('なし', selected, onSelected);
    }
    return _buildChoiceChip(
      style.label,
      selected,
      onSelected,
      selectedBackgroundColor: style.background,
      selectedTextColor: style.text,
      selectedBorderColor: style.border,
    );
  }

  Widget _buildChoiceChip(
    String label,
    bool selected,
    VoidCallback onSelected, {
    Color? backgroundColor,
    Color? selectedBackgroundColor,
    Color? textColor,
    Color? selectedTextColor,
    Color? borderColor,
    Color? selectedBorderColor,
  }) {
    final bg = selected
        ? (selectedBackgroundColor ?? AppTheme.primary)
        : (backgroundColor ?? Colors.white);
    final fg = selected
        ? (selectedTextColor ?? Colors.white)
        : (textColor ?? AppTheme.textSecondary);
    final border = selected
        ? (selectedBorderColor ?? Colors.transparent)
        : (borderColor ?? Colors.grey.shade300);

    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
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
