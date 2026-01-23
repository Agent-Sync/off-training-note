import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/providers/tricks_provider.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/utils/trick_helpers.dart';
import 'package:off_training_note/widgets/dotted_background.dart';
import 'package:off_training_note/widgets/trick_card.dart';
import 'package:off_training_note/widgets/sheet/common/app_bottom_sheet.dart';
import 'package:off_training_note/widgets/sheet/new_jib_modal.dart';
import 'package:off_training_note/widgets/sheet/new_trick_modal.dart';
import 'package:off_training_note/widgets/sheet/trick_detail_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

enum _HomeTab { air, jib }

class _HomeScreenState extends ConsumerState<HomeScreen> {
  static const double _searchBarOverlap = 72;
  _HomeTab _activeTab = _HomeTab.air;
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
    if (_activeTab == _HomeTab.air) {
      showAppBottomSheet(
        context: context,
        builder: (context) => NewTrickModal(
          onAdd: (stance, takeoff, axis, spin, grab, direction) {
            final newTrick = Trick.air(
              id: _uuid.v4(),
              stance: stance,
              takeoff: takeoff,
              axis: axis,
              spin: spin,
              grab: grab,
              direction: direction,
              memos: [],
              createdAt: DateTime.now(),
            );
            ref.read(tricksProvider.notifier).addTrick(newTrick);
          },
        ),
      ).whenComplete(() {
        _dismissSearchFocus();
        _unlockSearchFocusWithDelay();
      });
      return;
    }

    showAppBottomSheet(
      context: context,
      builder: (context) => NewJibModal(
        onAdd: (customName) {
          final newJib = Trick.jib(
            id: _uuid.v4(),
            customName: customName,
            memos: const [],
            createdAt: DateTime.now(),
          );
          ref.read(tricksProvider.notifier).addTrick(newJib);
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

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e, stack) {
      debugPrint('$stack');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final allTricks = ref.watch(tricksProvider);

    final airTricks = allTricks.whereType<AirTrick>().toList();
    final jibTricks = allTricks.whereType<JibTrick>().toList();

    final filteredTricks = airTricks
        .where((t) => t.matchesQuery(_searchQuery))
        .toList();

    final filteredJibTricks = jibTricks
        .where(
          (jib) =>
              jib.customName.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();

    DateTime latestMemoAt(Trick trick) {
      if (trick.memos.isEmpty) return trick.createdAt;
      return trick.memos
          .map((memo) => memo.updatedAt)
          .reduce((a, b) => a.isAfter(b) ? a : b);
    }

    // Sort by latest memo desc, fall back to createdAt
    filteredTricks.sort((a, b) => latestMemoAt(b).compareTo(latestMemoAt(a)));
    filteredJibTricks
        .sort((a, b) => latestMemoAt(b).compareTo(latestMemoAt(a)));

    final content = _activeTab == _HomeTab.air
        ? _buildTrickContent(filteredTricks)
        : _buildJibContent(filteredJibTricks);

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _dismissSearchFocus,
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(painter: DottedBackgroundPainter()),
            ),
            Column(
              children: [
                _buildHeaderTabs(context),
                Expanded(
                  child: Stack(
                    children: [
                      content,
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
                label: const Text(
                  '新しいトリック',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrickContent(List<Trick> filteredTricks) {
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
        return TrickCard(trick: trick, onTap: () => _showTrickDetail(trick));
      },
    );
  }

  Widget _buildJibContent(List<Trick> filteredJibTricks) {
    if (filteredJibTricks.isEmpty) {
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
      itemCount: filteredJibTricks.length,
      itemBuilder: (context, index) {
        final jib = filteredJibTricks[index];
        return TrickCard(trick: jib, onTap: () => _showTrickDetail(jib));
      },
    );
  }

  Widget _buildTabButton(String label, _HomeTab type) {
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
        color: AppTheme.background.withValues(alpha: 0.95),
      ),
      child: Row(
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Container(
                width: 200,
                height: 40,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: Stack(
                  children: [
                    AnimatedAlign(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      alignment: _activeTab == _HomeTab.air
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
                        _buildTabButton('AIR', _HomeTab.air),
                        _buildTabButton('JIB', _HomeTab.jib),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'ログアウト',
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _signOut,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppTheme.background.withValues(alpha: 0),
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
                    color: Colors.black.withValues(alpha: 0.05),
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
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
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
