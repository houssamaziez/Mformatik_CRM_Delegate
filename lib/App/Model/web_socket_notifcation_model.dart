@pragma('vm:entry-point')
class WebSocketNotificationModel {
  String? entity;
  String? title;
  WebSocketNotificationData? data;
  int? id;
  Creator? creator;

  WebSocketNotificationModel({
    this.entity,
    this.title,
    this.data,
    this.id,
    this.creator,
  });

  factory WebSocketNotificationModel.fromJson(Map<String, dynamic> json) => WebSocketNotificationModel(
        entity: json["entity"] as String?,
        title: json["title"] as String?,
        data: json["data"] != null ? WebSocketNotificationData.fromJson(json["data"]) : null,
        id: json["id"] as int?,
        creator: json["creator"] != null ? Creator.fromJson(json["creator"]) : null,
      );
}

class Creator {
  int? id;
  String? username;
  bool? isActive;
  int? roleId;
  dynamic annexId;
  dynamic companyId;
  Person? person;
  int? iat;

  Creator({
    this.id,
    this.username,
    this.isActive,
    this.roleId,
    this.annexId,
    this.companyId,
    this.person,
    this.iat,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        id: json["id"] as int?,
        username: json["username"] as String?,
        isActive: json["isActive"] as bool?,
        roleId: json["roleId"] as int?,
        annexId: json["annexId"],
        companyId: json["companyId"],
        person: json["person"] != null ? Person.fromJson(json["person"]) : null,
        iat: json["iat"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "isActive": isActive,
        "roleId": roleId,
        "annexId": annexId,
        "companyId": companyId,
        "person": person?.toJson(),
        "iat": iat,
      };
}

class Person {
  int? id;
  String? firstName;
  String? lastName;
  dynamic email;
  dynamic phone;
  dynamic phone02;
  dynamic address;
  dynamic gender;
  dynamic img;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;

  Person({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.phone02,
    this.address,
    this.gender,
    this.img,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        id: json["id"] as int?,
        firstName: json["firstName"] as String?,
        lastName: json["lastName"] as String?,
        email: json["email"],
        phone: json["phone"],
        phone02: json["phone02"],
        address: json["address"],
        gender: json["gender"],
        img: json["img"],
        userId: json["userId"] as int?,
        createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
        updatedAt: json["updatedAt"] != null ? DateTime.parse(json["updatedAt"]) : null,
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class WebSocketNotificationData {
  List<dynamic>? ids;
  int? companyId;
  int? annexId;

  WebSocketNotificationData({
    this.ids,
    this.companyId,
    this.annexId,
  });

  factory WebSocketNotificationData.fromJson(Map<String, dynamic> json) => WebSocketNotificationData(
        ids: json["id"] is int ? [json["id"]] : (json["id"] as List<dynamic>?),
        companyId: json["companyId"] as int?,
        annexId: json["annexId"] as int?,
      );
}
