class Client {
  String? fullName;

  Client({this.fullName});

  // Factory constructor to create a Client object from a JSON map
  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      fullName: json['fullName'],
    );
  }

  // Method to convert a Client object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
    };
  }
}

class Mission {
  int id;
  String label;
  String? desc;
  bool? isSuccessful;
  String creatorUsername;
  int creatorRoleId;
  String? editorUsername;
  int? editorRoleId;
  int creatorId;
  int? editorId;
  int clientId;
  int responsibleId;
  int reasonId;
  int? statusId;
  DateTime createdAt;
  DateTime updatedAt;
  Client client;

  Mission({
    required this.id,
    required this.label,
    this.desc,
    this.isSuccessful,
    required this.creatorUsername,
    required this.creatorRoleId,
    this.editorUsername,
    this.editorRoleId,
    required this.creatorId,
    this.editorId,
    required this.clientId,
    required this.responsibleId,
    required this.reasonId,
    required this.statusId,
    required this.createdAt,
    required this.updatedAt,
    required this.client,
  });

  // Factory constructor to create a Mission object from a JSON map
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'],
      label: json['label'],
      desc: json['desc'],
      isSuccessful: json['isSuccessful'],
      creatorUsername: json['creatorUsername'],
      creatorRoleId: json['creatorRoleId'],
      editorUsername: json['editorUsername'],
      editorRoleId: json['editorRoleId'],
      creatorId: json['creatorId'],
      editorId: json['editorId'],
      clientId: json['clientId'],
      responsibleId: json['responsibleId'],
      reasonId: json['reasonId'],
      statusId: json['statusId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      client: Client.fromJson(json['client']),
    );
  }

  // Method to convert a Mission object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'desc': desc,
      'isSuccessful': isSuccessful,
      'creatorUsername': creatorUsername,
      'creatorRoleId': creatorRoleId,
      'editorUsername': editorUsername,
      'editorRoleId': editorRoleId,
      'creatorId': creatorId,
      'editorId': editorId,
      'clientId': clientId,
      'responsibleId': responsibleId,
      'reasonId': reasonId,
      'statusId': statusId,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'client': client.toJson(),
    };
  }
}

class MissionResponse {
  int count;
  List<Mission> rows;

  MissionResponse({required this.count, required this.rows});

  // Factory constructor to create a MissionResponse object from a JSON map
  factory MissionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['rows'] as List;
    List<Mission> missionList = list.map((i) => Mission.fromJson(i)).toList();

    return MissionResponse(
      count: json['count'],
      rows: missionList,
    );
  }

  // Method to convert a MissionResponse object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'rows': rows.map((mission) => mission.toJson()).toList(),
    };
  }
}
