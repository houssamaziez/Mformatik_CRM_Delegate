class Task {
  final int id;
  final String label;
  final String ownerUsername;
  final int ownerRoleId;
  final int ownerId;
  final String responsibleUsername;
  final int responsibleRoleId;
  final int responsibleId;
  final String observerUsername;
  final int observerRoleId;
  final int observerId;
  final int statusId;
  final int lastStatusId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Task({
    required this.id,
    required this.label,
    required this.ownerUsername,
    required this.ownerRoleId,
    required this.ownerId,
    required this.responsibleUsername,
    required this.responsibleRoleId,
    required this.responsibleId,
    required this.observerUsername,
    required this.observerRoleId,
    required this.observerId,
    required this.statusId,
    required this.lastStatusId,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Factory constructor to create a `Task` instance from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      label: json['label'],
      ownerUsername: json['ownerUsername'],
      ownerRoleId: json['ownerRoleId'],
      ownerId: json['ownerId'],
      responsibleUsername: json['responsibleUsername'],
      responsibleRoleId: json['responsibleRoleId'],
      responsibleId: json['responsibleId'],
      observerUsername: json['observerUsername'],
      observerRoleId: json['observerRoleId'],
      observerId: json['observerId'],
      statusId: json['statusId'],
      lastStatusId: json['lastStatusId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  /// Method to convert a `Task` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'ownerUsername': ownerUsername,
      'ownerRoleId': ownerRoleId,
      'ownerId': ownerId,
      'responsibleUsername': responsibleUsername,
      'responsibleRoleId': responsibleRoleId,
      'responsibleId': responsibleId,
      'observerUsername': observerUsername,
      'observerRoleId': observerRoleId,
      'observerId': observerId,
      'statusId': statusId,
      'lastStatusId': lastStatusId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

class TaskResponse {
  final int count;
  final List<Task> rows;

  TaskResponse({
    required this.count,
    required this.rows,
  });

  /// Factory constructor to create a `TaskResponse` instance from JSON
  factory TaskResponse.fromJson(Map<String, dynamic> json) {
    return TaskResponse(
      count: json['count'],
      rows: List<Task>.from(json['rows'].map((task) => Task.fromJson(task))),
    );
  }

  /// Method to convert a `TaskResponse` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'rows': rows.map((task) => task.toJson()).toList(),
    };
  }
}
