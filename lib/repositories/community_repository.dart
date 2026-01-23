import 'package:off_training_note/models/community_memo.dart';
import 'package:off_training_note/repositories/community_like_repository.dart';
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

    var request = client.from('memos').select(
          'id, trick_id, type, focus, outcome, condition, size, created_at, '
          'updated_at, like_count, user_id, search_text, '
          'tricks!inner ('
          'type, custom_name, stance, takeoff, axis, spin, grab, direction, '
          'created_at, is_public'
          '), '
          'profiles!inner (display_name, avatar_url)',
        );

    request = request.eq('tricks.is_public', true);

    if (normalized.isNotEmpty) {
      final pattern = '%$normalized%';
      request = request.or(
        'focus.ilike.$pattern,'
        'outcome.ilike.$pattern,'
        'profiles.display_name.ilike.$pattern,'
        'search_text.ilike.$pattern',
      );
    } else if (userId != null) {
      request = request.neq('user_id', userId);
    }

    final rows = await request
        .order('created_at', ascending: false)
        .limit(limit);

    final rowList = rows as List<dynamic>;
    final memoIds = rowList
        .map((row) => row['memo_id'] as String)
        .toList();

    final likedMemoIds = userId != null
        ? await const CommunityLikeRepository().fetchLikedMemoIds(
            userId: userId,
            memoIds: memoIds,
          )
        : <String>{};

    return rowList.map((row) {
      final memoId = row['id'] as String;
      return _memoFromRow(
        row as Map<String, dynamic>,
        likedByMe: likedMemoIds.contains(memoId),
      );
    }).toList();
  }

  CommunityMemo _memoFromRow(
    Map<String, dynamic> row, {
    required bool likedByMe,
  }) {
    return CommunityMemo(
      id: row['id'] as String,
      trickId: row['trick_id'] as String,
      memoType: row['type'] as String,
      focus: row['focus'] as String,
      outcome: row['outcome'] as String,
      condition: row['condition'] as String?,
      size: row['size'] as String?,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
      trickType: (row['tricks'] as Map<String, dynamic>)['type'] as String,
      customName:
          (row['tricks'] as Map<String, dynamic>)['custom_name'] as String?,
      stance: (row['tricks'] as Map<String, dynamic>)['stance'] as String?,
      takeoff: (row['tricks'] as Map<String, dynamic>)['takeoff'] as String?,
      axis: (row['tricks'] as Map<String, dynamic>)['axis'] as String?,
      spin: ((row['tricks'] as Map<String, dynamic>)['spin'] as num?)?.toInt(),
      grab: (row['tricks'] as Map<String, dynamic>)['grab'] as String?,
      direction:
          (row['tricks'] as Map<String, dynamic>)['direction'] as String?,
      trickCreatedAt: DateTime.parse(
        (row['tricks'] as Map<String, dynamic>)['created_at'] as String,
      ),
      userId: row['user_id'] as String,
      displayName:
          (row['profiles'] as Map<String, dynamic>)['display_name'] as String?,
      avatarUrl:
          (row['profiles'] as Map<String, dynamic>)['avatar_url'] as String?,
      likeCount: (row['like_count'] as num?)?.toInt() ?? 0,
      likedByMe: likedByMe,
    );
  }
}
