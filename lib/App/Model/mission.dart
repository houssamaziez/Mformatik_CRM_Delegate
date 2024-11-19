class ClientMission {
  int? id;
  int? localId;
  String? fullName;
  String? email;
  String? address;
  String? phone;
  String? tel;
  String? region;
  String? cashingIn;
  String? sold;
  String? potential;
  String? turnover;
  int? companyId;
  DateTime? createdAt;
  DateTime? updatedAt;

  ClientMission({
    this.id,
    this.localId,
    this.fullName,
    this.email,
    this.address,
    this.phone,
    this.tel,
    this.region,
    this.cashingIn,
    this.sold,
    this.potential,
    this.turnover,
    this.companyId,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a Client object from a JSON map
  factory ClientMission.fromJson(Map<String, dynamic> json) {
    return ClientMission(
      id: json['id'] ?? 0, // Default to 0 if null
      localId: json['localId'] ?? 0,
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      tel: json['tel'] ?? '',
      region: json['region'] ?? '',
      cashingIn: json['cashingIn'] ?? '', // Default to empty string if null
      sold: json['sold'] ?? '',
      potential: json['potential'] ?? '',
      turnover: json['turnover'] ?? '',
      companyId: json['companyId'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Method to convert a Client object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'localId': localId,
      'fullName': fullName,
      'email': email,
      'address': address,
      'phone': phone,
      'tel': tel,
      'region': region,
      'cashingIn': cashingIn,
      'sold': sold,
      'potential': potential,
      'turnover': turnover,
      'companyId': companyId,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class FeedbackMission {
  int id;
  String label;
  String? desc;
  DateTime? requestDate;
  String? lat;
  String? lng;
  String creatorUsername;
  int creatorRoleId;
  String? editorUsername;
  int? editorRoleId;
  int creatorId;
  int? editorId;
  int clientId;
  int missionId;
  int? feedbackModelId;
  int? decisionId;
  DateTime? createdAt;
  DateTime? updatedAt;

  FeedbackMission({
    required this.id,
    required this.label,
    this.desc,
    required this.requestDate,
    this.lat,
    this.lng,
    required this.creatorUsername,
    required this.creatorRoleId,
    this.editorUsername,
    this.editorRoleId,
    required this.creatorId,
    this.editorId,
    required this.clientId,
    required this.missionId,
    this.feedbackModelId,
    this.decisionId,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Feedback object from a JSON map
  factory FeedbackMission.fromJson(Map<String, dynamic> json) {
    return FeedbackMission(
      id: json['id'],
      label: json['label'] ?? '',
      desc: json['desc'],
      requestDate: json['requestDate'] != null
          ? DateTime.parse(json['requestDate'])
          : DateTime.now(),
      lat: json['lat'],
      lng: json['lng'],
      creatorUsername: json['creatorUsername'] ?? '',
      creatorRoleId: json['creatorRoleId'] ?? 0,
      editorUsername: json['editorUsername'],
      editorRoleId: json['editorRoleId'],
      creatorId: json['creatorId'] ?? 0,
      editorId: json['editorId'],
      clientId: json['clientId'] ?? 0,
      missionId: json['missionId'] ?? 0,
      feedbackModelId: json['feedbackModelId'],
      decisionId: json['decisionId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  // Method to convert a Feedback object back to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'desc': desc,
      'requestDate': requestDate!.toIso8601String(),
      'lat': lat,
      'lng': lng,
      'creatorUsername': creatorUsername,
      'creatorRoleId': creatorRoleId,
      'editorUsername': editorUsername,
      'editorRoleId': editorRoleId,
      'creatorId': creatorId,
      'editorId': editorId,
      'clientId': clientId,
      'missionId': missionId,
      'feedbackModelId': feedbackModelId,
      'decisionId': decisionId,
      'createdAt': createdAt!.toIso8601String(),
      'updatedAt': updatedAt!.toIso8601String(),
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
  ClientMission client;
  FeedbackMission feedback; // Added feedback property

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
    this.statusId,
    required this.createdAt,
    required this.updatedAt,
    required this.client,
    required this.feedback, // Include feedback in constructor
  });

  // Factory constructor to create a Mission object from a JSON map
  factory Mission.fromJson(Map<String, dynamic> json) {
    return Mission(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      desc: json['desc'],
      isSuccessful: json['isSuccessful'],
      creatorUsername: json['creatorUsername'] ?? '',
      creatorRoleId: json['creatorRoleId'] ?? 0,
      editorUsername: json['editorUsername'],
      editorRoleId: json['editorRoleId'],
      creatorId: json['creatorId'] ?? 0,
      editorId: json['editorId'],
      clientId: json['clientId'] ?? 0,
      responsibleId: json['responsibleId'] ?? 0,
      reasonId: json['reasonId'] ?? 0,
      statusId: json['statusId'],
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      client: json['client'] != null
          ? ClientMission.fromJson(json['client'])
          : ClientMission(), // Provide default empty Client if null
      feedback: json['feedback'] != null
          ? FeedbackMission.fromJson(json['feedback'])
          : FeedbackMission(
              id: 0,
              label: "",
              requestDate: null,
              creatorUsername: "",
              creatorRoleId: 0,
              creatorId: 0,
              clientId: 0,
              missionId: 0,
              createdAt: null,
              updatedAt: null), // Provide default empty Feedback if null
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
      'feedback': feedback.toJson(),
    };
  }
}

class MissionResponse {
  int count;
  List<Mission> rows;

  MissionResponse({required this.count, required this.rows});

  // Factory constructor to create a MissionResponse object from a JSON map
  factory MissionResponse.fromJson(Map<String, dynamic> json) {
    var list = json['rows'] as List? ?? []; // Handle null or missing rows
    List<Mission> missionList = list.map((i) => Mission.fromJson(i)).toList();

    return MissionResponse(
      count: json['count'] ?? 0,
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
