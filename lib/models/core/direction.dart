enum Direction {
  none('none', 'なし', 'None'),
  left('left', 'レフト', 'Left'),
  right('right', 'ライト', 'Right');

  const Direction(this.code, this.labelJa, this.labelEn);

  final String code;
  final String labelJa;
  final String labelEn;

  static Direction fromCode(String value) {
    for (final direction in Direction.values) {
      if (direction.code == value) return direction;
    }
    return Direction.none;
  }
}
