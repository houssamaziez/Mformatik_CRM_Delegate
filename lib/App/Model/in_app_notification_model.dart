// To parse this JSON data, do
//
//     final inAppNotificationModel = inAppNotificationModelFromJson(jsonString);

import 'dart:convert';

InAppNotificationModel inAppNotificationModelFromJson(String str) => InAppNotificationModel.fromJson(json.decode(str));

class InAppNotificationModel {
  Data data;
  int id;
  String title;
  String entity;
  int creatorId;
  DateTime createdAt;
  DateTime updatedAt;
  Receiver receiver;
  Creator creator;

  InAppNotificationModel({
    required this.data,
    required this.id,
    required this.title,
    required this.entity,
    required this.creatorId,
    required this.createdAt,
    required this.updatedAt,
    required this.receiver,
    required this.creator,
  });

  factory InAppNotificationModel.fromJson(Map<String, dynamic> json) => InAppNotificationModel(
        data: Data.fromJson(json["data"]),
        id: json["id"],
        title: json["title"],
        entity: json["entity"],
        creatorId: json["creatorId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        receiver: Receiver.fromJson(json["receiver"]),
        creator: Creator.fromJson(json["creator"]),
      );
}

class Creator {
  String username;
  bool isActive;
  int roleId;
  Person person;

  Creator({
    required this.username,
    required this.isActive,
    required this.roleId,
    required this.person,
  });

  factory Creator.fromJson(Map<String, dynamic> json) => Creator(
        username: json["username"],
        isActive: json["isActive"],
        roleId: json["roleId"],
        person: Person.fromJson(json["person"]),
      );
}

class Person {
  String firstName;
  String lastName;
  String? imgPath;

  Person({
    required this.firstName,
    required this.lastName,
    this.imgPath,
  });

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        firstName: json["firstName"],
        lastName: json["lastName"],
        imgPath: json["img"],
      );
}

class Data {
  List<dynamic> ids;

  Data({
    required this.ids,
  });
  //TODO: fix issue here
  factory Data.fromJson(Map<String, dynamic> json) => Data(
        ids: (json["id"] is int ? [json["id"]] : (json["id"])),
      );
}

class Receiver {
  dynamic status;

  Receiver({
    required this.status,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) => Receiver(
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
      };
}
