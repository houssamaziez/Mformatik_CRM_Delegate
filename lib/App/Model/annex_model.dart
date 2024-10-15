class AnnexModel {
  final int id;
  final String label;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel user;

  AnnexModel({
    required this.id,
    required this.label,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  factory AnnexModel.fromJson(Map<String, dynamic> json) {
    return AnnexModel(
      id: json['id'],
      label: json['label'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      user: UserModel.fromJson(json['user']),
    );
  }
}

class UserModel {
  final int id;
  final String username;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserModel({
    required this.id,
    required this.username,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      isActive: json['isActive'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
