enum PromotionStatus {
  active,
  scheduled,
  expired,
  draft;

  String get label {
    switch (this) {
      case PromotionStatus.active:
        return 'Active';
      case PromotionStatus.scheduled:
        return 'Scheduled';
      case PromotionStatus.expired:
        return 'Expired';
      case PromotionStatus.draft:
        return 'Draft';
    }
  }
}

class Promotion {
  final String id;
  final String title;
  final String bannerImageUrl;
  final String description;
  final String redirectLink;
  final DateTime startDate;
  final DateTime endDate;
  final PromotionStatus status;
  final int clickCount;
  final int impressionCount;

  Promotion({
    required this.id,
    required this.title,
    required this.bannerImageUrl,
    required this.description,
    required this.redirectLink,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.clickCount = 0,
    this.impressionCount = 0,
  });

  Promotion copyWith({
    String? id,
    String? title,
    String? bannerImageUrl,
    String? description,
    String? redirectLink,
    DateTime? startDate,
    DateTime? endDate,
    PromotionStatus? status,
    int? clickCount,
    int? impressionCount,
  }) {
    return Promotion(
      id: id ?? this.id,
      title: title ?? this.title,
      bannerImageUrl: bannerImageUrl ?? this.bannerImageUrl,
      description: description ?? this.description,
      redirectLink: redirectLink ?? this.redirectLink,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      clickCount: clickCount ?? this.clickCount,
      impressionCount: impressionCount ?? this.impressionCount,
    );
  }
}
