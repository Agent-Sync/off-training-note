import 'package:off_training_note/models/trick.dart';

const _stanceSwitchLabel = 'スイッチ';
const _takeoffCarvingLabel = 'カービング';
const _axisFlatLabel = '平軸';
const _axisBackflipLabel = 'バックフリップ';
const _axisFrontflipLabel = 'フロントフリップ';
const _grabNoneLabel = 'なし';
const _defaultAirLabel = 'ストレート';
const _stanceRegularLabel = 'レギュラー';
const _directionLeftLabel = 'レフト';
const _directionRightLabel = 'ライト';
const _takeoffStandardLabel = 'ストレート';

extension TrickHelpers on Trick {
  String displayName() {
    return map(
      air: _airDisplayName,
      jib: (jib) => jib.customName,
    );
  }

  String searchIndex() {
    return map(
      air: (air) => '${air.spin} ${air.grab} ${air.axis}',
      jib: (jib) => jib.customName,
    );
  }

  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    final normalized = query.toLowerCase();
    final name = searchIndex().toLowerCase();
    return name.contains(normalized);
  }

  List<String> tagLabels() {
    return map(
      air: _airTagLabels,
      jib: (_) => const [],
    );
  }
}

String _airDisplayName(AirTrick air) {
  final parts = <String>[];

  if (air.stance == Stance.regular && air.spin == 0) {
    final isFlatAxis = air.axis == _axisFlatLabel;
    if (air.takeoff == Takeoff.carving) {
      parts.add(_takeoffCarvingLabel);
      if (isFlatAxis) {
        parts.add(_takeoffStandardLabel);
      }
    } else if (isFlatAxis) {
      parts.add(_takeoffStandardLabel);
    }
    if (!isFlatAxis) {
      parts.add(air.axis);
      if (!_isFlipAxis(air.axis)) {
        parts.add(air.spin.toString());
      }
    }
    if (air.grab != _grabNoneLabel) {
      parts.add(air.grab);
    }
    return parts.join(' ');
  }

  if (air.stance == Stance.switchStance && air.spin == 0) {
    final isFlatAxis = air.axis == _axisFlatLabel;
    parts.add(_stanceSwitchLabel);
    if (air.direction != Direction.none) {
      parts.add(_directionLabel(air.direction));
    }
    if (air.takeoff == Takeoff.carving) {
      parts.add(_takeoffCarvingLabel);
    }
    if (!isFlatAxis) {
      parts.add(air.axis);
      if (!_isFlipAxis(air.axis)) {
        parts.add(air.spin.toString());
      }
    } else {
      parts.add('0');
    }
    if (air.grab != _grabNoneLabel) {
      parts.add(air.grab);
    }
    return parts.join(' ');
  }

  if (air.stance == Stance.switchStance) {
    parts.add(_stanceSwitchLabel);
  }

  if (air.direction != Direction.none) {
    parts.add(_directionLabel(air.direction));
  }

  if (air.takeoff == Takeoff.carving) {
    parts.add(_takeoffCarvingLabel);
  }

  if (air.axis != _axisFlatLabel) {
    parts.add(air.axis);
  }

  if (air.spin > 0 && !_isFlipAxis(air.axis)) {
    parts.add(air.spin.toString());
  }

  if (air.grab != _grabNoneLabel) {
    parts.add(air.grab);
  }

  if (parts.isEmpty) return _defaultAirLabel;
  return parts.join(' ');
}

List<String> _airTagLabels(AirTrick air) {
  final labels = <String>[];

  labels.add(_stanceLabel(air.stance));

  if (air.direction != Direction.none) {
    labels.add(_directionLabel(air.direction));
  }

  labels.add(_takeoffLabel(air.takeoff));

  if (air.axis.trim().isNotEmpty) labels.add(air.axis);

  if (air.spin > 0 && !_isFlipAxis(air.axis)) {
    labels.add(air.spin.toString());
  }

  return labels;
}

String _stanceLabel(Stance stance) =>
    stance == Stance.regular ? _stanceRegularLabel : _stanceSwitchLabel;

String _directionLabel(Direction direction) =>
    direction == Direction.left ? _directionLeftLabel : _directionRightLabel;

String _takeoffLabel(Takeoff takeoff) =>
    takeoff == Takeoff.standard ? _takeoffStandardLabel : _takeoffCarvingLabel;

bool _isFlipAxis(String axis) =>
    axis == _axisBackflipLabel || axis == _axisFrontflipLabel;
