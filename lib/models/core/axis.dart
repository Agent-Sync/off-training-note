import 'package:json_annotation/json_annotation.dart';

part 'axis.g.dart';

@JsonSerializable()
class Axis {
  const Axis({
    required this.code,
    required this.labelJa,
    required this.labelEn,
  });

  final String code;
  final String labelJa;
  final String labelEn;

  factory Axis.fromJson(Map<String, dynamic> json) => _$AxisFromJson(json);

  factory Axis.fromRow(Map<String, dynamic> row) {
    return Axis(
      code: row['code'] as String? ?? '',
      labelJa: row['label_ja'] as String? ?? '',
      labelEn: row['label_en'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$AxisToJson(this);
}
