import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/business.dart';
import '../../data/models/job.dart';
import '../../data/models/application.dart';
import '../../data/models/interview.dart';
import '../../data/models/offer.dart';
import '../../data/models/hiring.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double fontSize;
  final EdgeInsets padding;

  const StatusBadge({
    super.key,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
    this.fontSize = 11,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  factory StatusBadge.verified({String label = 'Verified'}) {
    return StatusBadge(
      label: label,
      backgroundColor: AppTheme.infoBg,
      textColor: AppTheme.primary,
      icon: Icons.verified_rounded,
    );
  }

  factory StatusBadge.trustScore(int score) {
    Color bg = AppTheme.successBg;
    Color text = AppTheme.successText;
    if (score < 90) {
      bg = AppTheme.warningBg;
      text = AppTheme.warningText;
    }
    return StatusBadge(
      label: 'Trust $score/100',
      backgroundColor: bg,
      textColor: text,
      icon: Icons.shield_rounded,
    );
  }

  factory StatusBadge.businessVerification(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return const StatusBadge(
          label: 'Verified Business',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.verified_rounded,
        );
      case VerificationStatus.underReview:
        return const StatusBadge(
          label: 'Under Review',
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningText,
          icon: Icons.access_time_rounded,
        );
      case VerificationStatus.moreInfoRequired:
        return const StatusBadge(
          label: 'Info Required',
          backgroundColor: AppTheme.infoBg,
          textColor: AppTheme.infoText,
          icon: Icons.info_outline_rounded,
        );
      case VerificationStatus.rejected:
        return const StatusBadge(
          label: 'Rejected',
          backgroundColor: AppTheme.errorBg,
          textColor: AppTheme.errorText,
          icon: Icons.cancel_outlined,
        );
      case VerificationStatus.notSubmitted:
        return const StatusBadge(
          label: 'Not Submitted',
          backgroundColor: AppTheme.surfaceMuted,
          textColor: AppTheme.textSecondary,
        );
    }
  }

  factory StatusBadge.job(JobStatus status) {
    switch (status) {
      case JobStatus.active:
        return const StatusBadge(
          label: 'Active',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.check_circle_outline_rounded,
        );
      case JobStatus.draft:
        return const StatusBadge(
          label: 'Draft',
          backgroundColor: AppTheme.surfaceMuted,
          textColor: AppTheme.textSecondary,
          icon: Icons.edit_note_rounded,
        );
      case JobStatus.closed:
        return const StatusBadge(
          label: 'Closed',
          backgroundColor: AppTheme.border,
          textColor: AppTheme.textTertiary,
          icon: Icons.lock_outline_rounded,
        );
    }
  }

  factory StatusBadge.application(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.newApplication:
        return const StatusBadge(
          label: 'New',
          backgroundColor: AppTheme.infoBg,
          textColor: AppTheme.infoText,
        );
      case ApplicationStatus.shortlisted:
        return const StatusBadge(
          label: 'Shortlisted',
          backgroundColor: AppTheme.purpleBg,
          textColor: AppTheme.purple,
          icon: Icons.star_rounded,
        );
      case ApplicationStatus.interviewScheduled:
        return const StatusBadge(
          label: 'Interview',
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningText,
          icon: Icons.event_rounded,
        );
      case ApplicationStatus.offerSent:
        return const StatusBadge(
          label: 'Offer Sent',
          backgroundColor: Color(0xFFE0E7FF),
          textColor: Color(0xFF4338CA),
          icon: Icons.send_rounded,
        );
      case ApplicationStatus.selected:
        return const StatusBadge(
          label: 'Hired',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.handshake_rounded,
        );
      case ApplicationStatus.rejected:
        return const StatusBadge(
          label: 'Rejected',
          backgroundColor: AppTheme.errorBg,
          textColor: AppTheme.errorText,
        );
    }
  }

  factory StatusBadge.interview(InterviewStatus status) {
    switch (status) {
      case InterviewStatus.scheduled:
        return const StatusBadge(
          label: 'Scheduled',
          backgroundColor: AppTheme.infoBg,
          textColor: AppTheme.infoText,
          icon: Icons.calendar_today_rounded,
        );
      case InterviewStatus.completed:
        return const StatusBadge(
          label: 'Completed',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.check_circle_rounded,
        );
      case InterviewStatus.rescheduled:
        return const StatusBadge(
          label: 'Rescheduled',
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningText,
          icon: Icons.update_rounded,
        );
      case InterviewStatus.cancelled:
        return const StatusBadge(
          label: 'Cancelled',
          backgroundColor: AppTheme.errorBg,
          textColor: AppTheme.errorText,
          icon: Icons.cancel_rounded,
        );
    }
  }

  factory StatusBadge.offer(OfferStatus status) {
    switch (status) {
      case OfferStatus.sent:
        return const StatusBadge(
          label: 'Sent',
          backgroundColor: AppTheme.infoBg,
          textColor: AppTheme.infoText,
          icon: Icons.send_rounded,
        );
      case OfferStatus.accepted:
        return const StatusBadge(
          label: 'Accepted',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.check_circle_rounded,
        );
      case OfferStatus.rejected:
        return const StatusBadge(
          label: 'Declined',
          backgroundColor: AppTheme.errorBg,
          textColor: AppTheme.errorText,
          icon: Icons.cancel_rounded,
        );
      case OfferStatus.expired:
        return const StatusBadge(
          label: 'Expired',
          backgroundColor: AppTheme.border,
          textColor: AppTheme.textTertiary,
          icon: Icons.timer_off_rounded,
        );
      case OfferStatus.cancelled:
        return const StatusBadge(
          label: 'Cancelled',
          backgroundColor: AppTheme.surfaceMuted,
          textColor: AppTheme.textSecondary,
        );
    }
  }

  factory StatusBadge.hiring(HiringStatus status) {
    switch (status) {
      case HiringStatus.active:
        return const StatusBadge(
          label: 'Active',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.circle,
        );
      case HiringStatus.upcoming:
        return const StatusBadge(
          label: 'Upcoming Joining',
          backgroundColor: AppTheme.infoBg,
          textColor: AppTheme.infoText,
          icon: Icons.schedule_rounded,
        );
      case HiringStatus.completed:
        return const StatusBadge(
          label: 'Contract Completed',
          backgroundColor: AppTheme.purpleBg,
          textColor: AppTheme.purple,
          icon: Icons.check_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: fontSize + 2, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
