import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/core/trick_masters.dart';
import 'package:off_training_note/models/trick.dart' as trick_model;
import 'package:off_training_note/providers/trick_masters_provider.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/widgets/form/two_option_toggle.dart';
import 'package:off_training_note/widgets/sheet/common/app_bottom_sheet.dart';
import 'package:off_training_note/widgets/sheet/axis_select_sheet.dart';
import 'package:off_training_note/widgets/sheet/grab_select_sheet.dart';
import 'package:off_training_note/widgets/sheet/spin_select_sheet.dart';

class NewTrickModal extends ConsumerStatefulWidget {
  final void Function(
    trick_model.Stance stance,
    trick_model.Takeoff takeoff,
    String axisCode,
    String axisLabel,
    int spin,
    String grabCode,
    String grabLabel,
    trick_model.Direction direction,
  ) onAdd;

  const NewTrickModal({super.key, required this.onAdd});

  @override
  ConsumerState<NewTrickModal> createState() => _NewTrickModalState();
}

class _NewTrickModalState extends ConsumerState<NewTrickModal> {
  trick_model.Stance _stance = trick_model.Stance.regular;
  trick_model.Takeoff _takeoff = trick_model.Takeoff.straight;
  trick_model.Direction _direction = trick_model.Direction.left;
  final TextEditingController _axisController = TextEditingController();
  final TextEditingController _spinController = TextEditingController();
  final TextEditingController _grabController = TextEditingController();
  TrickAxisMaster? _selectedAxis;
  TrickSpinMaster? _selectedSpin;
  TrickGrabMaster? _selectedGrab;
  bool _showValidation = false;

  bool get _isSpinZero => (_selectedSpin?.value ?? -1) == 0;
  bool get _isDirectionDisabled =>
      _isBackOrFront || (_isSpinZero && _stance != trick_model.Stance.switchStance);

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
    final code = _selectedAxis?.code;
    return code == 'backflip' || code == 'frontflip';
  }

  bool get _isAxisMissing {
    return _selectedAxis == null;
  }

  bool get _isSpinMissing {
    return !_isBackOrFront && _selectedSpin == null;
  }

  bool get _isGrabMissing {
    return _selectedGrab == null;
  }

  Widget _buildContent(BuildContext context, TrickMasterData masters) {
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
                  '新しいエアトリック',
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
              leftLabel: trick_model.Stance.regular.labelJa,
              rightLabel: trick_model.Stance.switchStance.labelJa,
              isLeftSelected: _stance == trick_model.Stance.regular,
              onLeftTap: () =>
                  setState(() => _stance = trick_model.Stance.regular),
              onRightTap: () =>
                  setState(() => _stance = trick_model.Stance.switchStance),
            ),
            const SizedBox(height: 16),

            // Takeoff
            _buildSectionLabel('テイクオフ'),
            TwoOptionToggle(
              leftLabel: trick_model.Takeoff.straight.labelJa,
              rightLabel: trick_model.Takeoff.carving.labelJa,
              isLeftSelected: _takeoff == trick_model.Takeoff.straight,
              onLeftTap: () =>
                  setState(() => _takeoff = trick_model.Takeoff.straight),
              onRightTap: () =>
                  setState(() => _takeoff = trick_model.Takeoff.carving),
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
                  options: masters.axes
                      .map((axis) => axis.labelJa)
                      .toList(growable: false),
                  selectedValue: _selectedAxis?.labelJa,
                  onSelected: (value) {
                    final axis = masters.axes.firstWhere(
                      (axis) => axis.labelJa == value,
                      orElse: () => masters.axes.first,
                    );
                    final zeroSpin = masters.spins.firstWhere(
                      (spin) => spin.value == 0,
                      orElse: () => masters.spins.first,
                    );
                    setState(() {
                      _selectedAxis = axis;
                      _axisController.text = axis.labelJa;
                      if (_isBackOrFront) {
                        _selectedSpin = zeroSpin;
                        _spinController.text = zeroSpin.labelJa;
                        _direction = trick_model.Direction.none;
                      } else if (_direction == trick_model.Direction.none) {
                        _direction = trick_model.Direction.left;
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
                    options: masters.spins
                        .map((spin) => spin.labelJa)
                        .toList(growable: false),
                    selectedValue: _selectedSpin?.labelJa,
                    onSelected: (value) {
                      final spin = masters.spins.firstWhere(
                        (spin) => spin.labelJa == value,
                        orElse: () => masters.spins.first,
                      );
                      setState(() {
                        _selectedSpin = spin;
                        _spinController.text = spin.labelJa;
                        if (spin.value == 0 &&
                            _stance != trick_model.Stance.switchStance) {
                          _direction = trick_model.Direction.none;
                        } else if (_direction == trick_model.Direction.none) {
                          _direction = trick_model.Direction.left;
                        }
                      });
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
                  options: masters.grabs
                      .map((grab) => grab.labelJa)
                      .toList(growable: false),
                  selectedValue: _selectedGrab?.labelJa,
                  onSelected: (value) {
                    final grab = masters.grabs.firstWhere(
                      (grab) => grab.labelJa == value,
                      orElse: () => masters.grabs.first,
                    );
                    setState(() {
                      _selectedGrab = grab;
                      _grabController.text = grab.labelJa;
                    });
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
            _buildSectionLabel('方向', enabled: !_isDirectionDisabled),
            TwoOptionToggle(
              leftLabel: trick_model.Direction.left.labelJa,
              rightLabel: trick_model.Direction.right.labelJa,
              isLeftSelected: _direction == trick_model.Direction.left,
              onLeftTap: () =>
                  setState(() => _direction = trick_model.Direction.left),
              onRightTap: () =>
                  setState(() => _direction = trick_model.Direction.right),
              enabled: !_isDirectionDisabled,
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: () {
                setState(() => _showValidation = true);
                if (_isAxisMissing || _isSpinMissing || _isGrabMissing) {
                  return;
                }
                final spinValue = _isBackOrFront ? 0 : (_selectedSpin?.value ?? 0);
                final directionValue =
                    _isBackOrFront ||
                        (spinValue == 0 && _stance != trick_model.Stance.switchStance)
                    ? trick_model.Direction.none
                    : (_direction == trick_model.Direction.none
                          ? trick_model.Direction.left
                          : _direction);

                widget.onAdd(
                  _stance,
                  _takeoff,
                  _selectedAxis?.code ?? '',
                  _selectedAxis?.labelJa ?? '',
                  spinValue,
                  _selectedGrab?.code ?? '',
                  _selectedGrab?.labelJa ?? '',
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

  @override
  Widget build(BuildContext context) {
    final mastersAsync = ref.watch(trickMastersProvider);
    return mastersAsync.when(
      data: (masters) => _buildContent(context, masters),
      loading: () => const AppBottomSheetContainer(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: AppTheme.focusColor),
          ),
        ),
      ),
      error: (error, stack) => const AppBottomSheetContainer(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('読み込みに失敗しました'),
          ),
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
