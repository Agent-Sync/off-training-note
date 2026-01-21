// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tech_memo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TechMemo _$TechMemoFromJson(Map<String, dynamic> json) => _TechMemo(
  id: json['id'] as String,
  focus: json['focus'] as String,
  outcome: json['outcome'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  condition: json['condition'] == null
      ? MemoCondition.none
      : const _MemoConditionConverter().fromJson(json['condition'] as String?),
  size: json['size'] == null
      ? MemoSize.none
      : const _MemoSizeConverter().fromJson(json['size'] as String?),
);

Map<String, dynamic> _$TechMemoToJson(_TechMemo instance) => <String, dynamic>{
  'id': instance.id,
  'focus': instance.focus,
  'outcome': instance.outcome,
  'createdAt': instance.createdAt.toIso8601String(),
  'condition': const _MemoConditionConverter().toJson(instance.condition),
  'size': const _MemoSizeConverter().toJson(instance.size),
};
