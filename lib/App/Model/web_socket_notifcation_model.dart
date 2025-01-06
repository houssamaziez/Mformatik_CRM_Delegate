@pragma('vm:entry-point')
class WebSocketNotificationModel {
  String entity;
  String title;
  WebSocketNotificationData data;

  int id;
  Creator creator;

  WebSocketNotificationModel({
    required this.entity,
    required this.title,
    required this.data,
    required this.id,
    required this.creator,
  });

  factory WebSocketNotificationModel.fromJson(Map<String, dynamic> json) => WebSocketNotificationModel(
        entity: json["entity"],
        title: json["title"],
        data: WebSocketNotificationData.fromJson(json["data"]),
        id: json["id"],
        creator: Creator.fromJson(json["creator"]),
      );
}

class Creator {
  int id;
  String username;
  bool isActive;
  int roleId;
  dynamic annexId;
  dynamic companyId;
  Person person;
  int iat;

  Creator({
    required this.id,
    required this.username,
    required this.isActive,
    required this.roleId,
    required this.annexId,
    required this.companyId,
    required this.person,
    required this.iat,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["id"],
        username: json["username"],
        isActive: json["isActive"],
        roleId: json["roleId"],
        annexId: json["annexId"],
        companyId: json["companyId"],
        person: Person.fromJson(json["person"]),
        iat: json["iat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "isActive": isActive,
        "roleId": roleId,
        "annexId": annexId,
        "companyId": companyId,
        "person": person.toJson(),
        "iat": iat,
      };
}

class Person {
  int id;
  String firstName;
  String lastName;
  dynamic email;
  dynamic phone;
  dynamic phone02;
  dynamic address;
  dynamic gender;
  dynamic img;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;

  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.phone02,
    required this.address,
    required this.gender,
    required this.img,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["id"],
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        phone: json["phone"],
        phone02: json["phone02"],
        address: json["address"],
        gender: json["gender"],
        img: json["img"],
        userId: json["userId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "phone02": phone02,
        "address": address,
        "gender": gender,
        "img": img,
        "userId": userId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}

class WebSocketNotificationData {
  List<dynamic> ids;
  int companyId;
  int annexId;
  WebSocketNotificationData({
    required this.ids,
    required this.companyId,
    required this.annexId,
  });

  factory WebSocketNotificationData.fromJson(Map<String, dynamic> json) => WebSocketNotificationData(
        ids: (json["id"] is int ? [json["id"]] : (json["id"])),
        companyId: json["companyId"],
        annexId: json["annexId"],
      );
}
