import 'task.dart';

class Observer {
  final int id;
  final PersonRes? person;

  Observer({required this.id, this.person});

  factory Observer.fromJson(Map<String, dynamic> json) {
    return Observer(
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
