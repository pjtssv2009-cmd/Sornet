import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/notification_item.dart';
import '../../providers/notification_provider.dart';
import '../common/empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifProvider = context.watch<NotificationProvider>();
    final notifs = notifProvider.notifications;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifProvider.unreadCount > 0)
            TextButton(
              onPressed: () {
                notifProvider.markAllAsRead();
              },
              child: const Text('Mark All Read', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
            ),
        ],
      ),
      body: SafeArea(
        child: notifs.isEmpty
            ? const EmptyState(
                icon: Icons.notifications_none_rounded,
                title: 'No Notifications',
                message: 'Alerts regarding applications, interviews, and offer responses will appear here.',
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: notifs.length,
                itemBuilder: (context, index) {
                  final notif = notifs[index];
                  return _buildNotificationCard(context, notif, notifProvider);
                },
              ),
      ),
    );
  }

  Widget _buildNotificationCard(BuildContext context, NotificationItem notif, NotificationProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: notif.isRead ? AppTheme.surface : AppTheme.primaryLight.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: notif.isRead ? AppTheme.border : AppTheme.primary.withValues(alpha: 0.3),
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: ListTile(
        onTap: () {
          provider.markAsRead(notif.id);
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getNotificationColor(notif.type).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(_getNotificationIcon(notif.type), color: _getNotificationColor(notif.type), size: 20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notif.title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: notif.isRead ? FontWeight.w600 : FontWeight.w800,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            if (!notif.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primary,
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
              notif.message,
              style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, height: 1.3),
            ),
            const SizedBox(height: 4),
            Text(
              Formatters.timeAgo(notif.timestamp),
              style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.newApplication:
        return Icons.assignment_ind_rounded;
      case NotificationType.technicianShortlisted:
        return Icons.star_rounded;
      case NotificationType.interviewReminder:
        return Icons.event_available_rounded;
      case NotificationType.offerAccepted:
        return Icons.celebration_rounded;
      case NotificationType.offerRejected:
        return Icons.cancel_outlined;
      case NotificationType.jobExpiring:
        return Icons.timer_outlined;
      case NotificationType.technicianRecommendation:
        return Icons.recommend_rounded;
      case NotificationType.adminVerificationUpdate:
        return Icons.verified_user_rounded;
      case NotificationType.generalAlert:
        return Icons.notifications_active_rounded;
    }
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.newApplication:
        return AppTheme.primary;
      case NotificationType.technicianShortlisted:
        return AppTheme.purple;
      case NotificationType.interviewReminder:
        return AppTheme.warning;
      case NotificationType.offerAccepted:
        return AppTheme.success;
      case NotificationType.offerRejected:
        return AppTheme.error;
      case NotificationType.jobExpiring:
        return AppTheme.warning;
      case NotificationType.technicianRecommendation:
        return AppTheme.primary;
      case NotificationType.adminVerificationUpdate:
        return AppTheme.info;
      case NotificationType.generalAlert:
        return AppTheme.primary;
    }
  }
}
