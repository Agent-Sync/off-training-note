
class TechLog {
  final String id;
  final String focus;
  final String outcome;
  final DateTime createdAt;

  TechLog({
    required this.id,
    required this.focus,
    required this.outcome,
    required this.createdAt,
  });

  TechLog copyWith({
    String? id,
    String? focus,
    String? outcome,
    DateTime? createdAt,
  }) {
    return TechLog(
      id: id ?? this.id,
      focus: focus ?? this.focus,
      outcome: outcome ?? this.outcome,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'focus': focus,
      'outcome': outcome,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory TechLog.fromJson(Map<String, dynamic> map) {
    return TechLog(
      id: map['id'],
      focus: map['focus'],
      outcome: map['outcome'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
    );
  }
}
