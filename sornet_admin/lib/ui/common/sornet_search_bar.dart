import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';

class SornetSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final VoidCallback? onFilterTap;
  final bool hasActiveFilters;

  const SornetSearchBar({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.controller,
    this.onFilterTap,
    this.hasActiveFilters = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x06000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: GoogleFonts.inter(
                  color: AppColors.textMuted,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.textSecondary,
                  size: 20,
                ),
                suffixIcon: controller != null && controller!.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18, color: AppColors.textMuted),
                        onPressed: () {
                          controller!.clear();
                          onChanged('');
                        },
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
          ),
        ),
        if (onFilterTap != null) ...[
          const SizedBox(width: 8),
          InkWell(
            onTap: onFilterTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: hasActiveFilters ? AppColors.primaryLight : AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: hasActiveFilters ? AppColors.primary : AppColors.border,
                  width: hasActiveFilters ? 1.5 : 1,
                ),
              ),
              child: Icon(
                Icons.tune_rounded,
                color: hasActiveFilters ? AppColors.primary : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
