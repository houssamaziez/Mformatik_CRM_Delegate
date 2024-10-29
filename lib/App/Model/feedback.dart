class Clientfeedback {
  final int id;
  final int? localId;
  final String? fullName;
  final String? email;
  final String? address;
  final String? phone;
  final String? tel;
  final String? region;
  final String? cashingIn;
  final String? sold;
  final String? potential;
  final String? turnover;
  final int? companyId;
  final String? createdAt;
  final String? updatedAt;

  Clientfeedback({
    required this.id,
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

  factory Clientfeedback.fromJson(Map<String, dynamic> json) {
    return Clientfeedback(
      id: json['id'] ?? 0,
      localId: json['localId'],
      fullName: json['fullName'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      tel: json['tel'],
      region: json['region'],
      cashingIn: json['cashingIn'],
      sold: json['sold'],
      potential: json['potential'],
      turnover: json['turnover'],
      companyId: json['companyId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class FeedbackMission {
  final int id;
  final String? label;
  final String? desc;
  final String? requestDate;
  final String? lat;
  final String? lng;
  final String? creatorUsername;
  final int? creatorRoleId;
  final String? editorUsername;
  final int? editorRoleId;
  final int? creatorId;
  final int? editorId;
  final int? clientId;
  final int? missionId;
  final int? feedbackModelId;
  final int? decisionId;
  final String? createdAt;
  final String? updatedAt;
  final Clientfeedback? client;
  final List<dynamic> gallery;

  FeedbackMission({
    required this.id,
    this.label,
    this.desc,
    this.requestDate,
    this.lat,
    this.lng,
    this.creatorUsername,
    this.creatorRoleId,
    this.editorUsername,
    this.editorRoleId,
    this.creatorId,
    this.editorId,
    this.clientId,
    this.missionId,
    this.feedbackModelId,
    this.decisionId,
    this.createdAt,
    this.updatedAt,
    this.client,
    required this.gallery,
  });

  factory FeedbackMission.fromJson(Map<String, dynamic> json) {
    return FeedbackMission(
      id: json['id'] ?? 0,
      label: json['label'] ?? '',
      desc: json['desc'] ?? '',
      requestDate: json['requestDate'],
      lat: json['lat'],
      lng: json['lng'],
      creatorUsername: json['creatorUsername'] ?? '',
      creatorRoleId: json['creatorRoleId'],
      editorUsername: json['editorUsername'],
      editorRoleId: json['editorRoleId'],
      creatorId: json['creatorId'] ?? 0,
      editorId: json['editorId'],
      clientId: json['clientId'] ?? 0,
      missionId: json['missionId'],
      feedbackModelId: json['feedbackModelId'] ?? 0,
      decisionId: json['decisionId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      client: json['client'] != null
          ? Clientfeedback.fromJson(json['client'])
          : null,
      gallery: List<dynamic>.from(json['gallery'] ?? []),
    );
  }
}
