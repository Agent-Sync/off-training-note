// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trick_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TrickMeta _$TrickMetaFromJson(Map<String, dynamic> json) => _TrickMeta(
  id: json['id'] as String,
  userId: json['userId'] as String,
  isPublic: json['isPublic'] as bool? ?? true,
  trickName: json['trickName'] as String? ?? '',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TrickMetaToJson(_TrickMeta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'isPublic': instance.isPublic,
      'trickName': instance.trickName,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
