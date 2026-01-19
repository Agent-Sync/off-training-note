import 'package:off_training_note/utils/trick_labels.dart';

class AppConstants {
  static const List<int> spins = [0, 180, 360, 540, 720, 900, 1080, 1260, 1440, 1620, 1800];

  static const List<String> axes = [
    TrickLabels.axisFlat,
    'コーク',
    'バイオ',
    'ミスティ',
    'ロデオ',
    'フラットスピン',
    'アンダーフリップ',
    'ダブルコーク',
    'ダブルミスティ',
    'ダブルロデオ'
  ];

  static const List<String> grabs = [
    TrickLabels.grabNone,
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
    'タイパン'
  ];
}
