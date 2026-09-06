import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/customer.dart';
import '../../providers/sornet_providers.dart';
import '../common/sornet_search_bar.dart';
import '../common/empty_state.dart';
import '../common/shimmer_loading.dart';
import 'customer_detail_screen.dart';

class CustomersListScreen extends StatefulWidget {
  final bool showAppBar;
  const CustomersListScreen({super.key, this.showAppBar = true});

  @override
  State<CustomersListScreen> createState() => _CustomersListScreenState();
}

class _CustomersListScreenState extends State<CustomersListScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomersProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: widget.showAppBar
              ? AppBar(
                  title: const Text('Customer Management'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded),
                      onPressed: () => provider.loadCustomers(),
                    ),
                  ],
                )
              : null,
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                color: AppColors.surface,
                child: SornetSearchBar(
                  hintText: 'Search customer name, phone, email, city...',
                  controller: _searchController,
                  onChanged: (val) => provider.setSearchQuery(val),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: provider.isLoading && provider.customers.isEmpty
                    ? const ListShimmerLoading(itemCount: 6)
                    : provider.customers.isEmpty
                        ? EmptyState(
                            icon: Icons.people_outline_rounded,
                            title: 'No Customers Found',
                            description: 'No customer accounts match your search query.',
                            actionText: 'Clear Search',
                            onAction: () {
                              _searchController.clear();
                              provider.setSearchQuery('');
                            },
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: provider.customers.length,
                            separatorBuilder: (context, index) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final cust = provider.customers[index];
                              return _buildCustomerCard(context, cust, provider);
                            },
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCustomerCard(BuildContext context, Customer cust, CustomersProvider provider) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CustomerDetailScreen(customerId: cust.id),
        ),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    cust.name.isNotEmpty ? cust.name[0] : 'C',
                    style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
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
                              cust.name,
                              style: GoogleFonts.inter(fontSize: 15.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: cust.isActive ? AppColors.successBg : AppColors.errorBg,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: cust.isActive ? AppColors.successBorder : AppColors.errorBorder),
                            ),
                            child: Text(
                              cust.isActive ? 'Active' : 'Disabled',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: cust.isActive ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${cust.phone} • ${cust.city}',
                        style: GoogleFonts.inter(fontSize: 12.5, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bookings: ${cust.totalBookings} (${cust.completedBookings} Completed)',
                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                ),
                Text(
                  'Spent: ${AppFormatters.formatCompactNumber(cust.totalSpent.toInt())}',
                  style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
