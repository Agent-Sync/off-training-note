
class TechLog {
  final String id;
  final String focus;
  final String outcome;
  final DateTime createdAt;
  final String? condition; // 'snow', 'brush'
  final String? size; // 'small', 'middle', 'big'

  TechLog({
    required this.id,
    required this.focus,
    required this.outcome,
    required this.createdAt,
    this.condition,
    this.size,
  });

  TechLog copyWith({
    String? id,
    String? focus,
    String? outcome,
    DateTime? createdAt,
    String? condition,
    String? size,
  }) {
    return TechLog(
      id: id ?? this.id,
      focus: focus ?? this.focus,
      outcome: outcome ?? this.outcome,
      createdAt: createdAt ?? this.createdAt,
      condition: condition ?? this.condition,
      size: size ?? this.size,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'focus': focus,
      'outcome': outcome,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'condition': condition,
      'size': size,
    };
  }

  factory TechLog.fromJson(Map<String, dynamic> map) {
    return TechLog(
      id: map['id'],
      focus: map['focus'],
      outcome: map['outcome'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      condition: map['condition'],
      size: map['size'],
    );
  }
}
