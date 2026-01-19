import 'package:flutter/material.dart';
import 'package:off_training_note/data/constants.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/utils/trick_labels.dart';

class NewTrickModal extends StatefulWidget {
  final TrickType type;
  final Function(
    Stance stance,
    Takeoff? takeoff,
    String? axis,
    int spin,
    String grab,
    Direction? direction,
  ) onAdd;

  const NewTrickModal({
    super.key,
    required this.type,
    required this.onAdd,
  });

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
  final Set<FocusNode> _registeredFocusNodes = <FocusNode>{};
  bool _axisPrimed = false;
  bool _axisEditable = false;
  bool _spinPrimed = false;
  bool _spinEditable = false;
  bool _grabPrimed = false;
  bool _grabEditable = false;

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _registerFocusReset(FocusNode node, VoidCallback onReset) {
    if (_registeredFocusNodes.add(node)) {
      node.addListener(() {
        if (!node.hasFocus) {
          onReset();
        }
      });
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
    final value = _axisController.text.trim().toLowerCase();
    return value == 'back' ||
        value == 'front' ||
        value == 'バック' ||
        value == 'フロント';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          top: 24,
          left: 24,
          right: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
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
          const SizedBox(height: 24),

          // Stance
          _buildSectionLabel('スタンス'),
          Row(
            children: [
              _buildSelectButton(
                TrickLabels.stanceRegular,
                _stance == Stance.regular,
                () => setState(() => _stance = Stance.regular),
              ),
              const SizedBox(width: 12),
              _buildSelectButton(
                TrickLabels.stanceSwitch,
                _stance == Stance.switchStance,
                () => setState(() => _stance = Stance.switchStance),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (widget.type == TrickType.air) ...[
            // Takeoff
            _buildSectionLabel(TrickLabels.sectionTakeoff),
            Row(
              children: [
                _buildSelectButton(
                  TrickLabels.takeoffStandard,
                  _takeoff == Takeoff.standard,
                  () => setState(() => _takeoff = Takeoff.standard),
                ),
                const SizedBox(width: 12),
                _buildSelectButton(
                  TrickLabels.takeoffCarving,
                  _takeoff == Takeoff.carving,
                  () => setState(() => _takeoff = Takeoff.carving),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Axis
            _buildSectionLabel(TrickLabels.sectionAxis),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return AppConstants.axes;
                }
                return AppConstants.axes.where((String option) {
                  return option.contains(textEditingValue.text);
                });
              },
              onSelected: (String selection) {
                setState(() {
                  _axisController.text = selection;
                });
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                // Sync controllers
                if (controller.text != _axisController.text) {
                  controller.text = _axisController.text;
                }
                _registerFocusReset(focusNode, () {
                  if (_axisPrimed || _axisEditable) {
                    setState(() {
                      _axisPrimed = false;
                      _axisEditable = false;
                    });
                  }
                });
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: !_axisEditable,
                  showCursor: _axisEditable,
                  onTap: () {
                    if (!focusNode.hasFocus) {
                      focusNode.requestFocus();
                    }
                    if (_axisPrimed) {
                      if (!_axisEditable) {
                        setState(() => _axisEditable = true);
                      }
                    } else {
                      setState(() => _axisPrimed = true);
                    }
                  },
                  onEditingComplete: () {
                    onEditingComplete();
                    _dismissKeyboard();
                  },
                  onSubmitted: (_) => _dismissKeyboard(),
                  onChanged: (val) {
                    setState(() {
                      _axisController.text = val;
                    });
                  },
                  decoration: _inputDecoration('軸を選択'),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          // Spin
          if (!_isBackOrFront) ...[
            _buildSectionLabel('スピン'),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                return AppConstants.spins
                    .map((e) => e.toString())
                    .where((String option) {
                  return option.contains(textEditingValue.text);
                });
              },
              onSelected: (String selection) {
                _spinController.text = selection;
              },
              fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                 if (controller.text != _spinController.text) {
                    controller.text = _spinController.text;
                  }
                _registerFocusReset(focusNode, () {
                  if (_spinPrimed || _spinEditable) {
                    setState(() {
                      _spinPrimed = false;
                      _spinEditable = false;
                    });
                  }
                });
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  readOnly: !_spinEditable,
                  showCursor: _spinEditable,
                  onTap: () {
                    if (!focusNode.hasFocus) {
                      focusNode.requestFocus();
                    }
                    if (_spinPrimed) {
                      if (!_spinEditable) {
                        setState(() => _spinEditable = true);
                      }
                    } else {
                      setState(() => _spinPrimed = true);
                    }
                  },
                  onEditingComplete: () {
                    onEditingComplete();
                    _dismissKeyboard();
                  },
                  onSubmitted: (_) => _dismissKeyboard(),
                  onChanged: (val) => _spinController.text = val,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('0'),
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          // Grab
          _buildSectionLabel('グラブ'),
          Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              if (textEditingValue.text == '') {
                return AppConstants.grabs;
              }
              return AppConstants.grabs.where((String option) {
                return option.contains(textEditingValue.text);
              });
            },
            onSelected: (String selection) {
              _grabController.text = selection;
            },
            fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
               if (controller.text != _grabController.text) {
                  controller.text = _grabController.text;
                }
              _registerFocusReset(focusNode, () {
                if (_grabPrimed || _grabEditable) {
                  setState(() {
                    _grabPrimed = false;
                    _grabEditable = false;
                  });
                }
              });
              return TextField(
                controller: controller,
                focusNode: focusNode,
                readOnly: !_grabEditable,
                showCursor: _grabEditable,
                onTap: () {
                  if (!focusNode.hasFocus) {
                    focusNode.requestFocus();
                  }
                  if (_grabPrimed) {
                    if (!_grabEditable) {
                      setState(() => _grabEditable = true);
                    }
                  } else {
                    setState(() => _grabPrimed = true);
                  }
                },
                onEditingComplete: () {
                  onEditingComplete();
                  _dismissKeyboard();
                },
                onSubmitted: (_) => _dismissKeyboard(),
                onChanged: (val) => _grabController.text = val,
                decoration: _inputDecoration('グラブを選択'),
              );
            },
          ),
          const SizedBox(height: 24),

          if (!_isBackOrFront) ...[
            // Direction
            _buildSectionLabel(TrickLabels.sectionDirection),
            Row(
              children: [
                _buildSelectButton(
                  TrickLabels.directionLeft,
                  _direction == Direction.left,
                  () => setState(() => _direction = Direction.left),
                ),
                const SizedBox(width: 12),
                _buildSelectButton(
                  TrickLabels.directionRight,
                  _direction == Direction.right,
                  () => setState(() => _direction = Direction.right),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Submit Button
          ElevatedButton(
            onPressed: () {
              final spinValue =
                  _isBackOrFront ? 0 : int.tryParse(_spinController.text) ?? 0;
              final directionValue = _isBackOrFront ? null : _direction;

              widget.onAdd(
                _stance,
                widget.type == TrickType.air ? _takeoff : null,
                _axisController.text.isEmpty ? null : _axisController.text,
                spinValue,
                _grabController.text.isEmpty
                    ? TrickLabels.grabNone
                    : _grabController.text,
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSelectButton(String text, bool isSelected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.focusColor.withOpacity(0.5) : Colors.transparent,
              width: 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppTheme.focusColor.withOpacity(0.1),
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
                color: isSelected ? AppTheme.focusColor : AppTheme.textHint,
                fontSize: 14,
              ),
            ),
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
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
