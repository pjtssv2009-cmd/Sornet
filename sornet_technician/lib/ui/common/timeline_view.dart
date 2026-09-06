import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/application.dart';

class ApplicationTimelineView extends StatelessWidget {
  final List<TimelineStep> steps;

  const ApplicationTimelineView({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;

        Color dotColor;
        IconData dotIcon;

        if (step.isCompleted) {
          dotColor = AppTheme.success;
          dotIcon = Icons.check_rounded;
        } else if (step.isCurrent) {
          dotColor = AppTheme.primary;
          dotIcon = Icons.radio_button_checked_rounded;
        } else {
          dotColor = AppTheme.border;
          dotIcon = Icons.radio_button_unchecked_rounded;
        }

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line & indicator
              SizedBox(
                width: 28,
                child: Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: step.isCompleted
                            ? AppTheme.successBg
                            : step.isCurrent
                                ? AppTheme.primaryLight
                                : AppTheme.surfaceSubtle,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: dotColor,
                          width: step.isCurrent ? 2 : 1.5,
                        ),
                      ),
                      child: Icon(dotIcon, size: 12, color: dotColor),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: step.isCompleted ? AppTheme.success : AppTheme.border,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Step Content
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            step.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: step.isCurrent || step.isCompleted ? FontWeight.w700 : FontWeight.w500,
                              color: step.isCurrent || step.isCompleted ? AppTheme.textPrimary : AppTheme.textTertiary,
                            ),
                          ),
                          if (step.timestamp != null)
                            Text(
                              Formatters.formatDateTime(step.timestamp!),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w400,
                                color: AppTheme.textTertiary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.description,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: step.isCurrent ? AppTheme.textSecondary : AppTheme.textTertiary,
                          height: 1.3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
