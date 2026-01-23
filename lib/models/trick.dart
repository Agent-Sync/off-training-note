import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:off_training_note/models/tech_memo.dart';

part 'trick.freezed.dart';
part 'trick.g.dart';

enum Stance { regular, switchStance } // 'switch' is a keyword in Dart

enum Takeoff { standard, carving }

enum Direction { none, left, right }

enum Axis {
  upright('平軸'),
  backflip('バックフリップ'),
  frontflip('フロントフリップ'),
  cork('コーク'),
  bio('バイオ'),
  misty('ミスティ'),
  rodeo('ロデオ'),
  flatspin('フラットスピン'),
  underflip('アンダーフリップ'),
  doubleCork('ダブルコーク'),
  doubleMisty('ダブルミスティ'),
  doubleRodeo('ダブルロデオ');

  const Axis(this.label);

  final String label;

  bool get isFlat => this == Axis.upright;
  bool get isFlip => this == Axis.backflip || this == Axis.frontflip;

  static Axis fromDb(String value) {
    final normalized = value.trim().toLowerCase();
    for (final axis in Axis.values) {
      if (axis.name.toLowerCase() == normalized) {
        return axis;
      }
    }
    return Axis.upright;
  }

  static Axis fromLabel(String label) {
    final trimmed = label.trim();
    for (final axis in Axis.values) {
      if (axis.label == trimmed) {
        return axis;
      }
    }
    return Axis.upright;
  }
}

enum Grab {
  none('なし'),
  safety('セーフティ'),
  mute('ミュート'),
  japan('ジャパン'),
  tail('テール'),
  nose('ノーズ'),
  truckDriver('トラックドライバー'),
  octoGrab('オクトグラブ'),
  staleFish('ステールフィッシュ'),
  critical('クリティカル'),
  leadMute('リードミュート'),
  leadJapan('リードジャパン'),
  leadTail('リードテール'),
  blunt('ブラント'),
  screaminSeaman('スクリーミンシーマン'),
  taipan('タイパン');

  const Grab(this.label);

  final String label;

  static Grab fromDb(String value) {
    final normalized = value.trim().toLowerCase();
    for (final grab in Grab.values) {
      if (grab.name.toLowerCase() == normalized) {
        return grab;
      }
    }
    return Grab.none;
  }

  static Grab fromLabel(String label) {
    final trimmed = label.trim();
    for (final grab in Grab.values) {
      if (grab.label == trimmed) {
        return grab;
      }
    }
    return Grab.none;
  }
}

enum SpinOption {
  s0(0),
  s180(180),
  s360(360),
  s540(540),
  s720(720),
  s900(900),
  s1080(1080),
  s1260(1260),
  s1440(1440),
  s1620(1620),
  s1800(1800);

  const SpinOption(this.value);

  final int value;

  String get label => value.toString();
}

@Freezed(unionKey: 'type')
abstract class Trick with _$Trick {
  const factory Trick.air({
    required String id,
    required Stance stance,
    required Takeoff takeoff,
    required Axis axis,
    required int spin,
    required Grab grab,
    required Direction direction,
    required List<TechMemo> memos,
    @Default(true) bool isPublic,
    required DateTime createdAt,
  }) = AirTrick;

  const factory Trick.jib({
    required String id,
    required String customName,
    required List<TechMemo> memos,
    @Default(true) bool isPublic,
    required DateTime createdAt,
  }) = JibTrick;

  static List<SpinOption> get spinOptions => SpinOption.values;
  static List<Axis> get axisOptions => Axis.values;
  static List<Grab> get grabOptions => Grab.values;

  factory Trick.fromJson(Map<String, dynamic> json) =>
      _$TrickFromJson(json);
}
