import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/technician.dart';
import '../../data/models/application.dart';
import '../../data/models/interview.dart';
import '../../data/models/offer.dart';
import '../../data/models/work.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double fontSize;

  const StatusBadge({
    super.key,
    String? label,
    String? text,
    Color? backgroundColor,
    Color? textColor,
    Color? color,
    this.icon,
    this.fontSize = 12,
  })  : label = label ?? text ?? '',
        backgroundColor = backgroundColor ??
            (color != null ? const Color(0xFFEFF4FF) : AppTheme.surfaceSubtle),
        textColor = textColor ?? color ?? AppTheme.textPrimary;

  factory StatusBadge.verification(VerificationStatus status) {
    switch (status) {
      case VerificationStatus.verified:
        return const StatusBadge(
          label: 'Verified Technician',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.verified_rounded,
        );
      case VerificationStatus.underReview:
        return const StatusBadge(
          label: 'Under Verification',
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningText,
          icon: Icons.hourglass_top_rounded,
        );
      case VerificationStatus.moreInfoRequired:
        return const StatusBadge(
          label: 'Action Required',
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
          backgroundColor: AppTheme.surfaceSubtle,
          textColor: AppTheme.textSecondary,
          icon: Icons.shield_outlined,
        );
    }
  }

  factory StatusBadge.application(ApplicationStatus status) {
    switch (status) {
      case ApplicationStatus.applied:
        return const StatusBadge(
          label: 'Applied',
          backgroundColor: AppTheme.infoBg,
          textColor: AppTheme.infoText,
          icon: Icons.send_rounded,
        );
      case ApplicationStatus.reviewed:
        return const StatusBadge(
          label: 'Profile Reviewed',
          backgroundColor: AppTheme.purpleBg,
          textColor: AppTheme.purpleText,
          icon: Icons.visibility_rounded,
        );
      case ApplicationStatus.shortlisted:
        return const StatusBadge(
          label: 'Shortlisted',
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningText,
          icon: Icons.star_rounded,
        );
      case ApplicationStatus.interviewScheduled:
        return const StatusBadge(
          label: 'Interview Scheduled',
          backgroundColor: AppTheme.primaryLight,
          textColor: AppTheme.primary,
          icon: Icons.calendar_month_rounded,
        );
      case ApplicationStatus.offerReceived:
        return const StatusBadge(
          label: 'Offer Received',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.card_giftcard_rounded,
        );
      case ApplicationStatus.hired:
        return const StatusBadge(
          label: 'Hired & Active',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.check_circle_rounded,
        );
      case ApplicationStatus.rejected:
        return const StatusBadge(
          label: 'Not Selected',
          backgroundColor: AppTheme.errorBg,
          textColor: AppTheme.errorText,
          icon: Icons.close_rounded,
        );
      case ApplicationStatus.withdrawn:
        return const StatusBadge(
          label: 'Withdrawn',
          backgroundColor: AppTheme.surfaceSubtle,
          textColor: AppTheme.textTertiary,
          icon: Icons.undo_rounded,
        );
    }
  }

  factory StatusBadge.interview(InterviewStatus status) {
    switch (status) {
      case InterviewStatus.scheduled:
        return const StatusBadge(
          label: 'Scheduled',
          backgroundColor: AppTheme.primaryLight,
          textColor: AppTheme.primary,
          icon: Icons.event_available_rounded,
        );
      case InterviewStatus.completed:
        return const StatusBadge(
          label: 'Completed',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.task_alt_rounded,
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
          icon: Icons.event_busy_rounded,
        );
    }
  }

  factory StatusBadge.offer(OfferStatus status) {
    switch (status) {
      case OfferStatus.pending:
        return const StatusBadge(
          label: 'Action Required',
          backgroundColor: AppTheme.warningBg,
          textColor: AppTheme.warningText,
          icon: Icons.alarm_rounded,
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
          icon: Icons.cancel_outlined,
        );
      case OfferStatus.expired:
        return const StatusBadge(
          label: 'Expired',
          backgroundColor: AppTheme.surfaceSubtle,
          textColor: AppTheme.textTertiary,
          icon: Icons.timer_off_outlined,
        );
    }
  }

  factory StatusBadge.work(WorkStatus status) {
    switch (status) {
      case WorkStatus.upcoming:
        return const StatusBadge(
          label: 'Joining Soon',
          backgroundColor: AppTheme.infoBg,
          textColor: AppTheme.infoText,
          icon: Icons.schedule_rounded,
        );
      case WorkStatus.active:
        return const StatusBadge(
          label: 'Currently Active',
          backgroundColor: AppTheme.successBg,
          textColor: AppTheme.successText,
          icon: Icons.engineering_rounded,
        );
      case WorkStatus.completed:
        return const StatusBadge(
          label: 'Completed',
          backgroundColor: AppTheme.surfaceSubtle,
          textColor: AppTheme.textSecondary,
          icon: Icons.done_all_rounded,
        );
    }
  }

  factory StatusBadge.jobType(String type) {
    return StatusBadge(
      label: type,
      backgroundColor: AppTheme.primaryLight,
      textColor: AppTheme.primary,
      icon: Icons.work_outline_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
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
