import 'package:off_training_note/models/trick.dart';

const _stanceSwitchLabel = 'スイッチ';
const _takeoffCarvingLabel = 'カービング';
const _axisFlatLabel = '平軸';
const _grabNoneLabel = 'なし';
const _defaultAirLabel = 'ストレートエア';
const _stanceRegularLabel = 'レギュラー';
const _directionLeftLabel = 'レフト';
const _directionRightLabel = 'ライト';
const _takeoffStandardLabel = 'ストレート';

extension TrickHelpers on Trick {
  String displayName() {
    final parts = <String>[];

    if (stance == Stance.switchStance) {
      parts.add(_stanceSwitchLabel);
    }

    if (type == TrickType.air && takeoff == Takeoff.carving) {
      parts.add(_takeoffCarvingLabel);
    }

    if (type == TrickType.air && axis.isNotEmpty && axis != _axisFlatLabel) {
      parts.add(axis);
    }

    if (spin > 0) parts.add(spin.toString());

    if (grab != _grabNoneLabel) parts.add(grab);

    if (parts.isEmpty) return _defaultAirLabel;

    return parts.join(' ');
  }

  String searchIndex() {
    return '$spin $grab $axis';
  }

  bool matchesQuery(String query) {
    if (query.isEmpty) return true;
    final normalized = query.toLowerCase();
    final name = searchIndex().toLowerCase();
    return name.contains(normalized) ||
        spin.toString().contains(normalized) ||
        grab.contains(normalized) ||
        axis.contains(normalized);
  }

  List<String> tagLabels() {
    final labels = <String>[];

    labels.add(_stanceLabel(stance));

    if (direction != Direction.none) {
      labels.add(_directionLabel(direction));
    }

    labels.add(_takeoffLabel(takeoff));

    if (axis.trim().isNotEmpty) labels.add(axis);

    if (spin > 0) labels.add(spin.toString());

    return labels;
  }
}

String _stanceLabel(Stance stance) =>
    stance == Stance.regular ? _stanceRegularLabel : _stanceSwitchLabel;

String _directionLabel(Direction direction) =>
    direction == Direction.left ? _directionLeftLabel : _directionRightLabel;

String _takeoffLabel(Takeoff takeoff) =>
    takeoff == Takeoff.standard ? _takeoffStandardLabel : _takeoffCarvingLabel;
