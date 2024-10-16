// company_model.dart
class Company {
  final int id;
  final String label;
  final int annexId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company({
    required this.id,
    required this.label,
    required this.annexId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['id'],
      label: json['label'],
      annexId: json['annexId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'annexId': annexId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
