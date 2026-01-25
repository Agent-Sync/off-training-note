class TrickGrabMaster {
  TrickGrabMaster({
    required this.code,
    required this.labelJa,
    required this.labelEn,
    required this.sortOrder,
  });

  final String code;
  final String labelJa;
  final String labelEn;
  final int sortOrder;

  factory TrickGrabMaster.fromRow(Map<String, dynamic> row) {
    return TrickGrabMaster(
      code: row['code'] as String,
      labelJa: row['label_ja'] as String? ?? '',
      labelEn: row['label_en'] as String? ?? '',
      sortOrder: (row['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

class TrickAxisMaster {
  TrickAxisMaster({
    required this.code,
    required this.labelJa,
    required this.labelEn,
    required this.sortOrder,
  });

  final String code;
  final String labelJa;
  final String labelEn;
  final int sortOrder;

  factory TrickAxisMaster.fromRow(Map<String, dynamic> row) {
    return TrickAxisMaster(
      code: row['code'] as String,
      labelJa: row['label_ja'] as String? ?? '',
      labelEn: row['label_en'] as String? ?? '',
      sortOrder: (row['sort_order'] as num?)?.toInt() ?? 0,
    );
  }
}

class TrickSpinMaster {
  TrickSpinMaster({
    required this.value,
    required this.labelJa,
    required this.labelEn,
    required this.sortOrder,
  });

  final int value;
  final String labelJa;
  final String labelEn;
  final int sortOrder;

  factory TrickSpinMaster.fromRow(Map<String, dynamic> row) {
    return TrickSpinMaster(
      value: (row['value'] as num?)?.toInt() ?? 0,
      labelJa: row['label_ja'] as String? ?? '',
      labelEn: row['label_en'] as String? ?? '',
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
