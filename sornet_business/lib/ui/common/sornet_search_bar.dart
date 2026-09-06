import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SornetSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final int activeFilterCount;

  const SornetSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search by name, skill, brand, city...',
    this.onChanged,
    this.onClear,
    this.onFilterTap,
    this.activeFilterCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border, width: 1.2),
              boxShadow: AppTheme.cardShadow,
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              textAlignVertical: TextAlignVertical.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                isCollapsed: true,
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: AppTheme.textTertiary,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppTheme.textSecondary,
                  size: 20,
                ),
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textTertiary),
                        onPressed: () {
                          controller.clear();
                          if (onChanged != null) onChanged!('');
                          if (onClear != null) onClear!();
                        },
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          const SizedBox(width: 10),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: activeFilterCount > 0 ? AppTheme.primaryLight : AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: activeFilterCount > 0 ? AppTheme.primary : AppTheme.border,
                    width: 1.2,
                  ),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.tune_rounded,
                      color: activeFilterCount > 0 ? AppTheme.primary : AppTheme.textPrimary,
                      size: 20,
                    ),
                    if (activeFilterCount > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$activeFilterCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
