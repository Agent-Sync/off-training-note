// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Spin _$SpinFromJson(Map<String, dynamic> json) => Spin(
  value: (json['value'] as num).toInt(),
  labelJa: json['labelJa'] as String,
  labelEn: json['labelEn'] as String,
);

Map<String, dynamic> _$SpinToJson(Spin instance) => <String, dynamic>{
  'value': instance.value,
  'labelJa': instance.labelJa,
  'labelEn': instance.labelEn,
};
