import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class SornetSearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;
  final int activeFilterCount;
  final TextEditingController? controller;
  final VoidCallback? onClear;

  const SornetSearchBar({
    super.key,
    this.hintText = 'Search jobs, AC types, brands...',
    required this.onChanged,
    this.onFilterTap,
    this.activeFilterCount = 0,
    this.controller,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.border, width: 1),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14, right: 10),
            child: Icon(Icons.search_rounded, color: AppTheme.primary, size: 22),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14, color: AppTheme.textPrimary, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 14, color: AppTheme.textTertiary, fontWeight: FontWeight.w400),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          if (controller != null && controller!.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close_rounded, size: 18, color: AppTheme.textTertiary),
              onPressed: () {
                controller?.clear();
                onChanged('');
                onClear?.call();
              },
            ),
          if (onFilterTap != null) ...[
            Container(
              height: 24,
              width: 1,
              color: AppTheme.border,
            ),
            InkWell(
              onTap: onFilterTap,
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(14)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Badge(
                  isLabelVisible: activeFilterCount > 0,
                  label: Text('$activeFilterCount'),
                  backgroundColor: AppTheme.primary,
                  child: const Icon(Icons.tune_rounded, color: AppTheme.textSecondary, size: 20),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
