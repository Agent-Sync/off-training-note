// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'jib_trick.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JibTrick _$JibTrickFromJson(Map<String, dynamic> json) => _JibTrick(
  id: json['id'] as String,
  customName: json['customName'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$JibTrickToJson(_JibTrick instance) => <String, dynamic>{
  'id': instance.id,
  'customName': instance.customName,
  'createdAt': instance.createdAt.toIso8601String(),
};
