import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:off_training_note/models/profile.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/providers/profile_provider.dart';
import 'package:off_training_note/providers/tricks_provider.dart';
import 'package:off_training_note/providers/user_block_provider.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/widgets/common/app_banner.dart';
import 'package:off_training_note/widgets/dotted_background.dart';
import 'package:off_training_note/widgets/dialog/app_confirm_dialog.dart';
import 'package:off_training_note/widgets/sheet/common/app_bottom_sheet.dart';
import 'package:off_training_note/widgets/sheet/trick_detail_sheet.dart';
import 'package:off_training_note/widgets/trick_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key, this.profile, this.initialTrickId});

  final Profile? profile;
  final String? initialTrickId;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

enum _ProfileTab { air, jib }

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  _ProfileTab _activeTab = _ProfileTab.air;
  bool _didOpenInitial = false;

  void _showTrickDetail(Trick trick) {
    showAppBottomSheet(
      context: context,
      builder: (context) => TrickDetailSheet(trick: trick),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Supabase.instance.client.auth.currentUser;
    final isMe = widget.profile == null || widget.profile!.userId == currentUser?.id;

    Profile? displayProfile;
    List<Trick> displayTricks = [];
    bool isLoading = false;

    if (isMe) {
      final profileAsync = ref.watch(profileProvider);
      displayProfile = profileAsync.value;
      displayTricks = ref.watch(tricksProvider);
      isLoading = profileAsync.isLoading;
    } else {
      displayProfile = widget.profile;
      final tricksAsync = ref.watch(userTricksProvider(widget.profile!.userId));
      displayTricks = tricksAsync.value ?? [];
      isLoading = tricksAsync.isLoading;
      
      // Filter public tricks for others
      if (!isMe) {
        displayTricks = displayTricks.where((t) => t.isPublic).toList();
      }
    }

    if (isLoading && displayProfile == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final airTricks = displayTricks.whereType<AirTrick>().toList();
    final jibTricks = displayTricks.whereType<JibTrick>().toList();

    DateTime latestMemoAt(Trick trick) {
      if (trick.memos.isEmpty) return trick.createdAt;
      return trick.memos
          .map((memo) => memo.updatedAt)
          .reduce((a, b) => a.isAfter(b) ? a : b);
    }

    airTricks.sort((a, b) => latestMemoAt(b).compareTo(latestMemoAt(a)));
    jibTricks.sort((a, b) => latestMemoAt(b).compareTo(latestMemoAt(a)));

    final currentList = _activeTab == _ProfileTab.air ? airTricks : jibTricks;

    _maybeOpenInitialTrick(displayTricks);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.textMain),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (!isMe)
            IconButton(
              icon: const Icon(Icons.more_vert, color: AppTheme.textMain),
              onPressed: () => _showProfileMenu(displayProfile),
            ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: DottedBackgroundPainter()),
          ),
          if (isLoading && displayTricks.isEmpty)
             const Center(child: CircularProgressIndicator())
          else
            CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: SafeArea(
                    bottom: false,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: _buildProfileHeader(
                            displayProfile,
                            displayTricks.length,
                            displayTricks.fold(
                                0, (sum, trick) => sum + trick.memos.length),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildTabs(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                if (currentList.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(isMe),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                    sliver: SliverMasonryGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childCount: currentList.length,
                      itemBuilder: (context, index) {
                        final trick = currentList[index];
                        return TrickCard(
                          trick: trick,
                          onTap: () => _showTrickDetail(trick),
                          showPrivacyBadge: true,
                        );
                      },
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    Profile? profile,
    int totalTricks,
    int totalMemos,
  ) {
    final avatarUrl = profile?.avatarUrl;
    final name = profile?.displayName ?? 'No Name';

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                (avatarUrl != null && avatarUrl.isNotEmpty)
                    ? NetworkImage(avatarUrl)
                    : null,
            child: (avatarUrl == null || avatarUrl.isEmpty)
                ? Icon(
                    Icons.person,
                    size: 48,
                    color: Colors.grey.shade400,
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatItem('Tricks', totalTricks.toString()),
            Container(
              height: 32,
              width: 1,
              color: Colors.grey.shade300,
              margin: const EdgeInsets.symmetric(horizontal: 32),
            ),
            _buildStatItem('Memos', totalMemos.toString()),
          ],
        ),
      ],
    );
  }

  void _showProfileMenu(Profile? profile) {
    if (profile == null) {
      return;
    }
    showAppBottomSheet(
      context: context,
      builder: (menuContext) => AppBottomSheetContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionItem(
              menuContext,
              icon: Icons.block,
              label: 'ブロックする',
              onTap: () async {
                Navigator.pop(menuContext);
                final shouldBlock = await showAppConfirmDialog(
                  context: context,
                  title: 'このユーザーをブロックしますか？',
                  message: 'ブロックするとこのユーザーの投稿は表示されません。',
                  confirmLabel: 'ブロックする',
                  cancelLabel: 'キャンセル',
                  isDestructive: true,
                );
                if (shouldBlock == true && context.mounted) {
                  final userId = Supabase.instance.client.auth.currentUser?.id;
                  if (userId == null) {
                    return;
                  }
                  try {
                    await ref.read(userBlockRepositoryProvider).blockUser(
                      blockerId: userId,
                      blockedId: profile.userId,
                    );
                    showAppBanner(context, 'ブロックしました');
                  } catch (e) {
                    showAppBanner(context, 'ブロックに失敗しました');
                  }
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppTheme.textMain),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textMain,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _maybeOpenInitialTrick(List<Trick> displayTricks) {
    if (_didOpenInitial) return;
    final targetId = widget.initialTrickId;
    if (targetId == null) return;
    final target = displayTricks.cast<Trick?>().firstWhere(
          (trick) => trick?.id == targetId,
          orElse: () => null,
        );
    if (target == null) return;
    _didOpenInitial = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showTrickDetail(target);
    });
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.textMain,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            alignment: _activeTab == _ProfileTab.air
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildTabButton('AIR', _ProfileTab.air),
              _buildTabButton('JIB', _ProfileTab.jib),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, _ProfileTab type) {
    final isActive = _activeTab == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeTab = type),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: isActive ? AppTheme.textMain : Colors.grey.shade500,
              letterSpacing: 1.0,
            ),
            child: Text(label),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isMe) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notes, size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            isMe ? 'まだトリックがありません' : '公開されているトリックがありません',
            style: const TextStyle(color: AppTheme.textHint),
          ),
        ],
      ),
    );
  }
}
