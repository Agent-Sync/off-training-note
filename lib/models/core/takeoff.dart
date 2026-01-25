enum Takeoff {
  straight('straight', 'ストレート', 'Straight'),
  carving('carving', 'カービング', 'Carving');

  const Takeoff(this.code, this.labelJa, this.labelEn);

  final String code;
  final String labelJa;
  final String labelEn;

  static Takeoff fromCode(String value) {
    for (final takeoff in Takeoff.values) {
      if (takeoff.code == value) return takeoff;
    }
    return Takeoff.straight;
  }
}
