import 'history.dart';
import 'item_task.dart';
import 'obsever.dart';
import 'owner.dart';
import 'responsible.dart';

class Task {
  final int id;
  final String label;
  final bool isStart;
  final DateTime? deadline;
  final String ownerUsername;
  final int ownerRoleId;
  final int ownerId;
  final String responsibleUsername;
  final int responsibleRoleId;
  final int responsibleId;
  final String? observerUsername;
  final int? observerRoleId;
  final int? observerId;
  final int statusId;
  final int lastStatusId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Owner? owner;
  final Responsible? responsible;
  final Observer? observer;
  final List<Item> items;
  final List<History> histories;

  Task({
    required this.id,
    required this.label,
    required this.isStart,
    this.deadline,
    required this.ownerUsername,
    required this.ownerRoleId,
    required this.ownerId,
    required this.responsibleUsername,
    required this.responsibleRoleId,
    required this.responsibleId,
    this.observerUsername = "",
    this.observerRoleId = 0,
    this.observerId = 0,
    required this.statusId,
    required this.lastStatusId,
    required this.createdAt,
    required this.updatedAt,
    this.owner,
    this.responsible,
    this.observer,
    this.items = const [],
    this.histories = const [],
  });

  /// Factory constructor to create a `Task` instance from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      label: json['label'],
      isStart: json['isStart'],
      deadline:
          json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
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
      owner: json['owner'] != null ? Owner.fromJson(json['owner']) : null,
      responsible: json['responsible'] != null
          ? Responsible.fromJson(json['responsible'])
          : null,
      observer:
          json['observer'] != null ? Observer.fromJson(json['observer']) : null,
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => Item.fromJson(item))
              .toList() ??
          [],
      histories: (json['histories'] as List<dynamic>?)
              ?.map((history) => History.fromJson(history))
              .toList() ??
          [],
    );
  }

  /// Method to convert a `Task` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'isStart': isStart,
      'deadline': deadline?.toIso8601String(),
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
      'owner': owner?.toJson(),
      'responsible': responsible?.toJson(),
      'observer': observer?.toJson(),
      'items': items.map((item) => item.toJson()).toList(),
      'histories': histories.map((history) => history.toJson()).toList(),
    };
  }
}

class Person {
  final String firstName;
  final String lastName;
  final String? img;

  Person({required this.firstName, required this.lastName, this.img});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      firstName: json['firstName'],
      lastName: json['lastName'],
      img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'img': img,
    };
  }
}
