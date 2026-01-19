import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/providers/tricks_provider.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/utils/trick_helpers.dart';
import 'package:off_training_note/widgets/common/app_bottom_sheet.dart';
import 'package:off_training_note/widgets/new_trick_modal.dart';
import 'package:off_training_note/widgets/trick_card.dart';
import 'package:off_training_note/widgets/trick_detail_sheet.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const double _searchBarOverlap = 72;
  TrickType _activeTab = TrickType.air;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final _uuid = const Uuid();
  Timer? _searchFocusTimer;
  bool _suppressSearchFocus = false;

  @override
  void dispose() {
    _searchFocusTimer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _lockSearchFocus() {
    if (_suppressSearchFocus) {
      return;
    }
    setState(() => _suppressSearchFocus = true);
  }

  void _unlockSearchFocusWithDelay() {
    _searchFocusTimer?.cancel();
    _searchFocusTimer = Timer(const Duration(milliseconds: 150), () {
      if (!mounted) {
        return;
      }
      setState(() => _suppressSearchFocus = false);
    });
  }

  void _showNewTrickModal() {
    _dismissSearchFocus();
    _lockSearchFocus();
    showAppBottomSheet(
      context: context,
      builder: (context) => NewTrickModal(
        type: _activeTab,
        onAdd: (stance, takeoff, axis, spin, grab, direction) {
          final newTrick = Trick(
            id: _uuid.v4(),
            type: _activeTab,
            stance: stance,
            takeoff: takeoff,
            axis: axis,
            spin: spin,
            grab: grab,
            direction: direction,
            logs: [],
            updatedAt: DateTime.now(),
          );
          ref.read(tricksProvider.notifier).addTrick(newTrick);
        },
      ),
    ).whenComplete(() {
      _dismissSearchFocus();
      _unlockSearchFocusWithDelay();
    });
  }

  void _showTrickDetail(Trick trick) {
    _dismissSearchFocus();
    _lockSearchFocus();
    showAppBottomSheet(
      context: context,
      builder: (context) => TrickDetailSheet(trick: trick),
    ).whenComplete(() {
      _dismissSearchFocus();
      _unlockSearchFocusWithDelay();
    });
  }

  void _dismissSearchFocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final allTricks = ref.watch(tricksProvider);
    
    final filteredTricks = allTricks
        .where((t) => t.type == _activeTab)
        .where((t) => t.matchesQuery(_searchQuery))
        .toList();

    // Sort by updated at desc
    filteredTricks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissSearchFocus,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _DottedBackgroundPainter(),
              ),
            ),
            Column(
              children: [
                _buildHeaderTabs(context),
                Expanded(
                  child: Stack(
                    children: [
                      _buildContent(filteredTricks),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: _buildSearchBar(),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // FAB
            Positioned(
              bottom: 24,
              right: 24,
              child: FloatingActionButton.extended(
                onPressed: _showNewTrickModal,
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 4,
                icon: const Icon(Icons.add),
                label: const Text('新しいトリック', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(List<Trick> filteredTricks) {
    if (filteredTricks.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: _searchBarOverlap),
        child: _buildEmptyState(),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.fromLTRB(16, 8 + _searchBarOverlap, 16, 100),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: filteredTricks.length,
      itemBuilder: (context, index) {
        final trick = filteredTricks[index];
        return TrickCard(
          trick: trick,
          onTap: () => _showTrickDetail(trick),
        );
      },
    );
  }

  Widget _buildTabButton(String label, TrickType type) {
    final isActive = _activeTab == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = type),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedScale(
            scale: isActive ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: isActive ? Colors.black : Colors.grey.shade400,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderTabs(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: AppTheme.background.withOpacity(0.95),
      ),
      child: Center(
        child: Container(
          width: 200,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            children: [
              AnimatedAlign(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                alignment: _activeTab == TrickType.air
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                child: Container(
                  width: 100,
                  height: 4,
                  margin: const EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  _buildTabButton('AIR', TrickType.air),
                  _buildTabButton('JIB', TrickType.jib),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppTheme.background.withOpacity(0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                canRequestFocus: !_suppressSearchFocus,
                textAlignVertical: TextAlignVertical.center,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'トリックを検索...',
                  hintStyle: TextStyle(color: AppTheme.textHint),
                  prefixIcon: Icon(Icons.search, color: AppTheme.textHint),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'トリックが見つかりません',
            style: TextStyle(color: AppTheme.textHint),
          ),
        ],
      ),
    );
  }
}

class _DottedBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.grey.shade400.withOpacity(0.6);
    const spacing = 20.0;
    const radius = 1.2;

    for (double y = 0; y <= size.height; y += spacing) {
      for (double x = 0; x <= size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), radius, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
