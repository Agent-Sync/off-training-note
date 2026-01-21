import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:off_training_note/models/tech_memo.dart';

part 'air_trick.freezed.dart';
part 'air_trick.g.dart';

enum Stance { regular, switchStance } // 'switch' is a keyword in Dart

enum Takeoff { standard, carving }

enum Direction { none, left, right }

@freezed
abstract class AirTrick with _$AirTrick {
  const factory AirTrick({
    required String id,
    required Stance stance,
    required Takeoff takeoff,
    required String axis,
    required int spin,
    required String grab,
    required Direction direction,
    required List<TechMemo> memos,
    required DateTime createdAt,
  }) = _Trick;

  static const spins = [
    0,
    180,
    360,
    540,
    720,
    900,
    1080,
    1260,
    1440,
    1620,
    1800,
  ];

  static const axes = [
    '平軸',
    'バックフリップ',
    'フロントフリップ',
    'コーク',
    'バイオ',
    'ミスティ',
    'ロデオ',
    'フラットスピン',
    'アンダーフリップ',
    'ダブルコーク',
    'ダブルミスティ',
    'ダブルロデオ',
  ];

  static const grabs = [
    'なし',
    'セーフティ',
    'ミュート',
    'ジャパン',
    'テール',
    'ノーズ',
    'トラックドライバー',
    'オクトグラブ',
    'ステールフィッシュ',
    'クリティカル',
    'リードミュート',
    'リードジャパン',
    'リードテール',
    'ブラント',
    'スクリーミンシーマン',
    'タイパン',
  ];

  factory AirTrick.fromJson(Map<String, dynamic> json) =>
      _$AirTrickFromJson(json);
}
