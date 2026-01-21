import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/air_trick.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

final tricksProvider = NotifierProvider<TricksNotifier, List<AirTrick>>(
  TricksNotifier.new,
);

class TricksNotifier extends Notifier<List<AirTrick>> {
  static const _storageKey = 'tricks_data';

  @override
  List<AirTrick> build() {
    _loadTricks();
    // 初期値は空で返し、非同期ロード後に更新する形にする
    // または同期的にロードできるならするが、SharedPreferencesは非同期
    // ここでは一旦初期ダミーデータを返し、ロード完了後に上書きする戦略をとる
    return _initialTricks;
  }

  Future<void> _loadTricks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_storageKey);

    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      final tricks = jsonList.map((e) => AirTrick.fromJson(e)).toList();
      state = tricks;
    } else {
      // 初回起動時などでデータがない場合は初期データを使用し、保存する
      // build()で既に返しているのでstate更新は不要だが、保存はしておく
      _saveTricks();
    }
  }

  Future<void> _saveTricks() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(
      state.map((e) => e.toJson()).toList(),
    );
    await prefs.setString(_storageKey, jsonString);
  }

  void addTrick(AirTrick trick) {
    state = [trick, ...state];
    _saveTricks();
  }

  void addMemo(
    String trickId,
    String focus,
    String outcome, {
    MemoCondition condition = MemoCondition.none,
    MemoSize size = MemoSize.none,
  }) {
    state = state.map((trick) {
      if (trick.id == trickId) {
        final newMemo = TechMemo(
          id: uuid.v4(),
          focus: focus,
          outcome: outcome,
          condition: condition,
          size: size,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        return trick.copyWith(memos: [newMemo, ...trick.memos]);
      }
      return trick;
    }).toList();
    _saveTricks();
  }

  void updateMemo(String trickId, TechMemo updatedMemo) {
    state = state.map((trick) {
      if (trick.id == trickId) {
        final newMemos = trick.memos.map((memo) {
          return memo.id == updatedMemo.id
              ? updatedMemo.copyWith(updatedAt: DateTime.now())
              : memo;
        }).toList();
        return trick.copyWith(memos: newMemos);
      }
      return trick;
    }).toList();
    _saveTricks();
  }

  void deleteMemo(String trickId, String memoId) {
    state = state.map((trick) {
      if (trick.id == trickId) {
        final newMemos = trick.memos
            .where((memo) => memo.id != memoId)
            .toList();
        return trick.copyWith(memos: newMemos);
      }
      return trick;
    }).toList();
    _saveTricks();
  }

  static final List<AirTrick> _initialTricks = [
    AirTrick(
      id: uuid.v4(),
      stance: Stance.regular,
      direction: Direction.left,
      takeoff: Takeoff.carving,
      axis: '平軸',
      spin: 540,
      grab: 'ミュート',
      memos: [
        TechMemo(
          id: uuid.v4(),
          focus: 'テイクオフで肩のラインを水平に保つ',
          outcome: '軸が安定して回転がスムーズになった',
          condition: MemoCondition.snow,
          size: MemoSize.big,
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        TechMemo(
          id: uuid.v4(),
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
    AirTrick(
      id: uuid.v4(),
      stance: Stance.regular,
      direction: Direction.right,
      takeoff: Takeoff.standard,
      axis: 'コーク',
      spin: 720,
      grab: 'セーフティ',
      memos: [
        TechMemo(
          id: uuid.v4(),
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
    AirTrick(
      id: uuid.v4(),
      stance: Stance.switchStance,
      direction: Direction.left,
      takeoff: Takeoff.standard,
      axis: '平軸',
      spin: 540,
      grab: 'ジャパン',
      memos: [
        TechMemo(
          id: uuid.v4(),
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
  ];
}
