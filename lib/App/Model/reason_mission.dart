class ReasonMission {
  final int? id;
  final String? label;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReasonMission({
    required this.id,
    required this.label,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReasonMission.fromJson(Map<String, dynamic> json) {
    return ReasonMission(
      id: json['id'],
      label: json['label'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ReasonResponse {
  final List<ReasonMission> reasons;

  ReasonResponse({required this.reasons});

  factory ReasonResponse.fromJson(List<dynamic> json) {
    List<ReasonMission> reasons =
        json.map((item) => ReasonMission.fromJson(item)).toList();
    return ReasonResponse(reasons: reasons);
  }
}
