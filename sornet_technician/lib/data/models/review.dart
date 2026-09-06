class BusinessReview {
  final String id;
  final String businessId;
  final String businessName;
  final String businessLogo;
  final String jobTitle;
  final String? technicianId;
  final String? technicianName;
  final String? technicianTrade;
  final double technicalSkillRating;
  final double professionalismRating;
  final double communicationRating;
  final double punctualityRating;
  final double qualityOfWorkRating;
  final double timelyPaymentRating;
  final double workEnvironmentRating;
  final double overallRating;
  final String reviewText;
  final bool wouldRecommend;
  final DateTime createdAt;

  BusinessReview({
    required this.id,
    required this.businessId,
    required this.businessName,
    String? businessLogo,
    required this.jobTitle,
    this.technicianId,
    this.technicianName,
    this.technicianTrade,
    double? technicalSkillRating,
    double? professionalismRating,
    double? communicationRating,
    double? punctualityRating,
    double? qualityOfWorkRating,
    double? timelyPaymentRating,
    double? workEnvironmentRating,
    required this.overallRating,
    required this.reviewText,
    this.wouldRecommend = true,
    required this.createdAt,
  })  : businessLogo = businessLogo ?? '',
        technicalSkillRating = technicalSkillRating ?? overallRating,
        professionalismRating = professionalismRating ?? overallRating,
        communicationRating = communicationRating ?? overallRating,
        punctualityRating = punctualityRating ?? overallRating,
        qualityOfWorkRating = qualityOfWorkRating ?? overallRating,
        timelyPaymentRating = timelyPaymentRating ?? overallRating,
        workEnvironmentRating = workEnvironmentRating ?? overallRating;
}

class EmployerRating {
  final String id;
  final String workId;
  final String businessId;
  final String businessName;
  final String businessLogo;
  final String jobTitle;
  final String? technicianId;
  final double professionalismRating;
  final double communicationRating;
  final double paymentRating;
  final double workEnvironmentRating;
  final double technicalSkillRating;
  final double qualityOfWorkRating;
  final double punctualityRating;
  final double safetyAdherenceRating;
  final double overallRating;
  final String reviewText;
  final bool wouldHireAgain;
  final DateTime createdAt;

  EmployerRating({
    required this.id,
    String? workId,
    required this.businessId,
    required this.businessName,
    String? businessLogo,
    String? jobTitle,
    this.technicianId,
    double? professionalismRating,
    double? communicationRating,
    double? paymentRating,
    double? workEnvironmentRating,
    double? technicalSkillRating,
    double? qualityOfWorkRating,
    double? punctualityRating,
    double? safetyAdherenceRating,
    required this.overallRating,
    required this.reviewText,
    this.wouldHireAgain = true,
    required this.createdAt,
  })  : workId = workId ?? '',
        businessLogo = businessLogo ?? '',
        jobTitle = jobTitle ?? 'HVAC Project',
        professionalismRating = professionalismRating ?? overallRating,
        communicationRating = communicationRating ?? overallRating,
        paymentRating = paymentRating ?? overallRating,
        workEnvironmentRating = workEnvironmentRating ?? overallRating,
        technicalSkillRating = technicalSkillRating ?? overallRating,
        qualityOfWorkRating = qualityOfWorkRating ?? overallRating,
        punctualityRating = punctualityRating ?? overallRating,
        safetyAdherenceRating = safetyAdherenceRating ?? overallRating;

  static double calculateOverall(
    double professionalism,
    double communication,
    double payment,
    double workEnv,
  ) {
    return (professionalism + communication + payment + workEnv) / 4.0;
  }
}
