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
    final selectClause =
        'id, trick_id, type, focus, outcome, condition, size, created_at, '
        'updated_at, like_count, user_id, '
        'tricks!inner ('
        'user_id, type, custom_name, trick_name_ja, stance, takeoff, axis, spin, grab, '
        'direction, created_at, updated_at, is_public, '
        'axes(label_ja, label_en), grabs(label_ja, label_en), spins(label_ja, label_en)'
        '), '
        'profiles!inner (display_name, avatar_url)';

    dynamic buildBaseRequest() {
      var request = SupabaseClientProvider.client
          .from('memos')
          .select(selectClause)
          .eq('tricks.is_public', true);
      if (userId != null) {
        request = request.neq('tricks.user_id', userId);
      }
      return request;
    }

    List<dynamic> rowList;
    if (normalized.isEmpty) {
      final request = buildBaseRequest();
      final rows = await SupabaseClientProvider.guard(
        (_) => request.order('created_at', ascending: false).limit(limit),
      );
      rowList = rows as List<dynamic>;
    } else {
      final pattern = '%$normalized%';
      final baseRows = await SupabaseClientProvider.guard(
        (_) => buildBaseRequest()
            .or('focus.ilike.$pattern,outcome.ilike.$pattern')
            .order('created_at', ascending: false)
            .limit(limit),
      );
      final profileRows = await SupabaseClientProvider.guard(
        (_) => buildBaseRequest()
            .or('display_name.ilike.$pattern', referencedTable: 'profiles')
            .order('created_at', ascending: false)
            .limit(limit),
      );
      final trickRows = await SupabaseClientProvider.guard(
        (_) => buildBaseRequest()
            .or('trick_name_ja.ilike.$pattern', referencedTable: 'tricks')
            .order('created_at', ascending: false)
            .limit(limit),
      );

      final combined = <String, Map<String, dynamic>>{};
      for (final rows in [baseRows, profileRows, trickRows]) {
        for (final row in rows as List<dynamic>) {
          final map = row as Map<String, dynamic>;
          combined[map['id'] as String] = map;
        }
      }
      rowList = combined.values.toList(growable: false)
        ..sort(
          (a, b) => DateTime.parse(
            b['created_at'] as String,
          ).compareTo(DateTime.parse(a['created_at'] as String)),
      );
      if (rowList.length > limit) {
        rowList = rowList.sublist(0, limit);
      }
    }

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
    final userId = row['user_id'] as String;
    final isPublic = row['is_public'] as bool? ?? true;
    final meta = TrickMeta(
      id: trickId,
      userId: userId,
      isPublic: isPublic,
      trickName: row['trick_name_ja'] as String? ?? '',
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
    if (type == 'jib') {
      return Trick.jib(
        meta: meta,
        customName: row['custom_name'] as String? ?? '',
        memos: const [],
      );
    }

    final axisCode = row['axis'] as String? ?? '';
    final grabCode = row['grab'] as String? ?? '';
    final spinValue = (row['spin'] as num?)?.toInt() ?? 0;
    final axisMap = row['axes'] as Map<String, dynamic>?;
    final grabMap = row['grabs'] as Map<String, dynamic>?;
    final spinMap = row['spins'] as Map<String, dynamic>?;
    final axis = Axis(
      code: axisCode,
      labelJa: axisMap?['label_ja'] as String? ?? axisCode,
      labelEn: axisMap?['label_en'] as String? ?? axisCode,
    );
    final grab = Grab(
      code: grabCode,
      labelJa: grabMap?['label_ja'] as String? ?? grabCode,
      labelEn: grabMap?['label_en'] as String? ?? grabCode,
    );
    final spin = Spin(
      value: spinValue,
      labelJa: spinMap?['label_ja'] as String? ?? spinValue.toString(),
      labelEn: spinMap?['label_en'] as String? ?? spinValue.toString(),
    );

    return Trick.air(
      meta: meta,
      stance: _stanceFromDb(row['stance'] as String?),
      takeoff: _takeoffFromDb(row['takeoff'] as String?),
      axis: axis,
      spin: spin,
      grab: grab,
      direction: _directionFromDb(row['direction'] as String?),
      memos: const [],
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
      case 'trampoline':
        return MemoCondition.trampoline;
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
    return Stance.fromCode(value ?? 'regular');
  }

  Takeoff _takeoffFromDb(String? value) {
    return Takeoff.fromCode(value ?? 'straight');
  }

  Direction _directionFromDb(String? value) {
    return Direction.fromCode(value ?? 'none');
  }

}
