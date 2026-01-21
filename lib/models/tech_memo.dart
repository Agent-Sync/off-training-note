import 'package:freezed_annotation/freezed_annotation.dart';

part 'tech_memo.freezed.dart';
part 'tech_memo.g.dart';

@freezed
class TechMemo with _$TechMemo {
  const factory TechMemo({
    required String id,
    required String focus,
    required String outcome,
    required DateTime createdAt,
    String? condition, // 'snow', 'brush'
    String? size, // 'small', 'middle', 'big'
  }) = _TechMemo;

  factory TechMemo.fromJson(Map<String, dynamic> json) =>
      _$TechMemoFromJson(json);
}
