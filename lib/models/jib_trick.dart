import 'package:freezed_annotation/freezed_annotation.dart';

part 'jib_trick.freezed.dart';
part 'jib_trick.g.dart';

@freezed
abstract class JibTrick with _$JibTrick {
  const factory JibTrick({
    required String id,
    required String customName,
    required DateTime createdAt,
  }) = _JibTrick;

  factory JibTrick.fromJson(Map<String, dynamic> json) =>
      _$JibTrickFromJson(json);
}
