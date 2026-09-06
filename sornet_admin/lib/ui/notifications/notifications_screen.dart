import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/notification_item.dart';
import '../../providers/sornet_providers.dart';
import '../common/empty_state.dart';
import '../technicians/technician_detail_screen.dart';
import '../businesses/business_detail_screen.dart';
import '../jobs/job_detail_screen.dart';
import '../verification/verification_center_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationsProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Notifications Center'),
            actions: [
              if (provider.unreadCount > 0)
                TextButton(
                  onPressed: () => provider.markAllAsRead(),
                  child: const Text('Mark All Read'),
                ),
            ],
          ),
          body: provider.notifications.isEmpty
              ? const EmptyState(
                  icon: Icons.notifications_off_outlined,
                  title: 'No Notifications',
                  description: 'You are all caught up with administrative alerts.',
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = provider.notifications[index];
                    return _buildNotificationCard(context, item, provider);
                  },
                ),
        );
      },
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem item, NotificationsProvider provider) {
    final (icon, color, bg) = _getNotificationMeta(item.type);

    return InkWell(
      onTap: () {
        provider.markAsRead(item.id);
        if (item.targetEntityType == 'technician' && item.targetEntityId != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => TechnicianDetailScreen(technicianId: item.targetEntityId!)),
          );
        } else if (item.targetEntityType == 'business' && item.targetEntityId != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => BusinessDetailScreen(businessId: item.targetEntityId!)),
          );
        } else if (item.targetEntityType == 'job' && item.targetEntityId != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => JobDetailScreen(jobId: item.targetEntityId!)),
          );
        } else if (item.type == NotificationType.technicianVerification || item.type == NotificationType.businessVerification) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const VerificationCenterScreen()),
          );
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead ? AppColors.surface : const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isRead ? AppColors.border : const Color(0xFFB2CCFF),
            width: item.isRead ? 1 : 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.message,
                    style: GoogleFonts.inter(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AppFormatters.formatRelativeTime(item.timestamp),
                    style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, Color) _getNotificationMeta(NotificationType type) {
    switch (type) {
      case NotificationType.technicianVerification:
        return (Icons.verified_user_rounded, AppColors.warning, AppColors.warningBg);
      case NotificationType.businessVerification:
        return (Icons.domain_verification_rounded, AppColors.purple, AppColors.purpleBg);
      case NotificationType.jobPosted:
        return (Icons.work_rounded, AppColors.info, AppColors.infoBg);
      case NotificationType.technicianRegistered:
        return (Icons.person_add_rounded, AppColors.primary, AppColors.primaryLight);
      case NotificationType.businessRegistered:
        return (Icons.domain_add_rounded, AppColors.primary, AppColors.primaryLight);
      case NotificationType.systemAlert:
        return (Icons.notifications_active_rounded, AppColors.success, AppColors.successBg);
    }
  }
}
