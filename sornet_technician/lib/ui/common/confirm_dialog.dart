import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final bool isDestructive;
  final Color? confirmColor;
  final VoidCallback? onConfirm;
  final IconData? icon;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.isDestructive = false,
    this.confirmColor,
    this.onConfirm,
    this.icon,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
    Color? confirmColor,
    VoidCallback? onConfirm,
    IconData? icon,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => ConfirmDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        isDestructive: isDestructive,
        confirmColor: confirmColor,
        onConfirm: onConfirm,
        icon: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveButtonColor = confirmColor ?? (isDestructive ? AppTheme.error : AppTheme.primary);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.surface,
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive ? AppTheme.errorBg : AppTheme.primaryLight,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isDestructive ? AppTheme.error : AppTheme.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: AppTheme.textSecondary,
          height: 1.4,
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            cancelText,
            style: const TextStyle(fontWeight: FontWeight.w600, color: AppTheme.textSecondary),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (onConfirm != null) onConfirm!();
            Navigator.of(context).pop(true);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveButtonColor,
            foregroundColor: Colors.white,
            minimumSize: const Size(100, 42),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
