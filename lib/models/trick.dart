import 'package:off_training_note/models/tech_log.dart';

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
  final String? customName;
  final List<TechLog> logs;
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
    this.customName,
    required this.logs,
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
    String? customName,
    List<TechLog>? logs,
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
      customName: customName ?? this.customName,
      logs: logs ?? this.logs,
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
      'customName': customName,
      'logs': logs.map((x) => x.toJson()).toList(),
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
      customName: map['customName'],
      logs: List<TechLog>.from(map['logs']?.map((x) => TechLog.fromJson(x)) ?? []),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt']),
    );
  }
}
