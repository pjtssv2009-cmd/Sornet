import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/technician.dart';
import '../../data/models/job.dart';
import '../../data/models/application.dart';
import '../../data/models/promotion.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final IconData? icon;
  final bool isSmall;

  const StatusBadge({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
    this.icon,
    this.isSmall = false,
  });

  factory StatusBadge.fromVerificationStatus(VerificationStatus status, {bool isSmall = false}) {
    switch (status) {
      case VerificationStatus.verified:
        return StatusBadge(
          text: 'Verified',
          textColor: AppColors.success,
          backgroundColor: AppColors.successBg,
          borderColor: AppColors.successBorder,
          icon: Icons.check_circle_rounded,
          isSmall: isSmall,
        );
      case VerificationStatus.pending:
        return StatusBadge(
          text: 'Pending Review',
          textColor: AppColors.warning,
          backgroundColor: AppColors.warningBg,
          borderColor: AppColors.warningBorder,
          icon: Icons.schedule_rounded,
          isSmall: isSmall,
        );
      case VerificationStatus.rejected:
        return StatusBadge(
          text: 'Rejected',
          textColor: AppColors.error,
          backgroundColor: AppColors.errorBg,
          borderColor: AppColors.errorBorder,
          icon: Icons.cancel_rounded,
          isSmall: isSmall,
        );
      case VerificationStatus.suspended:
        return StatusBadge(
          text: 'Suspended',
          textColor: const Color(0xFF64748B),
          backgroundColor: const Color(0xFFF1F5F9),
          borderColor: const Color(0xFFCBD5E1),
          icon: Icons.block_rounded,
          isSmall: isSmall,
        );
    }
  }

  factory StatusBadge.fromJobStatus(JobStatus status, {bool isSmall = false}) {
    switch (status) {
      case JobStatus.open:
        return StatusBadge(
          text: 'Open',
          textColor: AppColors.success,
          backgroundColor: AppColors.successBg,
          borderColor: AppColors.successBorder,
          icon: Icons.check_circle_outline_rounded,
          isSmall: isSmall,
        );
      case JobStatus.shortlisted:
        return StatusBadge(
          text: 'Shortlisted',
          textColor: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
          borderColor: const Color(0xFFB2CCFF),
          icon: Icons.people_alt_outlined,
          isSmall: isSmall,
        );
      case JobStatus.interview:
        return StatusBadge(
          text: 'Interview Stage',
          textColor: AppColors.purple,
          backgroundColor: AppColors.purpleBg,
          borderColor: const Color(0xFFDDD6FE),
          icon: Icons.videocam_outlined,
          isSmall: isSmall,
        );
      case JobStatus.filled:
        return StatusBadge(
          text: 'Filled',
          textColor: const Color(0xFF0D9488),
          backgroundColor: const Color(0xFFCCFBF1),
          borderColor: const Color(0xFF99F6E4),
          icon: Icons.task_alt_rounded,
          isSmall: isSmall,
        );
      case JobStatus.closed:
        return StatusBadge(
          text: 'Closed',
          textColor: AppColors.textSecondary,
          backgroundColor: AppColors.surfaceSecondary,
          borderColor: AppColors.border,
          icon: Icons.lock_outline_rounded,
          isSmall: isSmall,
        );
      case JobStatus.draft:
        return StatusBadge(
          text: 'Draft',
          textColor: AppColors.warning,
          backgroundColor: AppColors.warningBg,
          borderColor: AppColors.warningBorder,
          icon: Icons.edit_note_rounded,
          isSmall: isSmall,
        );
      case JobStatus.cancelled:
        return StatusBadge(
          text: 'Cancelled',
          textColor: AppColors.error,
          backgroundColor: AppColors.errorBg,
          borderColor: AppColors.errorBorder,
          icon: Icons.close_rounded,
          isSmall: isSmall,
        );
    }
  }

  factory StatusBadge.fromApplicationStatus(ApplicationStatus status, {bool isSmall = false}) {
    switch (status) {
      case ApplicationStatus.applied:
        return StatusBadge(
          text: 'Applied',
          textColor: AppColors.info,
          backgroundColor: AppColors.infoBg,
          borderColor: AppColors.infoBorder,
          icon: Icons.send_outlined,
          isSmall: isSmall,
        );
      case ApplicationStatus.shortlisted:
        return StatusBadge(
          text: 'Shortlisted',
          textColor: AppColors.primary,
          backgroundColor: AppColors.primaryLight,
          borderColor: const Color(0xFFB2CCFF),
          icon: Icons.thumb_up_alt_outlined,
          isSmall: isSmall,
        );
      case ApplicationStatus.interview:
        return StatusBadge(
          text: 'Interview',
          textColor: AppColors.purple,
          backgroundColor: AppColors.purpleBg,
          borderColor: const Color(0xFFDDD6FE),
          icon: Icons.record_voice_over_outlined,
          isSmall: isSmall,
        );
      case ApplicationStatus.selected:
        return StatusBadge(
          text: 'Selected',
          textColor: AppColors.success,
          backgroundColor: AppColors.successBg,
          borderColor: AppColors.successBorder,
          icon: Icons.check_circle_rounded,
          isSmall: isSmall,
        );
      case ApplicationStatus.rejected:
        return StatusBadge(
          text: 'Rejected',
          textColor: AppColors.error,
          backgroundColor: AppColors.errorBg,
          borderColor: AppColors.errorBorder,
          icon: Icons.cancel_outlined,
          isSmall: isSmall,
        );
      case ApplicationStatus.withdrawn:
        return StatusBadge(
          text: 'Withdrawn',
          textColor: AppColors.textMuted,
          backgroundColor: AppColors.surfaceSecondary,
          borderColor: AppColors.border,
          icon: Icons.remove_circle_outline_rounded,
          isSmall: isSmall,
        );
    }
  }

  factory StatusBadge.fromPromotionStatus(PromotionStatus status, {bool isSmall = false}) {
    switch (status) {
      case PromotionStatus.active:
        return StatusBadge(
          text: 'Active',
          textColor: AppColors.success,
          backgroundColor: AppColors.successBg,
          borderColor: AppColors.successBorder,
          icon: Icons.fiber_manual_record,
          isSmall: isSmall,
        );
      case PromotionStatus.scheduled:
        return StatusBadge(
          text: 'Scheduled',
          textColor: AppColors.info,
          backgroundColor: AppColors.infoBg,
          borderColor: AppColors.infoBorder,
          icon: Icons.calendar_today_rounded,
          isSmall: isSmall,
        );
      case PromotionStatus.expired:
        return StatusBadge(
          text: 'Expired',
          textColor: AppColors.textMuted,
          backgroundColor: AppColors.surfaceSecondary,
          borderColor: AppColors.border,
          icon: Icons.hourglass_bottom_rounded,
          isSmall: isSmall,
        );
      case PromotionStatus.draft:
        return StatusBadge(
          text: 'Draft',
          textColor: AppColors.warning,
          backgroundColor: AppColors.warningBg,
          borderColor: AppColors.warningBorder,
          icon: Icons.edit_note_rounded,
          isSmall: isSmall,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 8 : 10,
        vertical: isSmall ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: isSmall ? 12 : 14,
              color: textColor,
            ),
            SizedBox(width: isSmall ? 3 : 5),
          ],
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: isSmall ? 11 : 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}
