class Item {
  final int id;
  final String desc;
  final String creatorUsername;
  final int creatorRoleId;
  final int creatorId;
  final int taskId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<dynamic> attachments;

  Item({
    required this.id,
    required this.desc,
    required this.creatorUsername,
    required this.creatorRoleId,
    required this.creatorId,
    required this.taskId,
    required this.createdAt,
    required this.updatedAt,
    this.attachments = const [],
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      desc: json['desc'],
      creatorUsername: json['creatorUsername'],
      creatorRoleId: json['creatorRoleId'],
      creatorId: json['creatorId'],
      taskId: json['taskId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      attachments: json['attachments'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'desc': desc,
      'creatorUsername': creatorUsername,
      'creatorRoleId': creatorRoleId,
      'creatorId': creatorId,
      'taskId': taskId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'attachments': attachments,
    };
  }
}
