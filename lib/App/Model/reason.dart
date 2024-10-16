class Reason {
  final int? id;
  final String? label;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reason({
    required this.id,
    required this.label,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reason.fromJson(Map<String, dynamic> json) {
    return Reason(
      id: json['id'],
      label: json['label'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class ReasonResponse {
  final List<Reason> reasons;

  ReasonResponse({required this.reasons});

  factory ReasonResponse.fromJson(List<dynamic> json) {
    List<Reason> reasons = json.map((item) => Reason.fromJson(item)).toList();
    return ReasonResponse(reasons: reasons);
  }
}
