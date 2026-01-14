import 'package:off_training_note/models/trick.dart';

class TrickLabels {
  static const String stanceRegular = 'レギュラー';
  static const String stanceSwitch = 'スイッチ';

  static const String directionLeft = 'レフト';
  static const String directionRight = 'ライト';

  static const String takeoffStandard = 'ストレート';
  static const String takeoffCarving = 'カービング';

  static const String axisFlat = '平軸';

  static const String grabNone = 'なし';

  static const String defaultAir = 'ストレートエア';

  static const String sectionDirection = '方向';
  static const String sectionTakeoff = 'テイクオフ';
  static const String sectionAxis = '軸';

  static String stance(Stance stance) =>
      stance == Stance.regular ? stanceRegular : stanceSwitch;

  static String direction(Direction direction) =>
      direction == Direction.left ? directionLeft : directionRight;

  static String takeoff(Takeoff takeoff) =>
      takeoff == Takeoff.standard ? takeoffStandard : takeoffCarving;
}
