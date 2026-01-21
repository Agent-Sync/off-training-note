import 'package:freezed_annotation/freezed_annotation.dart';

part 'tech_memo.freezed.dart';
part 'tech_memo.g.dart';

enum MemoCondition { none, snow, brush }

enum MemoSize { none, small, middle, big }

@freezed
abstract class TechMemo with _$TechMemo {
  const factory TechMemo({
    required String id,
    required String focus,
    required String outcome,
    required MemoCondition condition,
    required MemoSize size,
    required DateTime updatedAt,
    required DateTime createdAt,
  }) = _TechMemo;

  factory TechMemo.fromJson(Map<String, dynamic> json) =>
      _$TechMemoFromJson(json);
}
