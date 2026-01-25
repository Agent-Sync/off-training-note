import 'package:off_training_note/models/trick.dart';

const _stanceSwitchLabel = 'スイッチ';
const _takeoffCarvingLabel = 'カービング';
const _defaultAirLabel = 'ストレート';
const _stanceRegularLabel = 'レギュラー';
const _directionLeftLabel = 'レフト';
const _directionRightLabel = 'ライト';
const _takeoffStandardLabel = 'ストレート';

extension TrickHelpers on Trick {
  String displayName() {
    return map(
      air: (air) => air.trickName.isNotEmpty ? air.trickName : _defaultAirLabel,
      jib: (jib) => jib.trickName.isNotEmpty ? jib.trickName : jib.customName,
    );
  }

  String searchIndex() {
    return map(
      air: (air) =>
          '${air.trickName} ${air.spin} ${air.grabLabel} ${air.axisLabel}',
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

List<String> _airTagLabels(AirTrick air) {
  final labels = <String>[];

  labels.add(_stanceLabel(air.stance));

  if (air.direction != Direction.none) {
    labels.add(_directionLabel(air.direction));
  }

  labels.add(_takeoffLabel(air.takeoff));

  labels.add(air.axisLabel);

  if (air.spin > 0 && !_isFlipAxis(air.axisCode)) {
    labels.add(air.spin.toString());
  }

  if (air.grabCode != 'none') {
    labels.add(air.grabLabel);
  }

  return labels;
}

String _stanceLabel(Stance stance) =>
    stance == Stance.regular ? _stanceRegularLabel : _stanceSwitchLabel;

String _directionLabel(Direction direction) =>
    direction == Direction.left ? _directionLeftLabel : _directionRightLabel;

String _takeoffLabel(Takeoff takeoff) =>
    takeoff == Takeoff.straight ? _takeoffStandardLabel : _takeoffCarvingLabel;

bool _isFlipAxis(String axisCode) =>
    axisCode == 'backflip' || axisCode == 'frontflip';
