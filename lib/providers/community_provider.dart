import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/community_memo.dart';
import 'package:off_training_note/repositories/community_like_repository.dart';
import 'package:off_training_note/repositories/community_repository.dart';
import 'package:off_training_note/providers/profile_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  return const CommunityRepository();
});

final communityLikeRepositoryProvider = Provider<CommunityLikeRepository>(
  (ref) => const CommunityLikeRepository(),
);

final communityProvider =
    NotifierProvider<CommunityNotifier, CommunityFeedState>(
  CommunityNotifier.new,
);

class CommunityFeedState {
  const CommunityFeedState({
    this.items = const [],
    this.query = '',
    this.isLoading = false,
    this.errorMessage,
  });

  final List<CommunityMemo> items;
  final String query;
  final bool isLoading;
  final String? errorMessage;

  CommunityFeedState copyWith({
    List<CommunityMemo>? items,
    String? query,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CommunityFeedState(
      items: items ?? this.items,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class CommunityNotifier extends Notifier<CommunityFeedState> {
  Timer? _debounce;

  @override
  CommunityFeedState build() {
    ref.watch(authSessionProvider);
    ref.onDispose(() {
      _debounce?.cancel();
    });
    Future.microtask(_load);
    return const CommunityFeedState();
  }

  Future<void> _load({String? query}) async {
    final nextQuery = query ?? state.query;
    state = state.copyWith(isLoading: true, query: nextQuery, errorMessage: null);
    final repo = ref.read(communityRepositoryProvider);
    final userId = Supabase.instance.client.auth.currentUser?.id;
    try {
      final items = await repo.fetchCommunityMemos(
        userId: userId,
        query: nextQuery,
        limit: 10,
      );
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: '読み込みに失敗しました',
      );
    }
  }

  void updateQuery(String query) {
    state = state.copyWith(query: query);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _load(query: query);
    });
  }

  Future<void> refresh() async {
    await _load();
  }

  Future<void> toggleLike(CommunityMemo memo) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return;
    }
    final updatedMemo = memo.memo.copyWith(
      likedByMe: !memo.memo.likedByMe,
      likeCount:
          memo.memo.likedByMe ? memo.memo.likeCount - 1 : memo.memo.likeCount + 1,
    );
    final updated = memo.copyWith(memo: updatedMemo);
    state = state.copyWith(
      items: [
        for (final item in state.items)
          if (item.memo.id == memo.memo.id) updated else item
      ],
    );
    try {
      final likeRepo = ref.read(communityLikeRepositoryProvider);
      if (memo.memo.likedByMe) {
        await likeRepo.unlikeMemo(memoId: memo.memo.id, userId: userId);
      } else {
        await likeRepo.likeMemo(memoId: memo.memo.id, userId: userId);
      }
    } catch (e) {
      state = state.copyWith(
        items: [
          for (final item in state.items)
            if (item.memo.id == memo.memo.id) memo else item
        ],
        errorMessage: 'いいねの更新に失敗しました',
      );
    }
  }
}
