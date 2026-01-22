import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final _trickUuid = Uuid();

final tricksProvider = NotifierProvider<TricksNotifier, List<Trick>>(
  TricksNotifier.new,
);

class TricksNotifier extends Notifier<List<Trick>> {
  static const _storageKey = 'tricks_data_v3';

  @override
  List<Trick> build() {
    _loadTricks();
    return _initialTricks;
  }

  Future<void> _loadTricks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      state = jsonList.map((e) => Trick.fromJson(e)).toList();
    } else {
      _saveTricks();
    }
  }

  Future<void> _saveTricks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  void addTrick(Trick trick) {
    state = [trick, ...state];
    _saveTricks();
  }

  void addJibTrick(String customName) {
    addTrick(
      Trick.jib(
        id: _trickUuid.v4(),
        customName: customName,
        memos: const [],
        createdAt: DateTime.now(),
      ),
    );
  }

  void addMemo(
    String trickId,
    String focus,
    String outcome, {
    MemoCondition? condition,
    MemoSize? size,
  }) {
    state = state.map((trick) {
      return trick.map(
        air: (air) {
          if (air.id != trickId) {
            return air;
          }
          final newMemo = TechMemo.air(
            id: _trickUuid.v4(),
            focus: focus,
            outcome: outcome,
            condition: condition ?? MemoCondition.none,
            size: size ?? MemoSize.none,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          return air.copyWith(memos: [newMemo, ...air.memos]);
        },
        jib: (jib) {
          if (jib.id != trickId) {
            return jib;
          }
          final newMemo = TechMemo.jib(
            id: _trickUuid.v4(),
            focus: focus,
            outcome: outcome,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          return jib.copyWith(memos: [newMemo, ...jib.memos]);
        },
      );
    }).toList();
    _saveTricks();
  }

  void updateMemo(String trickId, TechMemo updatedMemo) {
    state = state.map((trick) {
      return trick.map(
        air: (air) {
          if (air.id != trickId) {
            return air;
          }
          final refreshed = updatedMemo.map(
            air: (memo) => memo.copyWith(updatedAt: DateTime.now()),
            jib: (memo) => memo.copyWith(updatedAt: DateTime.now()),
          );
          final newMemos = air.memos.map((memo) {
            return memo.id == updatedMemo.id ? refreshed : memo;
          }).toList();
          return air.copyWith(memos: newMemos);
        },
        jib: (jib) {
          if (jib.id != trickId) {
            return jib;
          }
          final refreshed = updatedMemo.map(
            air: (memo) => memo.copyWith(updatedAt: DateTime.now()),
            jib: (memo) => memo.copyWith(updatedAt: DateTime.now()),
          );
          final newMemos = jib.memos.map((memo) {
            return memo.id == updatedMemo.id ? refreshed : memo;
          }).toList();
          return jib.copyWith(memos: newMemos);
        },
      );
    }).toList();
    _saveTricks();
  }

  void deleteMemo(String trickId, String memoId) {
    state = state.map((trick) {
      return trick.map(
        air: (air) {
          if (air.id != trickId) {
            return air;
          }
          final newMemos = air.memos
              .where((memo) => memo.id != memoId)
              .toList();
          return air.copyWith(memos: newMemos);
        },
        jib: (jib) {
          if (jib.id != trickId) {
            return jib;
          }
          final newMemos = jib.memos
              .where((memo) => memo.id != memoId)
              .toList();
          return jib.copyWith(memos: newMemos);
        },
      );
    }).toList();
    _saveTricks();
  }

  static final List<Trick> _initialTricks = [
    Trick.air(
      id: _trickUuid.v4(),
      stance: Stance.regular,
      direction: Direction.left,
      takeoff: Takeoff.carving,
      axis: '平軸',
      spin: 540,
      grab: 'ミュート',
      memos: [
        TechMemo.air(
          id: _trickUuid.v4(),
          focus: 'テイクオフで肩のラインを水平に保つ',
          outcome: '軸が安定して回転がスムーズになった',
          condition: MemoCondition.snow,
          size: MemoSize.big,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        TechMemo.air(
          id: _trickUuid.v4(),
          focus: '360の時点でランディングを見る',
          outcome: '着地が完璧に決まった',
          condition: MemoCondition.snow,
          size: MemoSize.middle,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
      ],
      createdAt: DateTime.now(),
    ),
    Trick.air(
      id: _trickUuid.v4(),
      stance: Stance.regular,
      direction: Direction.right,
      takeoff: Takeoff.standard,
      axis: 'コーク',
      spin: 720,
      grab: 'セーフティ',
      memos: [
        TechMemo.air(
          id: _trickUuid.v4(),
          focus: '右肩を下げながら抜ける',
          outcome: 'しっかり軸が入った',
          condition: MemoCondition.snow,
          size: MemoSize.big,
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Trick.air(
      id: _trickUuid.v4(),
      stance: Stance.switchStance,
      direction: Direction.left,
      takeoff: Takeoff.standard,
      axis: '平軸',
      spin: 540,
      grab: 'ジャパン',
      memos: [
        TechMemo.air(
          id: _trickUuid.v4(),
          focus: '目線を先行させる',
          outcome: '回転不足が解消',
          condition: MemoCondition.brush,
          size: MemoSize.small,
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Trick.jib(
      id: _trickUuid.v4(),
      customName: 'フロントボードスライド',
      memos: [
        TechMemo.jib(
          id: _trickUuid.v4(),
          focus: '腰を真ん中に保つ',
          outcome: '抜けが安定した',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Trick.jib(
      id: _trickUuid.v4(),
      customName: 'スイッチテールプレス',
      memos: [
        TechMemo.jib(
          id: _trickUuid.v4(),
          focus: '肩のラインを進行方向に向ける',
          outcome: '回り込みが減った',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];
}
