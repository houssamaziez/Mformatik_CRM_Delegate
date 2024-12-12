class History {
  final int id;
  final int statusId;
  final DateTime createdAt;

  History({
    required this.id,
    required this.statusId,
    required this.createdAt,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      statusId: json['statusId'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'statusId': statusId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
