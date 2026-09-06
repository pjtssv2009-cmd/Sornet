import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';

class TrustScoreWidget extends StatelessWidget {
  final int score;
  final VoidCallback? onTap;

  const TrustScoreWidget({
    super.key,
    required this.score,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Formatters.getTrustScoreColor(score);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: AppTheme.trustScoreGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            // Circular Score Gauge
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 58,
                  height: 58,
                  child: CircularProgressIndicator(
                    value: score / 100.0,
                    strokeWidth: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.15),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '$score',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    const Text(
                      '/100',
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'SORNET Trust Score',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(Icons.verified_rounded, size: 16, color: color),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'High Trust: Verified ID, 6.5Y Exp, 3 Certificates & 4.9★ rating.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white70, size: 20),
          ],
        ),
      ),
    );
  }
}
