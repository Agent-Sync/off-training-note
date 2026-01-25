import 'package:off_training_note/repositories/community_like_repository.dart';
import 'package:off_training_note/services/supabase_client_service.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:uuid/uuid.dart';

const _trickUuid = Uuid();

class TricksRepository {
  const TricksRepository();

  Future<List<Trick>> fetchTricks({
    required String userId,
    String? viewerUserId,
  }) async {
    final rows = await SupabaseClientProvider.guard(
      (client) => client
          .from('tricks')
          .select(
            'id, user_id, type, custom_name, trick_name_ja, stance, takeoff, axis, spin, grab, direction, '
            'is_public, created_at, updated_at, '
            'axes(label_ja, label_en), grabs(label_ja, label_en), spins(label_ja, label_en), '
            'memos(id, trick_id, type, focus, outcome, condition, size, like_count, created_at, updated_at)',
          )
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .order('updated_at', referencedTable: 'memos', ascending: false),
    );

    final rowList = rows as List<dynamic>;
    final memoIds = rowList
        .expand((row) => (row['memos'] as List<dynamic>? ?? []))
        .map((memo) => memo['id'] as String)
        .toList();

    final likeUserId = viewerUserId ?? userId;
    final likedMemoIds = memoIds.isEmpty
        ? <String>{}
        : await const CommunityLikeRepository().fetchLikedMemoIds(
            userId: likeUserId,
            memoIds: memoIds,
          );

    return rowList
        .map(
          (row) => _trickFromRow(
            row as Map<String, dynamic>,
            likedMemoIds: likedMemoIds,
          ),
        )
        .toList();
  }

  Future<void> addTrick({required String userId, required Trick trick}) async {
    final now = DateTime.now().toIso8601String();
    await SupabaseClientProvider.guard(
      (client) => client.from('tricks').insert(
        trick.map(
          air: (air) => {
            'id': air.id,
            'user_id': userId,
            'type': 'air',
            'custom_name': null,
            'stance': _stanceToDb(air.stance),
            'takeoff': _takeoffToDb(air.takeoff),
            'axis': air.axis.code,
            'spin': air.spin.value,
            'grab': air.grab.code,
            'direction': _directionToDb(air.direction),
            'is_public': air.isPublic,
            'created_at': air.createdAt.toIso8601String(),
            'updated_at': now,
          },
          jib: (jib) => {
            'id': jib.id,
            'user_id': userId,
            'type': 'jib',
            'custom_name': jib.customName,
            'stance': null,
            'takeoff': null,
            'axis': null,
            'spin': null,
            'grab': null,
            'direction': null,
            'is_public': jib.isPublic,
            'created_at': jib.createdAt.toIso8601String(),
            'updated_at': now,
          },
        ),
      ),
    );
  }

  Future<void> updateTrickStatus({
    required String trickId,
    required bool isPublic,
  }) async {
    await SupabaseClientProvider.guard(
      (client) => client.from('tricks').update({
        'is_public': isPublic,
        'updated_at': DateTime.now().toIso8601String(),
      }).eq('id', trickId),
    );
  }

  Future<void> addMemo({
    required Trick trick,
    required String focus,
    required String outcome,
    MemoCondition? condition,
    MemoSize? size,
  }) async {
    final now = DateTime.now();
    final memoId = _trickUuid.v4();
    await SupabaseClientProvider.guard(
      (client) => client.from('memos').insert(
        trick.map(
          air: (_) => {
            'id': memoId,
            'trick_id': trick.id,
            'type': 'air',
            'focus': focus,
            'outcome': outcome,
            'condition': _conditionToDb(condition ?? MemoCondition.none),
            'size': _sizeToDb(size ?? MemoSize.none),
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
          jib: (_) => {
            'id': memoId,
            'trick_id': trick.id,
            'type': 'jib',
            'focus': focus,
            'outcome': outcome,
            'condition': null,
            'size': null,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
        ),
      ),
    );
  }

  Future<void> updateMemo({required TechMemo memo}) async {
    final now = DateTime.now().toIso8601String();
    await SupabaseClientProvider.guard(
      (client) => client.from('memos').update(
        memo.map(
          air: (airMemo) => {
            'focus': airMemo.focus,
            'outcome': airMemo.outcome,
            'condition': _conditionToDb(airMemo.condition),
            'size': _sizeToDb(airMemo.size),
            'updated_at': now,
          },
          jib: (jibMemo) => {
            'focus': jibMemo.focus,
            'outcome': jibMemo.outcome,
            'condition': null,
            'size': null,
            'updated_at': now,
          },
        ),
      ).eq('id', memo.id),
    );
  }

  Future<void> deleteMemo({required String memoId}) async {
    await SupabaseClientProvider.guard(
      (client) => client.from('memos').delete().eq('id', memoId),
    );
  }

  Trick _trickFromRow(
    Map<String, dynamic> row, {
    required Set<String> likedMemoIds,
  }) {
    final memos = (row['memos'] as List<dynamic>? ?? [])
        .map(
          (memo) => _memoFromRow(
            memo as Map<String, dynamic>,
            likedByMe: likedMemoIds.contains(memo['id'] as String),
          ),
        )
        .toList();
    memos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    final isPublic = row['is_public'] as bool? ?? true;

    final type = row['type'] as String;
    final meta = TrickMeta(
      id: row['id'] as String,
      userId: row['user_id'] as String,
      isPublic: isPublic,
      trickName: row['trick_name_ja'] as String? ?? '',
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
    if (type == 'jib') {
      return Trick.jib(
        meta: meta,
        customName: row['custom_name'] as String? ?? '',
        memos: memos,
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
      stance: _stanceFromDb(row['stance'] as String),
      takeoff: _takeoffFromDb(row['takeoff'] as String),
      axis: axis,
      spin: spin,
      grab: grab,
      direction: _directionFromDb(row['direction'] as String),
      memos: memos,
    );
  }

  TechMemo _memoFromRow(
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

  Stance _stanceFromDb(String value) {
    return Stance.fromCode(value);
  }

  String _stanceToDb(Stance value) {
    return value.code;
  }

  Takeoff _takeoffFromDb(String value) {
    return Takeoff.fromCode(value);
  }

  String _takeoffToDb(Takeoff value) {
    return value.code;
  }

  Direction _directionFromDb(String value) {
    return Direction.fromCode(value);
  }

  String _directionToDb(Direction value) {
    return value.code;
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

  String _conditionToDb(MemoCondition value) {
    switch (value) {
      case MemoCondition.snow:
        return 'snow';
      case MemoCondition.brush:
        return 'brush';
      case MemoCondition.none:
        return 'none';
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

  String _sizeToDb(MemoSize value) {
    switch (value) {
      case MemoSize.small:
        return 'small';
      case MemoSize.middle:
        return 'middle';
      case MemoSize.big:
        return 'big';
      case MemoSize.none:
        return 'none';
    }
  }
}
