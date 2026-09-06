class TechnicianReview {
  final String id;
  final String technicianId;
  final String technicianName;
  final String businessId;
  final String businessName;
  final String? businessLogo;
  final String hiringId;
  final String jobTitle;
  final double technicalSkillRating;
  final double professionalismRating;
  final double communicationRating;
  final double punctualityRating;
  final double qualityOfWorkRating;
  final double overallRating;
  final String reviewText;
  final DateTime createdAt;

  TechnicianReview({
    required this.id,
    required this.technicianId,
    required this.technicianName,
    required this.businessId,
    required this.businessName,
    this.businessLogo,
    required this.hiringId,
    required this.jobTitle,
    required this.technicalSkillRating,
    required this.professionalismRating,
    required this.communicationRating,
    required this.punctualityRating,
    required this.qualityOfWorkRating,
    required this.overallRating,
    required this.reviewText,
    required this.createdAt,
  });

  static double calculateOverall(
    double technical,
    double professionalism,
    double communication,
    double punctuality,
    double quality,
  ) {
    return ((technical + professionalism + communication + punctuality + quality) / 5.0);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'technicianId': technicianId,
        'technicianName': technicianName,
        'businessId': businessId,
        'businessName': businessName,
        'businessLogo': businessLogo,
        'hiringId': hiringId,
        'jobTitle': jobTitle,
        'technicalSkillRating': technicalSkillRating,
        'professionalismRating': professionalismRating,
        'communicationRating': communicationRating,
        'punctualityRating': punctualityRating,
        'qualityOfWorkRating': qualityOfWorkRating,
        'overallRating': overallRating,
        'reviewText': reviewText,
        'createdAt': createdAt.toIso8601String(),
      };

  factory TechnicianReview.fromJson(Map<String, dynamic> json) => TechnicianReview(
        id: json['id'] as String,
        technicianId: json['technicianId'] as String,
        technicianName: json['technicianName'] as String,
        businessId: json['businessId'] as String,
        businessName: json['businessName'] as String,
        businessLogo: json['businessLogo'] as String?,
        hiringId: json['hiringId'] as String,
        jobTitle: json['jobTitle'] as String,
        technicalSkillRating: (json['technicalSkillRating'] as num).toDouble(),
        professionalismRating: (json['professionalismRating'] as num).toDouble(),
        communicationRating: (json['communicationRating'] as num).toDouble(),
        punctualityRating: (json['punctualityRating'] as num).toDouble(),
        qualityOfWorkRating: (json['qualityOfWorkRating'] as num).toDouble(),
        overallRating: (json['overallRating'] as num).toDouble(),
        reviewText: json['reviewText'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
