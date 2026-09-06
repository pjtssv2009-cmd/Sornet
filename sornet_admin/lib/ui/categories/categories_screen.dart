import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/category.dart';
import '../../providers/sornet_providers.dart';
import '../common/empty_state.dart';
import '../common/confirm_dialog.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Category Management'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_rounded),
                onPressed: () => _showAddEditCategoryDialog(context, provider),
              ),
            ],
          ),
          body: provider.categories.isEmpty
              ? EmptyState(
                  icon: Icons.category_outlined,
                  title: 'No Categories',
                  description: 'Create your first service marketplace category.',
                  actionText: 'Add Category',
                  onAction: () => _showAddEditCategoryDialog(context, provider),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.categories.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final cat = provider.categories[index];
                    return _buildCategoryCard(context, cat, provider);
                  },
                ),
          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Category'),
            onPressed: () => _showAddEditCategoryDialog(context, provider),
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(BuildContext context, ServiceCategory cat, CategoriesProvider provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(_getCategoryIcon(cat.icon), color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            cat.name,
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ),
                        Switch(
                          value: cat.isActive,
                          activeColor: AppColors.success,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          onChanged: (val) => provider.toggleStatus(cat.id),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      cat.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Subcategories
          if (cat.subcategories.isNotEmpty) ...[
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: cat.subcategories.map((sub) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    sub,
                    style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
          ],
          const Divider(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${cat.technicianCount} Technicians • ${cat.jobsCount} Jobs',
                style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textSecondary),
                    onPressed: () => _showAddEditCategoryDialog(context, provider, category: cat),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                    onPressed: () async {
                      final confirm = await ConfirmDialog.show(
                        context,
                        title: 'Delete Category',
                        message: 'Are you sure you want to delete "${cat.name}"?',
                        confirmText: 'Delete',
                        isDangerous: true,
                      );
                      if (confirm == true) {
                        await provider.deleteCategory(cat.id);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    switch (name) {
      case 'ac_unit':
        return Icons.ac_unit_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'kitchen':
        return Icons.kitchen_rounded;
      case 'local_laundry_service':
        return Icons.local_laundry_service_rounded;
      case 'tv':
        return Icons.tv_rounded;
      case 'water':
        return Icons.water_rounded;
      case 'microwave':
        return Icons.microwave_rounded;
      default:
        return Icons.home_repair_service_rounded;
    }
  }

  void _showAddEditCategoryDialog(BuildContext context, CategoriesProvider provider, {ServiceCategory? category}) {
    final nameCtrl = TextEditingController(text: category?.name ?? '');
    final descCtrl = TextEditingController(text: category?.description ?? '');
    final isEditing = category != null;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEditing ? 'Edit Category' : 'Add Service Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Category Name', hintText: 'e.g. Solar Technician')),
            const SizedBox(height: 12),
            TextField(controller: descCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty) {
                final cat = ServiceCategory(
                  id: category?.id ?? 'cat_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  icon: category?.icon ?? 'home_repair_service',
                  description: descCtrl.text.trim(),
                  isActive: category?.isActive ?? true,
                  technicianCount: category?.technicianCount ?? 0,
                  jobsCount: category?.jobsCount ?? 0,
                  subcategories: category?.subcategories ?? ['General Service', 'Installation'],
                );
                provider.saveCategory(cat);
                Navigator.of(ctx).pop();
              }
            },
            child: Text(isEditing ? 'Save Changes' : 'Create Category'),
          ),
        ],
      ),
    );
  }
}
