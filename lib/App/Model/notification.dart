class Notification {
  final int count;
  final List<NotificationRow> rows;

  Notification({required this.count, required this.rows});

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      count: json['count'] ?? 0, // Default to 0 if null
      rows: List<NotificationRow>.from(
        (json['rows'] ?? []).map((row) => NotificationRow.fromJson(row)),
      ),
    );
  }
}

class NotificationRow {
  final dynamic id; // Can be an int or List<int>
  final String title;
  final String entity;
  final int creatorId;
  final String createdAt;
  final String updatedAt;
  final Receiver? receiver; // Nullable because it might be null
  final Creator? creator; // Nullable because it might be null
  final NotificationData? data; // Nullable because it might be null

  NotificationRow({
    required this.id,
    required this.title,
    required this.entity,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    this.receiver,
    this.creator,
    this.data,
  });

  factory NotificationRow.fromJson(Map<String, dynamic> json) {
    dynamic parsedId;

    if (json['id'] is int) {
      parsedId = json['id']; // Single integer
    } else if (json['id'] is List) {
      // Check if it's a List of integers
      parsedId = (json['id'] as List)
          .whereType<int>()
          .toList(); // Ensure it's a List<int>
    } else {
      parsedId = 0; // Default value if id is null or invalid
    }

    return NotificationRow(
      id: json['id'],
      title: json['title'] ?? 'Untitled', // Default to 'Untitled' if null
      entity: json['entity'] ?? 'Unknown', // Default to 'Unknown' if null
      creatorId: json['creatorId'] ?? 0, // Default to 0 if null
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      receiver:
          json['receiver'] != null ? Receiver.fromJson(json['receiver']) : null,
      creator:
          json['creator'] != null ? Creator.fromJson(json['creator']) : null,
      data:
          json['data'] != null ? NotificationData.fromJson(json['data']) : null,
    );
  }
}

class Receiver {
  final int? status; // Nullable

  Receiver({this.status});

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(status: json['status']);
  }
}

class Creator {
  final String username;
  final bool isActive;
  final int roleId;
  final Person? person; // Nullable

  Creator({
    required this.username,
    required this.isActive,
    required this.roleId,
    this.person,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      username: json['username'] ?? '',
      isActive: json['isActive'] ?? false,
      roleId: json['roleId'] ?? 0,
      person: json['person'] != null ? Person.fromJson(json['person']) : null,
    );
  }
}

class Person {
  final String firstName;
  final String lastName;
  final String? img;

  Person({required this.firstName, required this.lastName, this.img});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      img: json['img'],
    );
  }
}

class NotificationData {
  final dynamic id;
  final int? companyId; // Nullable
  final int? annexId; // Nullable
  final int? statusId;
  NotificationData({
    required this.id,
    this.companyId,
    this.annexId,
    this.statusId,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    dynamic parsedId;

    if (json['id'] is int) {
      parsedId = json['id']; // Single integer
    } else if (json['id'] is List) {
      // Check if it's a List of integers
      parsedId = (json['id'] as List)
          .whereType<int>()
          .toList(); // Ensure it's a List<int>
    } else {
      parsedId = 0; // Default value if id is null or invalid
    }
    return NotificationData(
      id: parsedId,
      companyId: json['companyId'],
      annexId: json['annexId'],
      statusId: json['statusId'] ?? 0, // Default to 0 if null
    );
  }
}
