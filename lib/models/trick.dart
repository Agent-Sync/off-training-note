import 'package:off_training_note/models/tech_memo.dart';

enum TrickType { air, jib }
enum Stance { regular, switchStance } // 'switch' is a keyword in Dart
enum Takeoff { standard, carving }
enum Direction { left, right }

class Trick {
  final String id;
  final TrickType type;
  final Stance stance;
  final Takeoff? takeoff;
  final String? axis;
  final int spin;
  final String grab;
  final Direction? direction;
  final List<TechMemo> memos;
  final DateTime updatedAt;

  Trick({
    required this.id,
    required this.type,
    required this.stance,
    this.takeoff,
    this.axis,
    required this.spin,
    required this.grab,
    this.direction,
    required this.memos,
    required this.updatedAt,
  });

  Trick copyWith({
    String? id,
    TrickType? type,
    Stance? stance,
    Takeoff? takeoff,
    String? axis,
    int? spin,
    String? grab,
    Direction? direction,
    List<TechMemo>? memos,
    DateTime? updatedAt,
  }) {
    return Trick(
      id: id ?? this.id,
      type: type ?? this.type,
      stance: stance ?? this.stance,
      takeoff: takeoff ?? this.takeoff,
      axis: axis ?? this.axis,
      spin: spin ?? this.spin,
      grab: grab ?? this.grab,
      direction: direction ?? this.direction,
      memos: memos ?? this.memos,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'stance': stance.name,
      'takeoff': takeoff?.name,
      'axis': axis,
      'spin': spin,
      'grab': grab,
      'direction': direction?.name,
      'memos': memos.map((x) => x.toJson()).toList(),
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory Trick.fromJson(Map<String, dynamic> map) {
    return Trick(
      id: map['id'],
      type: TrickType.values.firstWhere((e) => e.name == map['type']),
      stance: Stance.values.firstWhere((e) => e.name == map['stance']),
      takeoff: map['takeoff'] != null
          ? Takeoff.values.firstWhere((e) => e.name == map['takeoff'])
          : null,
      axis: map['axis'],
      spin: map['spin'],
      grab: map['grab'],
      direction: map['direction'] != null
          ? Direction.values.firstWhere((e) => e.name == map['direction'])
          : null,
      memos: List<TechMemo>.from(
        (map['memos'] ?? map['logs'])?.map((x) => TechMemo.fromJson(x)) ?? [],
      ),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}
