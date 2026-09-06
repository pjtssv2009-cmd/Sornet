import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color activeColor;
  final Color inactiveColor;
  final bool isInteractive;
  final ValueChanged<double>? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 16,
    Color? color,
    Color? activeColor,
    this.inactiveColor = const Color(0xFFE2E8F0),
    this.isInteractive = false,
    this.onRatingChanged,
  }) : activeColor = color ?? activeColor ?? const Color(0xFFF79009);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starValue = index + 1.0;
        IconData icon;
        Color color;

        if (rating >= starValue) {
          icon = Icons.star_rounded;
          color = activeColor;
        } else if (rating >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
          color = activeColor;
        } else {
          icon = Icons.star_outline_rounded;
          color = inactiveColor;
        }

        final starWidget = Icon(icon, size: size, color: color);

        if (isInteractive || onRatingChanged != null) {
          return GestureDetector(
            onTap: () {
              if (onRatingChanged != null) {
                onRatingChanged!(starValue);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: starWidget,
            ),
          );
        }

        return starWidget;
      }),
    );
  }
}
