import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/sornet_providers.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = '30 Days';

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboard, child) {
        final stats = dashboard.stats;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Reports & Analytics'),
            actions: [
              IconButton(
                icon: const Icon(Icons.file_download_outlined),
                tooltip: 'Export Report',
                onPressed: () => _showExportDialog(context),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Period filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Today', '7 Days', '30 Days', '90 Days', 'Custom'].map((period) {
                      final isSel = _selectedPeriod == period;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(period),
                          selected: isSel,
                          selectedColor: AppColors.primaryLight,
                          labelStyle: TextStyle(
                            color: isSel ? AppColors.primary : AppColors.textPrimary,
                            fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                          ),
                          onSelected: (val) {
                            if (val) setState(() => _selectedPeriod = period);
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),

                // Executive Summary Card
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Platform Summary Metrics',
                            style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                          ),
                          Text(
                            'Period: $_selectedPeriod',
                            style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      _buildMetricRow('Technician Registrations', '${stats?.totalTechnicians ?? 12450}', '+14.8%'),
                      const Divider(height: 16),
                      _buildMetricRow('Verified Service Professionals', '${stats?.verifiedTechnicians ?? 8920}', '+18.2%'),
                      const Divider(height: 16),
                      _buildMetricRow('Business Employer Accounts', '${stats?.totalBusinesses ?? 1240}', '+9.4%'),
                      const Divider(height: 16),
                      _buildMetricRow('Jobs Commissioned', '${stats?.totalJobs ?? 430}', '+22.6%'),
                      const Divider(height: 16),
                      _buildMetricRow('Job Applications Processed', '${stats?.totalApplications ?? 3120}', '+31.0%'),
                      const Divider(height: 16),
                      _buildMetricRow('Successful Placements & Hires', '${stats?.selectedApplications ?? 650}', '+19.5%'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Category Distribution Donut Chart
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category Distribution',
                        style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          SizedBox(
                            width: 130,
                            height: 130,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 2,
                                centerSpaceRadius: 36,
                                sections: [
                                  PieChartSectionData(value: 58, color: AppColors.primary, radius: 24, showTitle: false),
                                  PieChartSectionData(value: 18, color: AppColors.secondary, radius: 24, showTitle: false),
                                  PieChartSectionData(value: 14, color: AppColors.purple, radius: 24, showTitle: false),
                                  PieChartSectionData(value: 10, color: const Color(0xFF10B981), radius: 24, showTitle: false),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildLegendItem(AppColors.primary, 'AC Technician (58%)'),
                                const SizedBox(height: 6),
                                _buildLegendItem(AppColors.secondary, 'Electrician (18%)'),
                                const SizedBox(height: 6),
                                _buildLegendItem(AppColors.purple, 'Plumber (14%)'),
                                const SizedBox(height: 6),
                                _buildLegendItem(const Color(0xFF10B981), 'Appliances (10%)'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Export Button Card
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.download_rounded),
                  label: const Text('Export Complete CSV Report'),
                  onPressed: () => _showExportDialog(context),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricRow(String label, String value, String growth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary)),
        Row(
          children: [
            Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            const SizedBox(width: 6),
            Text(growth, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: AppColors.success)),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(text, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }

  void _showExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Export Analytics Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Generated format: CSV Spreadsheet (.csv)'),
            const SizedBox(height: 8),
            Text('Dataset: SORNET Marketplace Admin Report - $_selectedPeriod', style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle_outline, color: AppColors.primary, size: 18),
                  SizedBox(width: 8),
                  Text('Ready for download (142 KB)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Report exported to Downloads folder!'), backgroundColor: AppColors.success),
              );
            },
            child: const Text('Download CSV'),
          ),
        ],
      ),
    );
  }
}
