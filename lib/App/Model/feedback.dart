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
  final List<dynamic> gallery; // New field to hold gallery images

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
    required this.gallery, // Include gallery in constructor
  });
  factory FeedbackMission.fromJson(Map<String, dynamic> json) {
    return FeedbackMission(
      id: json['id'] ?? 0, // Provide a default value if null
      label: json['label'] ?? '', // Default to an empty string if null
      desc: json['desc'] ?? '', // Default to an empty string if null
      requestDate: json['requestDate'], // Allow null
      lat: json['lat'], // Allow null
      lng: json['lng'], // Allow null
      creatorUsername:
          json['creatorUsername'] ?? '', // Default to an empty string
      creatorRoleId: json['creatorRoleId'], // Allow null
      editorUsername: json['editorUsername'], // Allow null
      editorRoleId: json['editorRoleId'], // Allow null
      creatorId: json['creatorId'] ?? 0, // Provide a default value if null
      editorId: json['editorId'], // Allow null
      clientId: json['clientId'] ?? 0, // Provide a default value if null
      missionId: json['missionId'] ?? 0, // Provide a default value if null
      feedbackModelId:
          json['feedbackModelId'] ?? 0, // Provide a default value if null
      decisionId: json['decisionId'], // Allow null
      createdAt: json['createdAt'], // Allow null
      updatedAt: json['updatedAt'], // Allow null
      clientFullName:
          json['client']?['fullName'] ?? '', // Use null-aware operator
      gallery: List<dynamic>.from(
          json['gallery'] ?? []), // Convert gallery JSON to List
    );
  }
}
