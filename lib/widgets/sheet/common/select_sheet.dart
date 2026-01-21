import 'package:flutter/material.dart';
import 'package:off_training_note/theme/app_theme.dart';

const Duration _optionCloseDelay = Duration(milliseconds: 150);

class AppSelectSheet extends StatefulWidget {
  final String title;
  final List<String> options;
  final String? selectedValue;
  final bool enableSearch;
  final double maxHeightFactor;

  const AppSelectSheet({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    this.enableSearch = false,
    this.maxHeightFactor = 0.9,
  });

  @override
  State<AppSelectSheet> createState() => _AppSelectSheetState();
}

class _AppSelectSheetState extends State<AppSelectSheet> {
  late List<String> _filteredOptions;
  final TextEditingController _searchController = TextEditingController();
  String? _pendingSelection;

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.options;
    if (widget.enableSearch) {
      _searchController.addListener(_onSearchChanged);
    }
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
          maxHeight: MediaQuery.of(context).size.height * widget.maxHeightFactor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
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
            Divider(height: 1, color: Colors.grey.shade200),
            const SizedBox(height: 12),
            if (widget.enableSearch) ...[
              TextField(
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
              const SizedBox(height: 12),
            ],
            Flexible(
              child: ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: _filteredOptions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final option = _filteredOptions[index];
                  final isSelected =
                      option == (_pendingSelection ?? widget.selectedValue);
                  return _OptionItem(
                    text: option,
                    isSelected: isSelected,
                    onTap: () async {
                      setState(() => _pendingSelection = option);
                      await Future.delayed(_optionCloseDelay);
                      if (!mounted) {
                        return;
                      }
                      if (Navigator.of(context).canPop()) {
                        Navigator.pop(context, option);
                      }
                    },
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
