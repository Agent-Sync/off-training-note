import 'package:freezed_annotation/freezed_annotation.dart';

part 'tech_memo.freezed.dart';
part 'tech_memo.g.dart';

enum MemoCondition { none, snow, brush }
enum MemoSize { none, small, middle, big }

class _MemoConditionConverter implements JsonConverter<MemoCondition, String?> {
  const _MemoConditionConverter();

  @override
  MemoCondition fromJson(String? json) {
    switch (json) {
      case 'snow':
        return MemoCondition.snow;
      case 'brush':
        return MemoCondition.brush;
      case 'none':
      case null:
        return MemoCondition.none;
      default:
        return MemoCondition.none;
    }
  }

  @override
  String toJson(MemoCondition object) => object.name;
}

class _MemoSizeConverter implements JsonConverter<MemoSize, String?> {
  const _MemoSizeConverter();

  @override
  MemoSize fromJson(String? json) {
    switch (json) {
      case 'small':
        return MemoSize.small;
      case 'middle':
        return MemoSize.middle;
      case 'big':
        return MemoSize.big;
      case 'none':
      case null:
        return MemoSize.none;
      default:
        return MemoSize.none;
    }
  }

  @override
  String toJson(MemoSize object) => object.name;
}

@freezed
class TechMemo with _$TechMemo {
  const factory TechMemo({
    required String id,
    required String focus,
    required String outcome,
    required DateTime createdAt,
    @_MemoConditionConverter() @Default(MemoCondition.none) MemoCondition condition,
    @_MemoSizeConverter() @Default(MemoSize.none) MemoSize size,
  }) = _TechMemo;

  factory TechMemo.fromJson(Map<String, dynamic> json) =>
      _$TechMemoFromJson(json);
}
