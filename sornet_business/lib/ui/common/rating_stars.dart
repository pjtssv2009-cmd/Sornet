import 'package:flutter/material.dart';

class RatingStars extends StatelessWidget {
  final double rating;
  final double size;
  final Color color;
  final bool isInteractive;
  final ValueChanged<double>? onRatingChanged;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 18,
    this.color = const Color(0xFFF59E0B), // Amber
    this.isInteractive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        IconData icon;
        if (rating >= starIndex) {
          icon = Icons.star_rounded;
        } else if (rating >= starIndex - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_outline_rounded;
        }

        if (isInteractive) {
          return IconButton(
            iconSize: size,
            padding: const EdgeInsets.symmetric(horizontal: 2),
            constraints: const BoxConstraints(),
            icon: Icon(
              rating >= starIndex ? Icons.star_rounded : Icons.star_outline_rounded,
              color: color,
            ),
            onPressed: () {
              if (onRatingChanged != null) {
                onRatingChanged!(starIndex.toDouble());
              }
            },
          );
        }

        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(icon, size: size, color: color),
        );
      }),
    );
  }
}
