// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tech_memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AirTechMemo _$AirTechMemoFromJson(Map<String, dynamic> json) => AirTechMemo(
  id: json['id'] as String,
  focus: json['focus'] as String,
  outcome: json['outcome'] as String,
  condition: $enumDecode(_$MemoConditionEnumMap, json['condition']),
  size: $enumDecode(_$MemoSizeEnumMap, json['size']),
  likeCount: (json['likeCount'] as num).toInt(),
  likedByMe: json['likedByMe'] as bool,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$AirTechMemoToJson(AirTechMemo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'focus': instance.focus,
      'outcome': instance.outcome,
      'condition': _$MemoConditionEnumMap[instance.condition]!,
      'size': _$MemoSizeEnumMap[instance.size]!,
      'likeCount': instance.likeCount,
      'likedByMe': instance.likedByMe,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'type': instance.$type,
    };

const _$MemoConditionEnumMap = {
  MemoCondition.none: 'none',
  MemoCondition.snow: 'snow',
  MemoCondition.brush: 'brush',
  MemoCondition.trampoline: 'trampoline',
};

const _$MemoSizeEnumMap = {
  MemoSize.none: 'none',
  MemoSize.small: 'small',
  MemoSize.middle: 'middle',
  MemoSize.big: 'big',
};

JibTechMemo _$JibTechMemoFromJson(Map<String, dynamic> json) => JibTechMemo(
  id: json['id'] as String,
  focus: json['focus'] as String,
  outcome: json['outcome'] as String,
  likeCount: (json['likeCount'] as num).toInt(),
  likedByMe: json['likedByMe'] as bool,
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  $type: json['type'] as String?,
);

Map<String, dynamic> _$JibTechMemoToJson(JibTechMemo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'focus': instance.focus,
      'outcome': instance.outcome,
      'likeCount': instance.likeCount,
      'likedByMe': instance.likedByMe,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'type': instance.$type,
    };
