import 'task.dart';

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
