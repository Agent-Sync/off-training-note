import 'package:off_training_note/models/trick.dart';
import 'package:off_training_note/utils/trick_helpers.dart';

class CommunityMemo {
  const CommunityMemo({
    required this.id,
    required this.trickId,
    required this.memoType,
    required this.focus,
    required this.outcome,
    required this.condition,
    required this.size,
    required this.createdAt,
    required this.updatedAt,
    required this.trickType,
    required this.customName,
    required this.stance,
    required this.takeoff,
    required this.axis,
    required this.spin,
    required this.grab,
    required this.direction,
    required this.trickCreatedAt,
    required this.userId,
    required this.displayName,
    required this.avatarUrl,
    required this.likeCount,
    required this.likedByMe,
  });

  final String id;
  final String trickId;
  final String memoType;
  final String focus;
  final String outcome;
  final String? condition;
  final String? size;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String trickType;
  final String? customName;
  final String? stance;
  final String? takeoff;
  final String? axis;
  final int? spin;
  final String? grab;
  final String? direction;
  final DateTime trickCreatedAt;
  final String userId;
  final String? displayName;
  final String? avatarUrl;
  final int likeCount;
  final bool likedByMe;

  String displayUserName() {
    if (displayName != null && displayName!.trim().isNotEmpty) {
      return displayName!;
    }
    return '名無し';
  }

  Trick toTrick() {
    if (trickType == 'jib') {
      return Trick.jib(
        id: trickId,
        customName: customName ?? '',
        memos: const [],
        createdAt: trickCreatedAt,
      );
    }

    return Trick.air(
      id: trickId,
      stance: _stanceFromDb(stance),
      takeoff: _takeoffFromDb(takeoff),
      axis: _axisFromDb(axis),
      spin: spin ?? 0,
      grab: _grabFromDb(grab),
      direction: _directionFromDb(direction),
      memos: const [],
      createdAt: trickCreatedAt,
    );
  }

  String trickName() => toTrick().displayName();

  CommunityMemo copyWith({
    int? likeCount,
    bool? likedByMe,
  }) {
    return CommunityMemo(
      id: id,
      trickId: trickId,
      memoType: memoType,
      focus: focus,
      outcome: outcome,
      condition: condition,
      size: size,
      createdAt: createdAt,
      updatedAt: updatedAt,
      trickType: trickType,
      customName: customName,
      stance: stance,
      takeoff: takeoff,
      axis: axis,
      spin: spin,
      grab: grab,
      direction: direction,
      trickCreatedAt: trickCreatedAt,
      userId: userId,
      displayName: displayName,
      avatarUrl: avatarUrl,
      likeCount: likeCount ?? this.likeCount,
      likedByMe: likedByMe ?? this.likedByMe,
    );
  }
}

Stance _stanceFromDb(String? value) {
  switch (value) {
    case 'switchStance':
      return Stance.switchStance;
    case 'regular':
    default:
      return Stance.regular;
  }
}

Takeoff _takeoffFromDb(String? value) {
  switch (value) {
    case 'carving':
      return Takeoff.carving;
    case 'standard':
    default:
      return Takeoff.standard;
  }
}

Direction _directionFromDb(String? value) {
  switch (value) {
    case 'left':
      return Direction.left;
    case 'right':
      return Direction.right;
    case 'none':
    default:
      return Direction.none;
  }
}

Axis _axisFromDb(String? value) {
  if (value == null) {
    return Axis.upright;
  }
  return Axis.fromDb(value);
}

Grab _grabFromDb(String? value) {
  if (value == null) {
    return Grab.none;
  }
  return Grab.fromDb(value);
}
