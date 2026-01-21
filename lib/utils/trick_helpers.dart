import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/utils/trick_labels.dart';

extension TrickHelpers on Trick {
  String displayName() {
    final parts = <String>[];

    if (stance == Stance.switchStance) {
      parts.add(TrickLabels.stanceSwitch);
    }

    if (type == TrickType.air && takeoff == Takeoff.carving) {
      parts.add(TrickLabels.takeoffCarving);
    }

    if (type == TrickType.air &&
        axis.isNotEmpty &&
        axis != TrickLabels.axisFlat) {
      parts.add(axis);
    }

    if (spin > 0) parts.add(spin.toString());

    if (grab != TrickLabels.grabNone) parts.add(grab);

    if (parts.isEmpty) return TrickLabels.defaultAir;

    return parts.join(' ');
  }

  String searchIndex() {
    return '${spin} ${grab} ${axis}';
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

    labels.add(TrickLabels.stance(stance));

    if (direction != null) {
      labels.add(TrickLabels.direction(direction!));
    }

    labels.add(TrickLabels.takeoff(takeoff));

    if (axis.trim().isNotEmpty) labels.add(axis);

    if (spin > 0) labels.add(spin.toString());

    return labels;
  }
}
