import 'package:off_training_note/services/supabase_client_service.dart';

class CommunityLikeRepository {
  const CommunityLikeRepository();

  Future<Set<String>> fetchLikedMemoIds({
    required String userId,
    required List<String> memoIds,
  }) async {
    if (memoIds.isEmpty) {
      return <String>{};
    }
    final likeRows = await SupabaseClientProvider.guard(
      (client) => client
          .from('memo_likes')
          .select('memo_id')
          .eq('user_id', userId)
          .inFilter('memo_id', memoIds),
    );
    final likedMemoIds = <String>{};
    for (final row in likeRows as List<dynamic>) {
      likedMemoIds.add(row['memo_id'] as String);
    }
    return likedMemoIds;
  }

  Future<void> likeMemo({
    required String memoId,
    required String userId,
  }) async {
    await SupabaseClientProvider.guard(
      (client) => client.from('memo_likes').insert({
        'memo_id': memoId,
        'user_id': userId,
      }),
    );
  }

  Future<void> unlikeMemo({
    required String memoId,
    required String userId,
  }) async {
    await SupabaseClientProvider.guard(
      (client) => client
          .from('memo_likes')
          .delete()
          .eq('memo_id', memoId)
          .eq('user_id', userId),
    );
  }
}
