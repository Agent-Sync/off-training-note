import 'package:off_training_note/models/community_memo.dart';
import 'package:off_training_note/models/profile.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/trick.dart';
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
        .map((row) => row['id'] as String)
        .toList();

    final likedMemoIds = userId != null
        ? await const CommunityLikeRepository().fetchLikedMemoIds(
            userId: userId,
            memoIds: memoIds,
          )
        : <String>{};

    return rowList.map((row) {
      final memoId = row['id'] as String;
      return _communityMemoFromRow(
        row as Map<String, dynamic>,
        likedByMe: likedMemoIds.contains(memoId),
      );
    }).toList();
  }

  CommunityMemo _communityMemoFromRow(
    Map<String, dynamic> row, {
    required bool likedByMe,
  }) {
    return CommunityMemo(
      memo: _techMemoFromRow(
        row,
        likedByMe: likedByMe,
      ),
      trick: _trickFromRow(
        row['trick_id'] as String,
        row['tricks'] as Map<String, dynamic>,
      ),
      profile: _profileFromRow(
        row['user_id'] as String,
        row['profiles'] as Map<String, dynamic>,
      ),
    );
  }

  Profile _profileFromRow(String userId, Map<String, dynamic> row) {
    return Profile(
      userId: userId,
      displayName: row['display_name'] as String?,
      avatarUrl: row['avatar_url'] as String?,
      onboarded: row['onboarded'] as bool? ?? false,
    );
  }

  Trick _trickFromRow(String trickId, Map<String, dynamic> row) {
    final type = row['type'] as String;
    if (type == 'jib') {
      return Trick.jib(
        id: trickId,
        customName: row['custom_name'] as String? ?? '',
        memos: const [],
        isPublic: row['is_public'] as bool? ?? true,
        createdAt: DateTime.parse(row['created_at'] as String),
      );
    }

    return Trick.air(
      id: trickId,
      stance: _stanceFromDb(row['stance'] as String?),
      takeoff: _takeoffFromDb(row['takeoff'] as String?),
      axis: _axisFromDb(row['axis'] as String?),
      spin: (row['spin'] as num?)?.toInt() ?? 0,
      grab: _grabFromDb(row['grab'] as String?),
      direction: _directionFromDb(row['direction'] as String?),
      memos: const [],
      isPublic: row['is_public'] as bool? ?? true,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  TechMemo _techMemoFromRow(
    Map<String, dynamic> row, {
    required bool likedByMe,
  }) {
    final likeCount = (row['like_count'] as num?)?.toInt() ?? 0;
    final type = row['type'] as String;
    if (type == 'jib') {
      return TechMemo.jib(
        id: row['id'] as String,
        focus: row['focus'] as String,
        outcome: row['outcome'] as String,
        likeCount: likeCount,
        likedByMe: likedByMe,
        updatedAt: DateTime.parse(row['updated_at'] as String),
        createdAt: DateTime.parse(row['created_at'] as String),
      );
    }

    return TechMemo.air(
      id: row['id'] as String,
      focus: row['focus'] as String,
      outcome: row['outcome'] as String,
      condition: _conditionFromDb(row['condition'] as String?),
      size: _sizeFromDb(row['size'] as String?),
      likeCount: likeCount,
      likedByMe: likedByMe,
      updatedAt: DateTime.parse(row['updated_at'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  MemoCondition _conditionFromDb(String? value) {
    switch (value) {
      case 'snow':
        return MemoCondition.snow;
      case 'brush':
        return MemoCondition.brush;
      case 'none':
      default:
        return MemoCondition.none;
    }
  }

  MemoSize _sizeFromDb(String? value) {
    switch (value) {
      case 'small':
        return MemoSize.small;
      case 'middle':
        return MemoSize.middle;
      case 'big':
        return MemoSize.big;
      case 'none':
      default:
        return MemoSize.none;
    }
  }

  Stance _stanceFromDb(String? value) {
    switch (value) {
      case 'switchStance':
        return Stance.switchStance;
      case 'regular':
      default:
        return Stance.regular;
    }
  }

  Takeoff _takeoffFromDb(String? value) {
    switch (value) {
      case 'carving':
        return Takeoff.carving;
      case 'standard':
      default:
        return Takeoff.standard;
    }
  }

  Direction _directionFromDb(String? value) {
    switch (value) {
      case 'left':
        return Direction.left;
      case 'right':
        return Direction.right;
      case 'none':
      default:
        return Direction.none;
    }
  }

  Axis _axisFromDb(String? value) {
    if (value == null) {
      return Axis.upright;
    }
    return Axis.fromDb(value);
  }

  Grab _grabFromDb(String? value) {
    if (value == null) {
      return Grab.none;
    }
    return Grab.fromDb(value);
  }
}
