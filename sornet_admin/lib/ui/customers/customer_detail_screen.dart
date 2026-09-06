import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/customer.dart';
import '../../providers/sornet_providers.dart';

class CustomerDetailScreen extends StatelessWidget {
  final String customerId;

  const CustomerDetailScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomersProvider>(
      builder: (context, provider, child) {
        final cust = provider.customers.cast<Customer?>().firstWhere(
              (c) => c?.id == customerId,
              orElse: () => null,
            );

        if (cust == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Customer Profile')),
            body: const Center(child: Text('Customer profile not found.')),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Customer Details'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(18),
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
                            radius: 30,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(
                              cust.name[0],
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.primary),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cust.name,
                                  style: GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Customer since ${AppFormatters.formatDate(cust.dateJoined)}',
                                  style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildRow('Phone Number', cust.phone),
                      const SizedBox(height: 8),
                      _buildRow('Email Address', cust.email),
                      const SizedBox(height: 8),
                      _buildRow('Home Address', '${cust.address}, ${cust.city}'),
                      const Divider(height: 24),
                      // Account status toggle switch
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Account Status',
                                style: GoogleFonts.inter(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                              ),
                              Text(
                                cust.isActive ? 'Active customer account' : 'Disabled account',
                                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          Switch(
                            value: cust.isActive,
                            activeColor: AppColors.success,
                            onChanged: (val) {
                              provider.toggleCustomerStatus(cust.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Spending & Bookings Summary
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildCol('Total Bookings', '${cust.totalBookings}'),
                      Container(height: 30, width: 1, color: AppColors.border),
                      _buildCol('Completed', '${cust.completedBookings}', color: AppColors.success),
                      Container(height: 30, width: 1, color: AppColors.border),
                      _buildCol('Total Spend', '₹${AppFormatters.formatNumber(cust.totalSpent.toInt())}', color: AppColors.primary),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Service History
                Container(
                  width: double.infinity,
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
                          const Icon(Icons.history_rounded, size: 18, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Service History',
                            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (cust.serviceHistory.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('No previous service records.', style: TextStyle(color: AppColors.textMuted)),
                        )
                      else
                        ...cust.serviceHistory.map((rec) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        rec.serviceName,
                                        style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 13.5),
                                      ),
                                    ),
                                    Text(
                                      '₹${rec.amount.toInt()}',
                                      style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary, fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Technician: ${rec.technicianName}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                                    Text(AppFormatters.formatDate(rec.date), style: const TextStyle(fontSize: 11.5, color: AppColors.textMuted)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
        Flexible(child: Text(value, textAlign: TextAlign.end, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600))),
      ],
    );
  }

  Widget _buildCol(String label, String val, {Color? color}) {
    return Column(
      children: [
        Text(val, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: color ?? AppColors.textPrimary)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}
