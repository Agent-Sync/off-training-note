import 'package:json_annotation/json_annotation.dart';

part 'grab.g.dart';

@JsonSerializable()
class Grab {
  const Grab({
    required this.code,
    required this.labelJa,
    required this.labelEn,
  });

  final String code;
  final String labelJa;
  final String labelEn;

  factory Grab.fromJson(Map<String, dynamic> json) => _$GrabFromJson(json);

  factory Grab.fromRow(Map<String, dynamic> row) {
    return Grab(
      code: row['code'] as String? ?? '',
      labelJa: row['label_ja'] as String? ?? '',
      labelEn: row['label_en'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => _$GrabToJson(this);
}
