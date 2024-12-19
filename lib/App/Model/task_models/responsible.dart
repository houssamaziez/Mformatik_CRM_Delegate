import 'task.dart';

class Responsible {
  final int id;
  final PersonRes? person;

  Responsible({required this.id, this.person});

  factory Responsible.fromJson(Map<String, dynamic> json) {
    return Responsible(
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
