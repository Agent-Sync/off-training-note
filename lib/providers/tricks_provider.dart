import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_training_note/models/tech_log.dart';
import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/utils/trick_labels.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

final uuid = Uuid();

final tricksProvider = NotifierProvider<TricksNotifier, List<Trick>>(TricksNotifier.new);

class TricksNotifier extends Notifier<List<Trick>> {
  static const _storageKey = 'tricks_data';

  @override
  List<Trick> build() {
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
      final tricks = jsonList.map((e) => Trick.fromJson(e)).toList();
      state = tricks;
    } else {
      // 初回起動時などでデータがない場合は初期データを使用し、保存する
      // build()で既に返しているのでstate更新は不要だが、保存はしておく
      _saveTricks();
    }
  }

  Future<void> _saveTricks() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = json.encode(state.map((e) => e.toJson()).toList());
    await prefs.setString(_storageKey, jsonString);
  }

  void addTrick(Trick trick) {
    state = [trick, ...state];
    _saveTricks();
  }

  void addLog(String trickId, String focus, String outcome, {String? condition, String? size}) {
    state = state.map((trick) {
      if (trick.id == trickId) {
        final newLog = TechLog(
          id: uuid.v4(),
          focus: focus,
          outcome: outcome,
          createdAt: DateTime.now(),
          condition: condition,
          size: size,
        );
        return trick.copyWith(
          logs: [newLog, ...trick.logs],
          updatedAt: DateTime.now(),
        );
      }
      return trick;
    }).toList();
    _saveTricks();
  }

  void updateLog(String trickId, TechLog updatedLog) {
    state = state.map((trick) {
      if (trick.id == trickId) {
        final newLogs = trick.logs.map((log) {
          return log.id == updatedLog.id ? updatedLog : log;
        }).toList();
        return trick.copyWith(
          logs: newLogs,
          updatedAt: DateTime.now(),
        );
      }
      return trick;
    }).toList();
    _saveTricks();
  }

  void deleteLog(String trickId, String logId) {
    state = state.map((trick) {
      if (trick.id == trickId) {
        final newLogs = trick.logs.where((log) => log.id != logId).toList();
        return trick.copyWith(
          logs: newLogs,
          updatedAt: DateTime.now(),
        );
      }
      return trick;
    }).toList();
    _saveTricks();
  }

  static final List<Trick> _initialTricks = [
    Trick(
      id: '1',
      type: TrickType.air,
      stance: Stance.regular,
      direction: Direction.left,
      takeoff: Takeoff.carving,
      axis: TrickLabels.axisFlat,
      spin: 540,
      grab: 'ミュート',
      logs: [
        TechLog(
          id: 'l1',
          focus: 'テイクオフで肩のラインを水平に保つ',
          outcome: '軸が安定して回転がスムーズになった',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          condition: 'snow',
          size: 'big',
        ),
        TechLog(
          id: 'l2',
          focus: '360の時点でランディングを見る',
          outcome: '着地が完璧に決まった',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          condition: 'snow',
          size: 'middle',
        ),
      ],
      updatedAt: DateTime.now(),
    ),
    Trick(
      id: '3',
      type: TrickType.air,
      stance: Stance.regular,
      direction: Direction.right,
      takeoff: Takeoff.standard,
      axis: 'コーク',
      spin: 720,
      grab: 'セーフティ',
      logs: [
        TechLog(
          id: 'l_c7_1',
          focus: '右肩を下げながら抜ける',
          outcome: 'しっかり軸が入った',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          condition: 'snow',
          size: 'big',
        ),
      ],
      updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
    ),
    Trick(
      id: '4',
      type: TrickType.air,
      stance: Stance.switchStance,
      direction: Direction.left,
      takeoff: Takeoff.standard,
      axis: TrickLabels.axisFlat,
      spin: 540,
      grab: 'ジャパン',
      logs: [
        TechLog(
          id: 'l_sw5_1',
          focus: '目線を先行させる',
          outcome: '回転不足が解消',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
          condition: 'brush',
          size: 'small',
        ),
      ],
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Trick(
      id: '2',
      type: TrickType.jib,
      stance: Stance.switchStance,
      direction: Direction.right,
      takeoff: Takeoff.standard,
      spin: 270,
      grab: TrickLabels.grabNone,
      logs: [
        TechLog(
          id: 'l3',
          focus: 'リップで早めに弾く',
          outcome: 'ギャップを余裕で越えられた',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
          condition: 'snow',
          size: 'small',
        ),
      ],
      updatedAt: DateTime.now(),
    ),
  ];
}
