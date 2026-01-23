import 'package:off_training_note/models/community_memo.dart';
import 'package:off_training_note/services/supabase_client_service.dart';

class CommunityRepository {
  const CommunityRepository();

  Future<List<CommunityMemo>> fetchCommunityMemos({
    required String? userId,
    required String query,
    int limit = 10,
  }) async {
    final normalized = query.trim();
    final client = SupabaseClientProvider.client;

    var request = client.from('community_memos').select(
          'memo_id, trick_id, memo_type, focus, outcome, condition, size, '
          'memo_created_at, memo_updated_at, trick_type, custom_name, '
          'stance, takeoff, axis, spin, grab, direction, trick_created_at, '
          'user_id, display_name, avatar_url, like_count, trick_search',
        );

    if (normalized.isNotEmpty) {
      final pattern = '%$normalized%';
      request = request.or(
        'focus.ilike.$pattern,'
        'outcome.ilike.$pattern,'
        'display_name.ilike.$pattern,'
        'trick_search.ilike.$pattern',
      );
    } else if (userId != null) {
      request = request.neq('user_id', userId);
    }

    final rows = await request
        .order('memo_created_at', ascending: false)
        .limit(limit);

    final rowList = rows as List<dynamic>;
    final memoIds = rowList
        .map((row) => row['memo_id'] as String)
        .toList();

    final likedMemoIds = <String>{};
    if (userId != null && memoIds.isNotEmpty) {
      final likeRows = await client
          .from('memo_likes')
          .select('memo_id')
          .eq('user_id', userId)
          .inFilter('memo_id', memoIds);
      for (final row in likeRows as List<dynamic>) {
        likedMemoIds.add(row['memo_id'] as String);
      }
    }

    return rowList.map((row) {
      final memoId = row['memo_id'] as String;
      return _memoFromRow(
        row as Map<String, dynamic>,
        likedByMe: likedMemoIds.contains(memoId),
      );
    }).toList();
  }

  Future<void> likeMemo({
    required String memoId,
    required String userId,
  }) async {
    await SupabaseClientProvider.client.from('memo_likes').insert({
      'memo_id': memoId,
      'user_id': userId,
    });
  }

  Future<void> unlikeMemo({
    required String memoId,
    required String userId,
  }) async {
    await SupabaseClientProvider.client
        .from('memo_likes')
        .delete()
        .eq('memo_id', memoId)
        .eq('user_id', userId);
  }

  CommunityMemo _memoFromRow(
    Map<String, dynamic> row, {
    required bool likedByMe,
  }) {
    return CommunityMemo(
      id: row['memo_id'] as String,
      trickId: row['trick_id'] as String,
      memoType: row['memo_type'] as String,
      focus: row['focus'] as String,
      outcome: row['outcome'] as String,
      condition: row['condition'] as String?,
      size: row['size'] as String?,
      createdAt: DateTime.parse(row['memo_created_at'] as String),
      updatedAt: DateTime.parse(row['memo_updated_at'] as String),
      trickType: row['trick_type'] as String,
      customName: row['custom_name'] as String?,
      stance: row['stance'] as String?,
      takeoff: row['takeoff'] as String?,
      axis: row['axis'] as String?,
      spin: (row['spin'] as num?)?.toInt(),
      grab: row['grab'] as String?,
      direction: row['direction'] as String?,
      trickCreatedAt: DateTime.parse(row['trick_created_at'] as String),
      userId: row['user_id'] as String,
      displayName: row['display_name'] as String?,
      avatarUrl: row['avatar_url'] as String?,
      likeCount: (row['like_count'] as num?)?.toInt() ?? 0,
      likedByMe: likedByMe,
    );
  }
}
