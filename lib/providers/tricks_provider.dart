import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

final _trickUuid = Uuid();

final tricksProvider = NotifierProvider<TricksNotifier, List<Trick>>(
  TricksNotifier.new,
);

class TricksNotifier extends Notifier<List<Trick>> {
  @override
  List<Trick> build() {
    _loadTricks();
    return const [];
  }

  Future<void> _loadTricks() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      state = const [];
      return;
    }

    final rows = await Supabase.instance.client
        .from('tricks')
        .select(
          'id, type, custom_name, stance, takeoff, axis, spin, grab, direction, '
          'created_at, updated_at, memos(id, trick_id, type, focus, outcome, '
          'condition, size, created_at, updated_at)',
        )
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .order('updated_at', referencedTable: 'memos', ascending: false);

    final tricks = (rows as List<dynamic>)
        .map((row) => _trickFromRow(row as Map<String, dynamic>))
        .toList();
    state = tricks;
  }

  Future<void> addTrick(Trick trick) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) {
      return;
    }

    final now = DateTime.now().toIso8601String();
    await Supabase.instance.client.from('tricks').insert(
      trick.map(
        air: (air) => {
          'id': air.id,
          'user_id': userId,
          'type': 'air',
          'custom_name': null,
          'stance': _stanceToDb(air.stance),
          'takeoff': _takeoffToDb(air.takeoff),
          'axis': air.axis,
          'spin': air.spin,
          'grab': air.grab,
          'direction': _directionToDb(air.direction),
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
          'created_at': jib.createdAt.toIso8601String(),
          'updated_at': now,
        },
      ),
    );
    await _loadTricks();
  }

  Future<void> addMemo(
    String trickId,
    String focus,
    String outcome, {
    MemoCondition? condition,
    MemoSize? size,
  }) async {
    final target = state.cast<Trick?>().firstWhere(
          (trick) => trick?.id == trickId,
          orElse: () => null,
        );
    if (target == null) {
      return;
    }

    final now = DateTime.now();
    final memoId = _trickUuid.v4();
    await Supabase.instance.client.from('memos').insert(
      target.map(
        air: (_) => {
          'id': memoId,
          'trick_id': trickId,
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
          'trick_id': trickId,
          'type': 'jib',
          'focus': focus,
          'outcome': outcome,
          'condition': null,
          'size': null,
          'created_at': now.toIso8601String(),
          'updated_at': now.toIso8601String(),
        },
      ),
    );
    await _loadTricks();
  }

  Future<void> updateMemo(String trickId, TechMemo updatedMemo) async {
    final now = DateTime.now().toIso8601String();
    await Supabase.instance.client.from('memos').update(
      updatedMemo.map(
        air: (memo) => {
          'focus': memo.focus,
          'outcome': memo.outcome,
          'condition': _conditionToDb(memo.condition),
          'size': _sizeToDb(memo.size),
          'updated_at': now,
        },
        jib: (memo) => {
          'focus': memo.focus,
          'outcome': memo.outcome,
          'condition': null,
          'size': null,
          'updated_at': now,
        },
      ),
    ).eq('id', updatedMemo.id);
    await _loadTricks();
  }

  Future<void> deleteMemo(String trickId, String memoId) async {
    await Supabase.instance.client.from('memos').delete().eq('id', memoId);
    await _loadTricks();
  }

  Trick _trickFromRow(Map<String, dynamic> row) {
    final memos = (row['memos'] as List<dynamic>? ?? [])
        .map((memo) => _memoFromRow(memo as Map<String, dynamic>))
        .toList();
    memos.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

    final type = row['type'] as String;
    if (type == 'jib') {
      return Trick.jib(
        id: row['id'] as String,
        customName: row['custom_name'] as String? ?? '',
        memos: memos,
        createdAt: DateTime.parse(row['created_at'] as String),
      );
    }

    return Trick.air(
      id: row['id'] as String,
      stance: _stanceFromDb(row['stance'] as String),
      takeoff: _takeoffFromDb(row['takeoff'] as String),
      axis: row['axis'] as String,
      spin: (row['spin'] as num).toInt(),
      grab: row['grab'] as String,
      direction: _directionFromDb(row['direction'] as String),
      memos: memos,
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  TechMemo _memoFromRow(Map<String, dynamic> row) {
    final type = row['type'] as String;
    if (type == 'jib') {
      return TechMemo.jib(
        id: row['id'] as String,
        focus: row['focus'] as String,
        outcome: row['outcome'] as String,
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
      updatedAt: DateTime.parse(row['updated_at'] as String),
      createdAt: DateTime.parse(row['created_at'] as String),
    );
  }

  Stance _stanceFromDb(String value) {
    switch (value) {
      case 'switchStance':
        return Stance.switchStance;
      case 'regular':
      default:
        return Stance.regular;
    }
  }

  String _stanceToDb(Stance value) {
    switch (value) {
      case Stance.switchStance:
        return 'switchStance';
      case Stance.regular:
        return 'regular';
    }
  }

  Takeoff _takeoffFromDb(String value) {
    switch (value) {
      case 'carving':
        return Takeoff.carving;
      case 'standard':
      default:
        return Takeoff.standard;
    }
  }

  String _takeoffToDb(Takeoff value) {
    switch (value) {
      case Takeoff.carving:
        return 'carving';
      case Takeoff.standard:
        return 'standard';
    }
  }

  Direction _directionFromDb(String value) {
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

  String _directionToDb(Direction value) {
    switch (value) {
      case Direction.left:
        return 'left';
      case Direction.right:
        return 'right';
      case Direction.none:
        return 'none';
    }
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
