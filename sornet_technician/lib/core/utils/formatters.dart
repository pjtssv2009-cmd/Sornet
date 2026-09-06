import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class Formatters {
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static final DateFormat _shortDateFormatter = DateFormat('dd MMM yyyy');
  static final DateFormat _fullDateFormatter = DateFormat('EEEE, dd MMMM yyyy');
  static final DateFormat _timeFormatter = DateFormat('hh:mm a');
  static final DateFormat _dateTimeFormatter = DateFormat('dd MMM, hh:mm a');

  static String formatCurrency(num amount) {
    return _currencyFormatter.format(amount);
  }

  static String formatSalary(num amount, [String period = 'monthly']) {
    final periodStr = period.toLowerCase().contains('month')
        ? '/mo'
        : period.toLowerCase().contains('day')
            ? '/day'
            : period.toLowerCase().contains('year') || period.toLowerCase().contains('annum')
                ? '/yr'
                : '/job';
    return '${formatCurrency(amount)}$periodStr';
  }

  static String formatSalaryRange(num min, num max, {String period = 'month'}) {
    final periodStr = period.toLowerCase().contains('month')
        ? '/mo'
        : period.toLowerCase().contains('day')
            ? '/day'
            : '/job';
    return '${formatCurrency(min)} - ${formatCurrency(max)}$periodStr';
  }

  static String formatDate(DateTime dateTime) {
    return _shortDateFormatter.format(dateTime);
  }

  static String formatFullDate(DateTime dateTime) {
    return _fullDateFormatter.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return _timeFormatter.format(dateTime);
  }

  static String formatDateTime(DateTime dateTime) {
    return _dateTimeFormatter.format(dateTime);
  }

  static String timeAgo(DateTime dateTime) {
    return formatRelativeTime(dateTime);
  }

  static String formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '${weeks}w ago';
    } else {
      return _shortDateFormatter.format(dateTime);
    }
  }

  static Color getTrustScoreColor(int score) {
    if (score >= 90) return AppTheme.success;
    if (score >= 75) return AppTheme.primary;
    if (score >= 60) return AppTheme.warning;
    return AppTheme.error;
  }

  static Color getProfileStrengthColor(int percentage) {
    if (percentage >= 80) return AppTheme.success;
    if (percentage >= 50) return AppTheme.warning;
    return AppTheme.error;
  }
}
