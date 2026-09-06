import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class ShimmerSkeleton extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ListShimmerLoading extends StatelessWidget {
  final int itemCount;

  const ListShimmerLoading({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              ShimmerSkeleton(width: 48, height: 48, borderRadius: 24),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerSkeleton(width: 140, height: 16),
                    SizedBox(height: 8),
                    ShimmerSkeleton(width: 200, height: 12),
                  ],
                ),
              ),
              ShimmerSkeleton(width: 60, height: 24, borderRadius: 12),
            ],
          ),
        );
      },
    );
  }
}
