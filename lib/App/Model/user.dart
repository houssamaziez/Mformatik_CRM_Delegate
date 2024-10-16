class User {
  final int id;
  final String username;
  final bool isActive;
  final int roleId;
  final int? companyId;
  final int? annexId;
  final String createdAt;
  final String updatedAt;
  final Person? person;

  User({
    required this.id,
    required this.username,
    required this.isActive,
    required this.roleId,
    this.companyId,
    this.annexId,
    required this.createdAt,
    required this.updatedAt,
    required this.person,
  });

  // Factory method to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      isActive: json['isActive'],
      roleId: json['roleId'],
      companyId: json['companyId'],
      annexId: json['annexId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      person: json['person'] != null ? Person.fromJson(json['person']) : null,
    );
  }

  // Method to convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'isActive': isActive,
      'roleId': roleId,
      'companyId': companyId,
      'annexId': annexId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'person': person?.toJson(),
    };
  }

  // CopyWith method
  User copyWith({
    int? id,
    String? username,
    bool? isActive,
    int? roleId,
    int? companyId,
    int? annexId,
    String? createdAt,
    String? updatedAt,
    Person? person,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      isActive: isActive ?? this.isActive,
      roleId: roleId ?? this.roleId,
      companyId: companyId ?? this.companyId,
      annexId: annexId ?? this.annexId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      person: person ?? this.person,
    );
  }
}

class Person {
  final int id;
  final String firstName;
  final String lastName;
  final String? img;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final User? user;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.img,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  // Factory method to create a Person from JSON
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      img: json['img'],
      userId: json['userId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  // Method to convert Person to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'img': img,
      'userId': userId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // CopyWith method
  Person copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? img,
    int? userId,
    String? createdAt,
    String? updatedAt,
    User? user,
  }) {
    return Person(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      img: img ?? this.img,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      user: user ?? this.user,
    );
  }
}
