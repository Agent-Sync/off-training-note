import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:off_training_note/models/tech_memo.dart';

part 'trick.freezed.dart';
part 'trick.g.dart';

enum TrickType { air, jib }
enum Stance { regular, switchStance } // 'switch' is a keyword in Dart
enum Takeoff { standard, carving }
enum Direction { left, right }

@freezed
class Trick with _$Trick {
  const factory Trick({
    required String id,
    required TrickType type,
    required Stance stance,
    required Takeoff takeoff,
    required String axis,
    required int spin,
    required String grab,
    Direction? direction,
    required List<TechMemo> memos,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Trick;

  factory Trick.fromJson(Map<String, dynamic> json) =>
      _$TrickFromJson(json);
}
