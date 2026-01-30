import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/community_memo.dart';
import 'package:off_training_note/models/profile.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/navigation/route_observer.dart';
import 'package:off_training_note/providers/community_provider.dart';
import 'package:off_training_note/providers/profile_provider.dart';
import 'package:off_training_note/screens/profile_screen.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/utils/relative_time.dart';
import 'package:off_training_note/widgets/common/app_banner.dart';
import 'package:off_training_note/widgets/dotted_background.dart';
import 'package:off_training_note/widgets/dialog/app_confirm_dialog.dart';
import 'package:off_training_note/widgets/sheet/common/app_bottom_sheet.dart';
import 'package:off_training_note/widgets/sheet/settings_sheet.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with RouteAware {
  static const double _searchBarOverlap = 72;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _routeSubscribed = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      if (_routeSubscribed) {
        routeObserver.unsubscribe(this);
      }
      routeObserver.subscribe(this, route);
      _routeSubscribed = true;
    }
  }

  @override
  void dispose() {
    if (_routeSubscribed) {
      routeObserver.unsubscribe(this);
    }
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _dismissSearchFocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  void didPopNext() {
  }

  @override
  void didPush() {
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityProvider);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: DottedBackgroundPainter()),
          ),
          Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Stack(
                  children: [
                    _buildFeed(state),
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
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
        child: Row(
          children: [
            const Text(
              'みんなのメモ',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textMain,
              ),
            ),
            const Spacer(),
            _buildAvatarButton(ref.watch(profileProvider)),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (e, stack) {
      debugPrint('$stack');
      rethrow;
    }
  }

  void _showProfileActions() {
    showAppBottomSheet(
      context: context,
      builder: (context) {
        return AppBottomSheetContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildActionItem(
                context,
                icon: Icons.settings_outlined,
                label: '設定',
                enabled: true,
                onTap: () {
                  Navigator.of(context).pop();
                  showAppBottomSheet(
                    context: context,
                    builder: (context) => const SettingsSheet(),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildActionItem(
                context,
                icon: Icons.person_outline,
                label: 'プロフィール',
                enabled: true,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildActionItem(
                context,
                icon: Icons.logout,
                label: 'ログアウト',
                isDestructive: true,
                onTap: () async {
                  Navigator.of(context).pop();
                  await _signOut();
                },
              ),
              const SizedBox(height: 8),
              _buildActionItem(
                context,
                icon: Icons.delete_outline,
                label: 'アカウント削除',
                isDestructive: true,
                onTap: () async {
                  Navigator.of(context).pop();
                  await _showDeleteAccountFlow();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
    bool enabled = true,
  }) {
    final color = isDestructive ? Colors.red : AppTheme.textMain;
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(
              icon,
              color: enabled ? color : Colors.grey.shade400,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: enabled ? color : Colors.grey.shade400,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteAccountFlow() async {
    final shouldDelete = await showAppConfirmDialog(
      context: context,
      title: 'アカウントを削除しますか？',
      message: '削除すると元に戻せません。',
      confirmLabel: '削除',
      isDestructive: true,
    );
    if (!mounted || shouldDelete != true) return;

    final email = Supabase.instance.client.auth.currentUser?.email ?? '';
    if (email.isEmpty) {
      showAppBanner(context, 'メールアドレスが取得できませんでした');
      return;
    }

    final confirmed = await _showDeleteAccountEmailDialog(email: email);
    if (!mounted || confirmed != true) return;

    final deleted = await _deleteAccount();
    if (!mounted || !deleted) return;

    showAppBanner(context, 'アカウントを削除しました');
    await _signOut();
  }

  Future<bool> _deleteAccount() async {
    try {
      final accessToken =
          Supabase.instance.client.auth.currentSession?.accessToken ?? '';
      if (accessToken.isEmpty) {
        showAppBanner(context, '認証情報が取得できませんでした');
        return false;
      }
      final response = await Supabase.instance.client.functions.invoke(
        'delete-account',
        headers: {'Authorization': 'Bearer $accessToken'},
      );
      if (response.status < 200 || response.status >= 300) {
        showAppBanner(context, 'アカウント削除に失敗しました');
        return false;
      }
      return true;
    } catch (_) {
      showAppBanner(context, 'アカウント削除に失敗しました');
      return false;
    }
  }

  Future<bool?> _showDeleteAccountEmailDialog({required String email}) {
    final controller = TextEditingController();
    bool showError = false;

    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final isMatch = controller.text.trim() == email;
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                'メールアドレスを入力してください',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'メールアドレス（$email）を入力すると削除できます。',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) {
                      if (showError && isMatch) {
                        setState(() => showError = false);
                      } else if (showError) {
                        setState(() {});
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'メールアドレス',
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                  if (showError && !isMatch) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'メールアドレスが一致しません',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              actionsPadding: const EdgeInsets.only(
                bottom: 16,
                left: 16,
                right: 16,
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(dialogContext, false),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
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
                      child: OutlinedButton(
                        onPressed: () {
                          if (!isMatch) {
                            setState(() => showError = true);
                            return;
                          }
                          Navigator.pop(dialogContext, true);
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red.shade200),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          '削除',
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildAvatarButton(AsyncValue<Profile?> profileAsync) {
    final avatar = profileAsync.when(
      data: (profile) {
        final url = profile?.avatarUrl;
        if (url != null && url.isNotEmpty) {
          return CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(url),
          );
        }
        return CircleAvatar(
          radius: 16,
          backgroundColor: Colors.grey.shade200,
          child: Icon(Icons.person, size: 18, color: Colors.grey.shade600),
        );
      },
      loading: () => const SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
      error: (error, stackTrace) => CircleAvatar(
        radius: 16,
        backgroundColor: Colors.grey.shade200,
        child: Icon(Icons.person, size: 18, color: Colors.grey.shade600),
      ),
    );

    return GestureDetector(
      onTap: _showProfileActions,
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(child: avatar),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TapRegion(
      onTapOutside: (_) => _dismissSearchFocus(),
      child: Container(
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
                  textAlignVertical: TextAlignVertical.center,
                  onChanged: (val) {
                    setState(() {});
                    ref.read(communityProvider.notifier).updateQuery(val);
                  },
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: 'メモやトリックを検索...',
                    hintStyle: const TextStyle(
                      color: AppTheme.textHint,
                      fontWeight: FontWeight.w600,
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.textHint),
                    suffixIcon: _searchController.text.trim().isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close, color: AppTheme.textHint),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                              ref.read(communityProvider.notifier).updateQuery('');
                            },
                          ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeed(CommunityFeedState state) {
    if (state.isLoading && state.items.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.black),
      );
    }

    if (state.items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: _searchBarOverlap),
        child: _buildEmptyState(state.query),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(communityProvider.notifier).refresh(),
      color: Colors.black,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          8 + _searchBarOverlap,
          16,
          24,
        ),
        itemCount: state.items.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final memo = state.items[index];
          return _buildMemoCard(memo);
        },
      ),
    );
  }

  Widget _buildMemoCard(CommunityMemo memo) {
    final likeColor = memo.memo.likedByMe
        ? Colors.redAccent
        : AppTheme.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(profile: memo.profile),
                ),
              );
            },
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: (memo.profile.avatarUrl != null &&
                          memo.profile.avatarUrl!.trim().isNotEmpty)
                      ? NetworkImage(memo.profile.avatarUrl!)
                      : null,
                  child: (memo.profile.avatarUrl == null ||
                          memo.profile.avatarUrl!.trim().isEmpty)
                      ? const Icon(Icons.person,
                          color: Colors.white, size: 18)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memo.displayUserName(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMain,
                        ),
                      ),
                      const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              profile: memo.profile,
                              initialTrickId: memo.trick.id,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        memo.trickName(),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatRelativeTime(memo.memo.createdAt),
                      style: const TextStyle(
                        fontSize: 10,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    IconButton(
                      icon: const Icon(
                        Icons.more_vert,
                        size: 16,
                        color: Colors.grey,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      style: ButtonStyle(
                        overlayColor: WidgetStateProperty.all(
                          Colors.transparent,
                        ),
                      ),
                      splashRadius: 18,
                      onPressed: () => _showReportMenu(context, memo),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade100),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '意識',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.focusColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  memo.memo.focus,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMain,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(
                          Icons.arrow_downward,
                          size: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.grey.shade300,
                        ),
                      ),
                    ],
                  ),
                ),
                const Text(
                  'どう変わったか',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.outcomeColor,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  memo.memo.outcome,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMain,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => ref
                    .read(communityProvider.notifier)
                    .toggleLike(memo),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        memo.memo.likedByMe
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: likeColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${memo.memo.likeCount}',
                        style: TextStyle(
                          fontSize: 12,
                          color: likeColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showReportMenu(BuildContext parentContext, CommunityMemo memo) {
    showAppBottomSheet(
      context: parentContext,
      builder: (menuContext) => AppBottomSheetContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildActionItem(
              menuContext,
              icon: Icons.flag_outlined,
              label: '報告する',
              onTap: () async {
                Navigator.pop(menuContext);
                final user = Supabase.instance.client.auth.currentUser;
                final shouldReport = await showAppConfirmDialog(
                  context: parentContext,
                  title: 'このメモを報告しますか？',
                  message: '不適切な内容として報告します。',
                  confirmLabel: '報告する',
                  cancelLabel: 'キャンセル',
                  isDestructive: true,
                );
                if (shouldReport == true && parentContext.mounted) {
                  if (user == null) {
                    return;
                  }
                  await ref.read(memoReportRepositoryProvider).reportMemo(
                        memoId: memo.memo.id,
                        userId: user.id,
                      );
                  showAppBanner(parentContext, '報告しました');
                }
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String query) {
    final isSearching = query.trim().isNotEmpty;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.forum_outlined,
            size: 48,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            isSearching ? 'メモが見つかりません' : 'まだ公開メモがありません',
            style: const TextStyle(
              color: AppTheme.textHint,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (!isSearching) ...[
            const SizedBox(height: 8),
            const Text(
              'みんなの記録がここに流れます',
              style: TextStyle(color: AppTheme.textHint, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}
