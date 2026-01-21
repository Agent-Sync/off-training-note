// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tech_memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TechMemo _$TechMemoFromJson(Map<String, dynamic> json) => _TechMemo(
  id: json['id'] as String,
  focus: json['focus'] as String,
  outcome: json['outcome'] as String,
  condition: $enumDecode(_$MemoConditionEnumMap, json['condition']),
  size: $enumDecode(_$MemoSizeEnumMap, json['size']),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TechMemoToJson(_TechMemo instance) => <String, dynamic>{
  'id': instance.id,
  'focus': instance.focus,
  'outcome': instance.outcome,
  'condition': _$MemoConditionEnumMap[instance.condition]!,
  'size': _$MemoSizeEnumMap[instance.size]!,
  'updatedAt': instance.updatedAt.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$MemoConditionEnumMap = {
  MemoCondition.none: 'none',
  MemoCondition.snow: 'snow',
  MemoCondition.brush: 'brush',
};

const _$MemoSizeEnumMap = {
  MemoSize.none: 'none',
  MemoSize.small: 'small',
  MemoSize.middle: 'middle',
  MemoSize.big: 'big',
};
