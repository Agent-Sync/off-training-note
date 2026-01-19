import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> _showOptionSheet({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required ValueChanged<String> onSelected,
  }) async {
    final selection = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
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
                ),
                Divider(height: 1, color: Colors.grey.shade200),
                Flexible(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(24),
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final option = options[index];
                      final isSelected = option == selectedValue;
                      return _OptionItem(
                        text: option,
                        isSelected: isSelected,
                        onTap: () => Navigator.pop(context, option),
                      );
                    },
                  ),
                ),
              ],
            ),
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
    final selection = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return _SearchableSheet(
          title: title,
          options: options,
          selectedValue: selectedValue,
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

  bool _isBackOrFrontValue(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized == 'バックフリップ' ||
        normalized == 'フロントフリップ' ||
        normalized == 'back flip' ||
        normalized == 'front flip';
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
          Divider(height: 1, color: Colors.grey.shade200),
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
            TextField(
              controller: _axisController,
              readOnly: true,
              showCursor: false,
              enableInteractiveSelection: false,
              onTap: () {
                _showOptionSheet(
                  title: '軸を選択',
                  options: AppConstants.axes,
                  selectedValue: _axisController.text.isEmpty
                      ? null
                      : _axisController.text,
                  onSelected: (value) {
                    setState(() {
                      _axisController.text = value;
                      if (_isBackOrFrontValue(value)) {
                        _spinController.text = '0';
                        _direction = Direction.left;
                      }
                    });
                  },
                );
              },
              decoration: _inputDecoration('軸を選択'),
            ),
            const SizedBox(height: 16),
          ],

          // Spin
          _buildSectionLabel('スピン', enabled: !_isBackOrFront),
          AbsorbPointer(
            absorbing: _isBackOrFront,
            child: TextField(
              controller: _spinController,
              readOnly: true,
              showCursor: false,
              enableInteractiveSelection: false,
              style: TextStyle(
                color: _isBackOrFront
                    ? AppTheme.textHint.withOpacity(0.5)
                    : AppTheme.textMain,
              ),
              onTap: () {
                _showOptionSheet(
                  title: 'スピンを選択',
                  options:
                      AppConstants.spins.map((e) => e.toString()).toList(),
                  selectedValue: _spinController.text.isEmpty
                      ? null
                      : _spinController.text,
                  onSelected: (value) {
                    setState(() => _spinController.text = value);
                  },
                );
              },
              decoration: _inputDecoration('0'),
            ),
          ),
          const SizedBox(height: 16),

          // Grab
          _buildSectionLabel('グラブ'),
          TextField(
            controller: _grabController,
            readOnly: true,
            showCursor: false,
            enableInteractiveSelection: false,
            onTap: () {
              _showSearchableOptionSheet(
                title: 'グラブを選択',
                options: AppConstants.grabs,
                selectedValue: _grabController.text.isEmpty
                    ? null
                    : _grabController.text,
                onSelected: (value) {
                  setState(() => _grabController.text = value);
                },
              );
            },
            decoration: _inputDecoration('グラブを選択'),
          ),
          const SizedBox(height: 24),

          // Direction
          _buildSectionLabel(
            TrickLabels.sectionDirection,
            enabled: !_isBackOrFront,
          ),
          Row(
            children: [
              _buildSelectButton(
                TrickLabels.directionLeft,
                _direction == Direction.left,
                () => setState(() => _direction = Direction.left),
                enabled: !_isBackOrFront,
              ),
              const SizedBox(width: 12),
              _buildSelectButton(
                TrickLabels.directionRight,
                _direction == Direction.right,
                () => setState(() => _direction = Direction.right),
                enabled: !_isBackOrFront,
              ),
            ],
          ),
          const SizedBox(height: 16),

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

  Widget _buildSectionLabel(String text, {bool enabled = true}) {
    final labelColor = enabled
        ? AppTheme.textSecondary
        : AppTheme.textHint.withOpacity(0.5);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: labelColor,
        ),
      ),
    );
  }

  Widget _buildSelectButton(
    String text,
    bool isSelected,
    VoidCallback onTap, {
    bool enabled = true,
  }) {
    final buttonEnabled = enabled;
    final backgroundColor = buttonEnabled
        ? (isSelected ? Colors.white : Colors.grey.shade100)
        : Colors.grey.shade50;
    final borderColor = buttonEnabled && isSelected
        ? AppTheme.focusColor.withOpacity(0.5)
        : Colors.transparent;
    final textColor = buttonEnabled
        ? (isSelected ? AppTheme.focusColor : AppTheme.textHint)
        : AppTheme.textHint;
    return Expanded(
      child: GestureDetector(
        onTap: buttonEnabled ? onTap : null,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: borderColor,
              width: 1,
            ),
            boxShadow: buttonEnabled && isSelected
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
                  color: textColor,
                  fontSize: 14,
                ),
              ),
            ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, {bool enabled = true}) {
    final fillColor = enabled ? Colors.grey.shade50 : Colors.grey.shade100;
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppTheme.textHint),
      filled: true,
      fillColor: fillColor,
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

class _OptionItem extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const _OptionItem({
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.focusColor.withOpacity(0.5)
                : Colors.transparent,
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
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? AppTheme.focusColor : AppTheme.textHint,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _SearchableSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;

  const _SearchableSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
  });

  @override
  State<_SearchableSheet> createState() => _SearchableSheetState();
}

class _SearchableSheetState extends State<_SearchableSheet> {
  late List<String> _filteredOptions;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredOptions = widget.options
          .where((option) => option.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.title,
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
            ),
            Divider(height: 1, color: Colors.grey.shade200),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '検索...',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                itemCount: _filteredOptions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  final isSelected = option == widget.selectedValue;
                  return _OptionItem(
                    text: option,
                    isSelected: isSelected,
                    onTap: () => Navigator.pop(context, option),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
