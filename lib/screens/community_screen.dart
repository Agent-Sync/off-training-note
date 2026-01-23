import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/community_memo.dart';
import 'package:off_training_note/providers/community_provider.dart';
import 'package:off_training_note/theme/app_theme.dart';
import 'package:off_training_note/widgets/dotted_background.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  static const double _searchBarOverlap = 72;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _dismissSearchFocus() {
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(communityProvider);

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
            Icon(
              Icons.dynamic_feed,
              color: Colors.grey.shade500,
            ),
          ],
        ),
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
                textAlignVertical: TextAlignVertical.center,
                onChanged: (val) {
                  ref.read(communityProvider.notifier).updateQuery(val);
                },
                decoration: const InputDecoration(
                  isDense: true,
                  hintText: 'メモやトリックを検索...',
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
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(
          16,
          8 + _searchBarOverlap,
          16,
          24,
        ),
        itemCount: state.items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final memo = state.items[index];
          return _buildMemoCard(memo);
        },
      ),
    );
  }

  Widget _buildMemoCard(CommunityMemo memo) {
    final likeColor =
        memo.likedByMe ? Colors.redAccent : AppTheme.textSecondary;

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
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: (memo.avatarUrl != null &&
                        memo.avatarUrl!.trim().isNotEmpty)
                    ? NetworkImage(memo.avatarUrl!)
                    : null,
                child: (memo.avatarUrl == null ||
                        memo.avatarUrl!.trim().isEmpty)
                    ? const Icon(Icons.person, color: Colors.white, size: 18)
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
                    Text(
                      memo.trickName(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                timeago.format(memo.createdAt, locale: 'ja'),
                style: const TextStyle(
                  fontSize: 10,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
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
                  memo.focus,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMain,
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
                  memo.outcome,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppTheme.textMain,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
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
                        memo.likedByMe
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 18,
                        color: likeColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${memo.likeCount}',
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
            style: const TextStyle(color: AppTheme.textHint),
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
