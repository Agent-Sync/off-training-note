import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:off_training_note/models/core/axis.dart';
import 'package:off_training_note/models/core/grab.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/core/direction.dart';
import 'package:off_training_note/models/core/stance.dart';
import 'package:off_training_note/models/core/spin.dart';
import 'package:off_training_note/models/core/trick_meta.dart';
import 'package:off_training_note/models/core/takeoff.dart';

export 'package:off_training_note/models/core/direction.dart';
export 'package:off_training_note/models/core/axis.dart';
export 'package:off_training_note/models/core/grab.dart';
export 'package:off_training_note/models/core/stance.dart';
export 'package:off_training_note/models/core/spin.dart';
export 'package:off_training_note/models/core/trick_meta.dart';
export 'package:off_training_note/models/core/takeoff.dart';

part 'trick.freezed.dart';
part 'trick.g.dart';


@Freezed(unionKey: 'type')
abstract class Trick with _$Trick {
  const factory Trick.air({
    required TrickMeta meta,
    required Stance stance,
    required Takeoff takeoff,
    required Axis axis,
    required Spin spin,
    required Grab grab,
    required Direction direction,
    required List<TechMemo> memos,
  }) = AirTrick;

  const factory Trick.jib({
    required TrickMeta meta,
    required String customName,
    required List<TechMemo> memos,
  }) = JibTrick;
  factory Trick.fromJson(Map<String, dynamic> json) =>
      _$TrickFromJson(json);
}

extension TrickMetaAccessors on Trick {
  TrickMeta get meta => map(air: (air) => air.meta, jib: (jib) => jib.meta);
  String get id => meta.id;
  String get userId => meta.userId;
  bool get isPublic => meta.isPublic;
  String get trickName => meta.trickName;
  DateTime get createdAt => meta.createdAt;
  DateTime get updatedAt => meta.updatedAt;
}

extension AirTrickMetaAccessors on AirTrick {
  String get id => meta.id;
  String get userId => meta.userId;
  bool get isPublic => meta.isPublic;
  String get trickName => meta.trickName;
  DateTime get createdAt => meta.createdAt;
  DateTime get updatedAt => meta.updatedAt;
}

extension JibTrickMetaAccessors on JibTrick {
  String get id => meta.id;
  String get userId => meta.userId;
  bool get isPublic => meta.isPublic;
  String get trickName => meta.trickName;
  DateTime get createdAt => meta.createdAt;
  DateTime get updatedAt => meta.updatedAt;
}
