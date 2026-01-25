import 'package:freezed_annotation/freezed_annotation.dart';

part 'trick_meta.freezed.dart';
part 'trick_meta.g.dart';

@freezed
abstract class TrickMeta with _$TrickMeta {
  const factory TrickMeta({
    required String id,
    required String userId,
    @Default(true) bool isPublic,
    @Default('') String trickName,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TrickMeta;

  factory TrickMeta.fromJson(Map<String, dynamic> json) =>
      _$TrickMetaFromJson(json);
}
