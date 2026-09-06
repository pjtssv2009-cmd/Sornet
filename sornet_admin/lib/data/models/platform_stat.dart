class PlatformStat {
  final int totalTechnicians;
  final int verifiedTechnicians;
  final int pendingTechVerifications;
  final int rejectedTechnicians;
  final int suspendedTechnicians;
  
  final int totalBusinesses;
  final int verifiedBusinesses;
  final int pendingBusinessVerifications;
  final int rejectedBusinesses;

  final int totalCustomers;
  final int activeCustomers;

  final int totalJobs;
  final int activeJobs;
  final int pendingJobs;
  final int filledJobs;
  final int closedJobs;

  final int totalApplications;
  final int selectedApplications;
  final int interviewApplications;

  final double techGrowthPercentage;
  final double businessGrowthPercentage;
  final double jobsGrowthPercentage;
  final double appsGrowthPercentage;

  const PlatformStat({
    required this.totalTechnicians,
    required this.verifiedTechnicians,
    required this.pendingTechVerifications,
    required this.rejectedTechnicians,
    required this.suspendedTechnicians,
    required this.totalBusinesses,
    required this.verifiedBusinesses,
    required this.pendingBusinessVerifications,
    required this.rejectedBusinesses,
    required this.totalCustomers,
    required this.activeCustomers,
    required this.totalJobs,
    required this.activeJobs,
    required this.pendingJobs,
    required this.filledJobs,
    required this.closedJobs,
    required this.totalApplications,
    required this.selectedApplications,
    required this.interviewApplications,
    required this.techGrowthPercentage,
    required this.businessGrowthPercentage,
    required this.jobsGrowthPercentage,
    required this.appsGrowthPercentage,
  });
}
