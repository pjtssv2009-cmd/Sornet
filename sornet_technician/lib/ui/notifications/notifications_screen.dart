import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/notification_item.dart';
import '../../providers/notification_provider.dart';
import '../applications/application_detail_screen.dart';
import '../common/empty_state.dart';
import '../interviews/interview_detail_screen.dart';
import '../offers/offer_detail_screen.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.applicationStatus:
      case NotificationType.applicationSubmitted:
      case NotificationType.applicationViewed:
      case NotificationType.shortlisted:
        return Icons.assignment_outlined;
      case NotificationType.interviewInvite:
      case NotificationType.interviewScheduled:
      case NotificationType.interviewReminder:
        return Icons.videocam_outlined;
      case NotificationType.jobOffer:
      case NotificationType.offerReceived:
      case NotificationType.offerAccepted:
        return Icons.local_offer_outlined;
      case NotificationType.verification:
      case NotificationType.verificationUpdate:
        return Icons.verified_user_outlined;
      case NotificationType.jobAlert:
      case NotificationType.jobMatch:
      case NotificationType.jobStarted:
      case NotificationType.jobCompleted:
        return Icons.work_outline_rounded;
      case NotificationType.message:
        return Icons.chat_bubble_outline_rounded;
      case NotificationType.newRating:
        return Icons.star_outline_rounded;
      case NotificationType.system:
      case NotificationType.profileReminder:
        return Icons.info_outline_rounded;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.applicationStatus:
      case NotificationType.applicationSubmitted:
      case NotificationType.applicationViewed:
      case NotificationType.shortlisted:
        return AppTheme.primaryBlue;
      case NotificationType.interviewInvite:
      case NotificationType.interviewScheduled:
      case NotificationType.interviewReminder:
        return AppTheme.accentOrange;
      case NotificationType.jobOffer:
      case NotificationType.offerReceived:
      case NotificationType.offerAccepted:
        return AppTheme.accentGreen;
      case NotificationType.verification:
      case NotificationType.verificationUpdate:
        return AppTheme.accentGreen;
      case NotificationType.jobAlert:
      case NotificationType.jobMatch:
      case NotificationType.jobStarted:
      case NotificationType.jobCompleted:
        return AppTheme.primaryBlue;
      case NotificationType.message:
        return AppTheme.skyBlue;
      case NotificationType.newRating:
        return AppTheme.accentOrange;
      case NotificationType.system:
      case NotificationType.profileReminder:
        return AppTheme.textMuted;
    }
  }

  void _handleNotificationTap(
      BuildContext context, NotificationItem notification) {
    Provider.of<NotificationProvider>(context, listen: false)
        .markAsRead(notification.id);

    if (notification.referenceId != null) {
      if (notification.type == NotificationType.applicationStatus ||
          notification.type == NotificationType.applicationSubmitted ||
          notification.type == NotificationType.applicationViewed ||
          notification.type == NotificationType.shortlisted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ApplicationDetailScreen(
                applicationId: notification.referenceId!),
          ),
        );
      } else if (notification.type == NotificationType.interviewInvite ||
          notification.type == NotificationType.interviewScheduled ||
          notification.type == NotificationType.interviewReminder) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InterviewDetailScreen(
                interviewId: notification.referenceId!),
          ),
        );
      } else if (notification.type == NotificationType.jobOffer ||
          notification.type == NotificationType.offerReceived ||
          notification.type == NotificationType.offerAccepted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                OfferDetailScreen(offerId: notification.referenceId!),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final notifProvider = Provider.of<NotificationProvider>(context);
    final notifications = notifProvider.notifications;

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifProvider.unreadCount > 0)
            TextButton(
              onPressed: () {
                Provider.of<NotificationProvider>(context, listen: false)
                    .markAllAsRead();
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? const Center(
              child: EmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'No notifications',
                subtitle:
                    'When you receive interview invitations, job alerts, or offer updates, they will appear here.',
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifications.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) {
                final notif = notifications[index];
                final icon = _getIconForType(notif.type);
                final color = _getColorForType(notif.type);

                return Container(
                  color: notif.isRead
                      ? Colors.white
                      : AppTheme.primaryLight.withValues(alpha: 0.35),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: color, size: 22),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            notif.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: notif.isRead
                                  ? FontWeight.w600
                                  : FontWeight.w700,
                              color: AppTheme.textDark,
                            ),
                          ),
                        ),
                        if (!notif.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 3),
                        Text(
                          notif.body,
                          style: TextStyle(
                            fontSize: 12,
                            color: notif.isRead
                                ? AppTheme.textMuted
                                : AppTheme.textDark,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Formatters.formatRelativeTime(notif.createdAt),
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                    onTap: () => _handleNotificationTap(context, notif),
                  ),
                );
              },
            ),
    );
  }
}
