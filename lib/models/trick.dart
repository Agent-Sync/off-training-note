import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:off_training_note/models/tech_memo.dart';
import 'package:off_training_note/models/core/direction.dart';
import 'package:off_training_note/models/core/stance.dart';
import 'package:off_training_note/models/core/takeoff.dart';

export 'package:off_training_note/models/core/direction.dart';
export 'package:off_training_note/models/core/stance.dart';
export 'package:off_training_note/models/core/takeoff.dart';

part 'trick.freezed.dart';
part 'trick.g.dart';


@Freezed(unionKey: 'type')
abstract class Trick with _$Trick {
  const factory Trick.air({
    required String id,
    required String userId,
    required Stance stance,
    required Takeoff takeoff,
    required String axisCode,
    required String axisLabel,
    required int spin,
    required String grabCode,
    required String grabLabel,
    required Direction direction,
    required List<TechMemo> memos,
    @Default(true) bool isPublic,
    @Default('') String trickName,
    required DateTime createdAt,
  }) = AirTrick;

  const factory Trick.jib({
    required String id,
    required String userId,
    required String customName,
    required List<TechMemo> memos,
    @Default(true) bool isPublic,
    @Default('') String trickName,
    required DateTime createdAt,
  }) = JibTrick;

  static List<int> get spinOptions => const [0, 180, 360, 540, 720, 900, 1080, 1260, 1440, 1620, 1800];

  factory Trick.fromJson(Map<String, dynamic> json) =>
      _$TrickFromJson(json);
}
