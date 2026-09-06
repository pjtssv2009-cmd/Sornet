import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';

class ProfileStrengthCard extends StatelessWidget {
  final int percentage;
  final VoidCallback? onCompleteTap;

  const ProfileStrengthCard({
    super.key,
    required this.percentage,
    VoidCallback? onCompleteTap,
    VoidCallback? onTapAction,
  }) : onCompleteTap = onCompleteTap ?? onTapAction;

  @override
  Widget build(BuildContext context) {
    final color = Formatters.getProfileStrengthColor(percentage);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 1),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.bolt_rounded,
                        size: 18, color: AppTheme.primary),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Profile Strength',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage / 100.0,
              minHeight: 8,
              backgroundColor: AppTheme.borderLight,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Complete your profile to get 3x more interview invites from top employers.',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      size: 14, color: AppTheme.success),
                  SizedBox(width: 4),
                  Text('Basic',
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.textSecondary)),
                  SizedBox(width: 8),
                  Icon(Icons.check_circle_rounded,
                      size: 14, color: AppTheme.success),
                  SizedBox(width: 4),
                  Text('Skills',
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.textSecondary)),
                  SizedBox(width: 8),
                  Icon(Icons.check_circle_rounded,
                      size: 14, color: AppTheme.success),
                  SizedBox(width: 4),
                  Text('Docs',
                      style: TextStyle(
                          fontSize: 11, color: AppTheme.textSecondary)),
                ],
              ),
              if (onCompleteTap != null)
                InkWell(
                  onTap: onCompleteTap,
                  child: const Row(
                    children: [
                      Text(
                        'Complete Profile',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          size: 16, color: AppTheme.primary),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
