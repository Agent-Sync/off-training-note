import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/providers/tricks_provider.dart';
import 'package:off_training_note/theme/app_theme.dart';
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
  TrickType _activeTab = TrickType.air;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final _uuid = const Uuid();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Helper to get name for searching (duplicate logic from TrickCard, maybe move to model)
  String _getTrickName(Trick trick) {
    if (trick.customName != null && trick.customName!.isNotEmpty) {
      return trick.customName!;
    }
    // Simple fallback for search indexing
    return '${trick.spin} ${trick.grab} ${trick.axis ?? ""}';
  }

  void _showNewTrickModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => NewTrickModal(
        type: _activeTab,
        onAdd: (stance, takeoff, axis, spin, grab) {
          final newTrick = Trick(
            id: _uuid.v4(),
            type: _activeTab,
            stance: stance,
            takeoff: takeoff,
            axis: axis,
            spin: spin,
            grab: grab,
            logs: [],
            updatedAt: DateTime.now(),
          );
          ref.read(tricksProvider.notifier).addTrick(newTrick);
        },
      ),
    );
  }

  void _showTrickDetail(Trick trick) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TrickDetailSheet(trick: trick),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allTricks = ref.watch(tricksProvider);
    
    final filteredTricks = allTricks.where((t) {
      return t.type == _activeTab;
    }).where((t) {
      if (_searchQuery.isEmpty) return true;
      final name = _getTrickName(t).toLowerCase();
      // Add more robust search logic if needed
      return name.contains(_searchQuery.toLowerCase()) || 
             t.spin.toString().contains(_searchQuery) ||
             t.grab.contains(_searchQuery) ||
             (t.axis?.contains(_searchQuery) ?? false);
    }).toList();

    // Sort by updated at desc
    filteredTricks.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              // Header Tabs (Custom styled)
              Container(
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
                      // color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // Animated Indicator
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                          alignment: _activeTab == TrickType.air
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            width: 100, // half of 200
                            height: 4,
                            margin: const EdgeInsets.only(top: 30), // Underline style
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
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          onChanged: (val) {
                            setState(() {
                              _searchQuery = val;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'トリックを検索...',
                            hintStyle: TextStyle(color: AppTheme.textHint),
                            prefixIcon: Icon(Icons.search, color: AppTheme.textHint),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
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
                      child: IconButton(
                        icon: const Icon(Icons.tune, color: AppTheme.textSecondary),
                        onPressed: () {
                          // Filter settings (future)
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: filteredTricks.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search_off,
                                size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 16),
                            const Text(
                              'トリックが見つかりません',
                              style: TextStyle(color: AppTheme.textHint),
                            ),
                          ],
                        ),
                      )
                    : MasonryGridView.count(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // Bottom padding for FAB
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
}
