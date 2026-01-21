import 'package:flutter/material.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/widgets/form/two_option_toggle.dart';
import 'package:off_training_note/widgets/sheet/common/app_bottom_sheet.dart';
import 'package:off_training_note/widgets/sheet/axis_select_sheet.dart';
import 'package:off_training_note/widgets/sheet/grab_select_sheet.dart';
import 'package:off_training_note/widgets/sheet/spin_select_sheet.dart';

class NewTrickModal extends StatefulWidget {
  final TrickType type;
  final Function(
    Stance stance,
    Takeoff takeoff,
    String axis,
    int spin,
    String grab,
    Direction direction,
  )
  onAdd;

  const NewTrickModal({super.key, required this.type, required this.onAdd});

  @override
  State<NewTrickModal> createState() => _NewTrickModalState();
}

class _NewTrickModalState extends State<NewTrickModal> {
  Stance _stance = Stance.regular;
  Takeoff _takeoff = Takeoff.standard;
  Direction _direction = Direction.left;
  final TextEditingController _axisController = TextEditingController();
  final TextEditingController _spinController = TextEditingController();
  final TextEditingController _grabController = TextEditingController();
  bool _showValidation = false;

  Future<void> _showAxisSheet({
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) async {
    final selection = await showAppBottomSheet<String>(
      context: context,
      builder: (context) {
        return AppBottomSheetContainer(
          useKeyboardInset: false,
          child: AxisSelectSheet(
            options: options,
            selectedValue: selectedValue,
          ),
        );
      },
    );

    if (selection != null) {
      onSelected(selection);
    }
  }

  Future<void> _showSpinSheet({
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) async {
    final selection = await showAppBottomSheet<String>(
      context: context,
      builder: (context) {
        return AppBottomSheetContainer(
          useKeyboardInset: false,
          child: SpinSelectSheet(
            options: options,
            selectedValue: selectedValue,
          ),
        );
      },
    );

    if (selection != null) {
      onSelected(selection);
    }
  }

  Future<void> _showSearchableOptionSheet({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) async {
    final selection = await showAppBottomSheet<String>(
      context: context,
      builder: (context) {
        return AppBottomSheetContainer(
          useKeyboardInset: true,
          child: GrabSelectSheet(
            options: options,
            selectedValue: selectedValue,
          ),
        );
      },
    );

    if (selection != null) {
      onSelected(selection);
    }
  }

  @override
  void dispose() {
    _axisController.dispose();
    _spinController.dispose();
    _grabController.dispose();
    super.dispose();
  }

  bool get _isBackOrFront {
    return _isBackOrFrontValue(_axisController.text);
  }

  bool get _isAxisMissing {
    return widget.type == TrickType.air && _axisController.text.isEmpty;
  }

  bool get _isSpinMissing {
    return !_isBackOrFront && _spinController.text.isEmpty;
  }

  bool get _isGrabMissing {
    return _grabController.text.isEmpty;
  }

  bool _isBackOrFrontValue(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'バックフリップ' ||
        normalized == 'フロントフリップ' ||
        normalized == 'back flip' ||
        normalized == 'front flip';
  }

  @override
  Widget build(BuildContext context) {
    return AppBottomSheetContainer(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '新しい${widget.type == TrickType.air ? 'エア' : 'ジブ'}トリック',
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
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 24),

            // Stance
            _buildSectionLabel('スタンス'),
            TwoOptionToggle(
              leftLabel: 'レギュラー',
              rightLabel: 'スイッチ',
              isLeftSelected: _stance == Stance.regular,
              onLeftTap: () => setState(() => _stance = Stance.regular),
              onRightTap: () => setState(() => _stance = Stance.switchStance),
            ),
            const SizedBox(height: 16),

            if (widget.type == TrickType.air) ...[
              // Takeoff
              _buildSectionLabel('テイクオフ'),
              TwoOptionToggle(
                leftLabel: 'ストレート',
                rightLabel: 'カービング',
                isLeftSelected: _takeoff == Takeoff.standard,
                onLeftTap: () => setState(() => _takeoff = Takeoff.standard),
                onRightTap: () => setState(() => _takeoff = Takeoff.carving),
              ),
              const SizedBox(height: 16),

              // Axis
              _buildSectionLabel(
                '軸',
                showError: _showValidation && _isAxisMissing,
              ),
              TextField(
                controller: _axisController,
                readOnly: true,
                showCursor: false,
                enableInteractiveSelection: false,
                style: const TextStyle(fontWeight: FontWeight.w600),
                onTap: () {
                  _showAxisSheet(
                    options: Trick.axes,
                    selectedValue: _axisController.text.isEmpty
                        ? null
                        : _axisController.text,
                    onSelected: (value) {
                      setState(() {
                        _axisController.text = value;
                        if (_isBackOrFrontValue(value)) {
                          _spinController.text = '0';
                          _direction = Direction.none;
                        } else if (_direction == Direction.none) {
                          _direction = Direction.left;
                        }
                      });
                    },
                  );
                },
                decoration: _inputDecoration(
                  '軸を選択',
                  showError: _showValidation && _isAxisMissing,
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Spin
            _buildSectionLabel(
              'スピン',
              enabled: !_isBackOrFront,
              showError: _showValidation && _isSpinMissing,
            ),
            AbsorbPointer(
              absorbing: _isBackOrFront,
              child: TextField(
                controller: _spinController,
                readOnly: true,
                showCursor: false,
                enableInteractiveSelection: false,
                style: TextStyle(
                  color: _isBackOrFront
                      ? AppTheme.textHint.withValues(alpha: 0.5)
                      : AppTheme.textMain,
                  fontWeight: FontWeight.w600,
                ),
                onTap: () {
                  _showSpinSheet(
                    options: Trick.spins.map((e) => e.toString()).toList(),
                    selectedValue: _spinController.text.isEmpty
                        ? null
                        : _spinController.text,
                    onSelected: (value) {
                      setState(() => _spinController.text = value);
                    },
                  );
                },
                decoration: _inputDecoration(
                  '回転数を選択',
                  enabled: !_isBackOrFront,
                  showError: _showValidation && _isSpinMissing,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Grab
            _buildSectionLabel(
              'グラブ',
              showError: _showValidation && _isGrabMissing,
            ),
            TextField(
              controller: _grabController,
              readOnly: true,
              showCursor: false,
              enableInteractiveSelection: false,
              style: const TextStyle(fontWeight: FontWeight.w600),
              onTap: () {
                _showSearchableOptionSheet(
                  title: 'グラブを選択',
                  options: Trick.grabs,
                  selectedValue: _grabController.text.isEmpty
                      ? null
                      : _grabController.text,
                  onSelected: (value) {
                    setState(() => _grabController.text = value);
                  },
                );
              },
              decoration: _inputDecoration(
                'グラブを選択',
                showError: _showValidation && _isGrabMissing,
              ),
            ),
            const SizedBox(height: 24),

            // Direction
            _buildSectionLabel('方向', enabled: !_isBackOrFront),
            TwoOptionToggle(
              leftLabel: 'レフト',
              rightLabel: 'ライト',
              isLeftSelected: _direction == Direction.left,
              onLeftTap: () => setState(() => _direction = Direction.left),
              onRightTap: () => setState(() => _direction = Direction.right),
              enabled: !_isBackOrFront,
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                setState(() => _showValidation = true);
                if (_isAxisMissing || _isSpinMissing || _isGrabMissing) {
                  return;
                }
                final spinValue = _isBackOrFront
                    ? 0
                    : int.tryParse(_spinController.text) ?? 0;
                final directionValue = _isBackOrFront
                    ? Direction.none
                    : (_direction == Direction.none
                          ? Direction.left
                          : _direction);

                widget.onAdd(
                  _stance,
                  _takeoff,
                  _axisController.text.trim().isEmpty
                      ? '平軸'
                      : _axisController.text.trim(),
                  spinValue,
                  _grabController.text.isEmpty ? 'なし' : _grabController.text,
                  directionValue,
                );
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
      ),
    );
  }

  Widget _buildSectionLabel(
    String text, {
    bool enabled = true,
    bool showError = false,
  }) {
    final labelColor = enabled
        ? AppTheme.textSecondary
        : AppTheme.textHint.withValues(alpha: 0.5);
    final trailingColor = showError ? Colors.red.shade400 : AppTheme.textHint;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: labelColor,
            ),
          ),
          if (showError)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '選択してください',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: trailingColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(
    String hint, {
    bool enabled = true,
    bool showError = false,
  }) {
    final fillColor = enabled ? Colors.grey.shade50 : Colors.grey.shade100;
    final borderColor = showError ? Colors.red.shade400 : Colors.grey.shade200;
    final focusedColor = showError ? Colors.red.shade400 : AppTheme.focusColor;
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.textHint),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: focusedColor, width: 2),
      ),
    );
  }
}
