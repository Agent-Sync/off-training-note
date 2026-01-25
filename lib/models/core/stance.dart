enum Stance {
  regular('regular', 'レギュラー', 'Regular'),
  switchStance('switchStance', 'スイッチ', 'Switch'); // 'switch' is a keyword in Dart

  const Stance(this.code, this.labelJa, this.labelEn);

  final String code;
  final String labelJa;
  final String labelEn;

  static Stance fromCode(String value) {
    for (final stance in Stance.values) {
      if (stance.code == value) return stance;
    }
    return Stance.regular;
  }
}
