import 'package:json_annotation/json_annotation.dart';

part 'spin.g.dart';

@JsonSerializable()
class Spin {
  const Spin({
    required this.value,
    required this.labelJa,
    required this.labelEn,
  });

  final int value;
  final String labelJa;
  final String labelEn;

  factory Spin.fromJson(Map<String, dynamic> json) => _$SpinFromJson(json);

  factory Spin.fromRow(Map<String, dynamic> row) {
    return Spin(
      value: (row['value'] as num?)?.toInt() ?? 0,
      labelJa: row['label_ja'] as String? ?? '',
      labelEn: row['label_en'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$SpinToJson(this);
}
