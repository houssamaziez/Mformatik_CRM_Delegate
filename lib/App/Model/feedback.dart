// feedback.dart
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
  final String? clientFullName;

  FeedbackMission({
    required this.id,
    required this.label,
    required this.desc,
    this.requestDate,
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
    required this.feedbackModelId,
    this.decisionId,
    required this.createdAt,
    required this.updatedAt,
    required this.clientFullName,
  });

  factory FeedbackMission.fromJson(Map<String, dynamic> json) {
    return FeedbackMission(
      id: json['id'],
      label: json['label'],
      desc: json['desc'],
      requestDate: json['requestDate'],
      lat: json['lat'],
      lng: json['lng'],
      creatorUsername: json['creatorUsername'],
      creatorRoleId: json['creatorRoleId'],
      editorUsername: json['editorUsername'],
      editorRoleId: json['editorRoleId'],
      creatorId: json['creatorId'],
      editorId: json['editorId'],
      clientId: json['clientId'],
      missionId: json['missionId'],
      feedbackModelId: json['feedbackModelId'],
      decisionId: json['decisionId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      clientFullName: json['client']['fullName'],
    );
  }
}
