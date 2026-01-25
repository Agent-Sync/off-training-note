import 'package:off_training_note/models/core/axis.dart';
import 'package:off_training_note/models/core/grab.dart';
import 'package:off_training_note/models/core/spin.dart';

class TrickGrabMaster {
  TrickGrabMaster({
    required this.grab,
    required this.sortOrder,
  });

  final Grab grab;
  final int sortOrder;

  String get code => grab.code;
  String get labelJa => grab.labelJa;
  String get labelEn => grab.labelEn;

  factory TrickGrabMaster.fromRow(Map<String, dynamic> row) {
    return TrickGrabMaster(
      grab: Grab.fromRow(row),
      sortOrder: (row['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

class TrickAxisMaster {
  TrickAxisMaster({
    required this.axis,
    required this.sortOrder,
  });

  final Axis axis;
  final int sortOrder;

  String get code => axis.code;
  String get labelJa => axis.labelJa;
  String get labelEn => axis.labelEn;

  factory TrickAxisMaster.fromRow(Map<String, dynamic> row) {
    return TrickAxisMaster(
      axis: Axis.fromRow(row),
      sortOrder: (row['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

class TrickSpinMaster {
  TrickSpinMaster({
    required this.spin,
    required this.sortOrder,
  });

  final Spin spin;
  final int sortOrder;

  int get value => spin.value;
  String get labelJa => spin.labelJa;
  String get labelEn => spin.labelEn;

  factory TrickSpinMaster.fromRow(Map<String, dynamic> row) {
    return TrickSpinMaster(
      spin: Spin.fromRow(row),
      sortOrder: (row['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

class TrickMasterData {
  const TrickMasterData({
    required this.grabs,
    required this.axes,
    required this.spins,
  });

  final List<TrickGrabMaster> grabs;
  final List<TrickAxisMaster> axes;
  final List<TrickSpinMaster> spins;
}
