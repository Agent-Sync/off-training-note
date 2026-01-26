import 'package:freezed_annotation/freezed_annotation.dart';

part 'tech_memo.freezed.dart';
part 'tech_memo.g.dart';

enum MemoCondition { none, snow, brush, trampoline }

enum MemoSize { none, small, middle, big }

@Freezed(unionKey: 'type')
abstract class TechMemo with _$TechMemo {
  const factory TechMemo.air({
    required String id,
    required String focus,
    required String outcome,
    required MemoCondition condition,
    required MemoSize size,
    required int likeCount,
    required bool likedByMe,
    required DateTime updatedAt,
    required DateTime createdAt,
  }) = AirTechMemo;

  const factory TechMemo.jib({
    required String id,
    required String focus,
    required String outcome,
    required int likeCount,
    required bool likedByMe,
    required DateTime updatedAt,
    required DateTime createdAt,
  }) = JibTechMemo;

  factory TechMemo.fromJson(Map<String, dynamic> json) =>
      _$TechMemoFromJson(json);
}
