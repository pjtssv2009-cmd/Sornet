class PlanFeature {
  final String title;
  final bool isIncluded;
  final String? limitText;

  PlanFeature({
    required this.title,
    this.isIncluded = true,
    this.limitText,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'isIncluded': isIncluded,
        'limitText': limitText,
      };

  factory PlanFeature.fromJson(Map<String, dynamic> json) => PlanFeature(
        title: json['title'] as String,
        isIncluded: json['isIncluded'] as bool? ?? true,
        limitText: json['limitText'] as String?,
      );
}

class SubscriptionPlan {
  final String id;
  final String name;
  final String tag;
  final int monthlyPrice;
  final int yearlyPrice;
  final String description;
  final bool isPopular;
  final List<PlanFeature> features;
  final int maxActiveJobs;
  final int maxTechnicianSearchesPerMonth;
  final bool unlimitedMessaging;
  final bool dedicatedAccountManager;

  SubscriptionPlan({
    required this.id,
    required this.name,
    required this.tag,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.description,
    this.isPopular = false,
    required this.features,
    required this.maxActiveJobs,
    required this.maxTechnicianSearchesPerMonth,
    this.unlimitedMessaging = false,
    this.dedicatedAccountManager = false,
  });
}
