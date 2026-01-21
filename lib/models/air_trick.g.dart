// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'air_trick.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Trick _$TrickFromJson(Map<String, dynamic> json) => _Trick(
  id: json['id'] as String,
  stance: $enumDecode(_$StanceEnumMap, json['stance']),
  takeoff: $enumDecode(_$TakeoffEnumMap, json['takeoff']),
  axis: json['axis'] as String,
  spin: (json['spin'] as num).toInt(),
  grab: json['grab'] as String,
  direction: $enumDecode(_$DirectionEnumMap, json['direction']),
  memos: (json['memos'] as List<dynamic>)
      .map((e) => TechMemo.fromJson(e as Map<String, dynamic>))
      .toList(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TrickToJson(_Trick instance) => <String, dynamic>{
  'id': instance.id,
  'stance': _$StanceEnumMap[instance.stance]!,
  'takeoff': _$TakeoffEnumMap[instance.takeoff]!,
  'axis': instance.axis,
  'spin': instance.spin,
  'grab': instance.grab,
  'direction': _$DirectionEnumMap[instance.direction]!,
  'memos': instance.memos,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$StanceEnumMap = {
  Stance.regular: 'regular',
  Stance.switchStance: 'switchStance',
};

const _$TakeoffEnumMap = {
  Takeoff.standard: 'standard',
  Takeoff.carving: 'carving',
};

const _$DirectionEnumMap = {
  Direction.none: 'none',
  Direction.left: 'left',
  Direction.right: 'right',
};
