import 'task.dart';

class Owner {
  final int id;
  final PersonRes? person;

  Owner({required this.id, this.person});

  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'],
      person:
          json['person'] != null ? PersonRes.fromJson(json['person']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'person': person?.toJson(),
    };
  }
}
