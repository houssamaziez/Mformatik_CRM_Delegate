class FeedbackReason {
  final int? id;
  final String? label;
  final bool isDescRequired;
  final bool isRequestDateRequired;
  final DateTime createdAt;
  final DateTime updatedAt;

  FeedbackReason({
    required this.id,
    required this.label,
    required this.isDescRequired,
    required this.isRequestDateRequired,
    required this.createdAt,
    required this.updatedAt,
  });

  factory FeedbackReason.fromJson(Map<String, dynamic> json) {
    return FeedbackReason(
      id: json['id'],
      label: json['label'],
      isDescRequired: json['isDescRequired'],
      isRequestDateRequired: json['isRequestDateRequired'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class FeedbackResponse {
  final List<FeedbackReason> reasons;

  FeedbackResponse({required this.reasons});

  factory FeedbackResponse.fromJson(List<dynamic> json) {
    List<FeedbackReason> reasons =
        json.map((item) => FeedbackReason.fromJson(item)).toList();
    return FeedbackResponse(reasons: reasons);
  }
}
