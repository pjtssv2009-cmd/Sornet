import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/hiring.dart';
import '../../data/models/technician.dart';
import '../../providers/hiring_provider.dart';
import '../../providers/technician_provider.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../discovery/technician_detail_screen.dart';
import '../messaging/chat_conversation_screen.dart';
import 'rate_technician_screen.dart';

class MyTechniciansScreen extends StatefulWidget {
  const MyTechniciansScreen({super.key});

  @override
  State<MyTechniciansScreen> createState() => _MyTechniciansScreenState();
}

class _MyTechniciansScreenState extends State<MyTechniciansScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hiringProvider = context.watch<HiringProvider>();
    final techProvider = context.watch<TechnicianProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Technicians'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Active (${hiringProvider.activeHired.length})'),
            Tab(text: 'Upcoming (${hiringProvider.upcomingHired.length})'),
            Tab(text: 'Completed (${hiringProvider.completedHired.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildList(context, hiringProvider.activeHired, techProvider),
          _buildList(context, hiringProvider.upcomingHired, techProvider),
          _buildList(context, hiringProvider.completedHired, techProvider),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<HiredTechnician> list, TechnicianProvider techProvider) {
    if (list.isEmpty) {
      return const EmptyState(
        icon: Icons.people_outline_rounded,
        title: 'No Technicians in this Category',
        message: 'When candidates accept your job offers, they appear here in your active workforce.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final hired = list[index];
        final tech = techProvider.technicians.firstWhere(
          (t) => t.id == hired.technicianId,
          orElse: () => Technician(
            id: hired.technicianId,
            name: hired.technicianName,
            photoUrl: hired.technicianPhoto,
            phone: hired.technicianPhone,
            email: 'tech@sornet.com',
            location: hired.location,
            city: hired.location,
            experienceYears: 5,
            rating: hired.rating,
            reviewsCount: 40,
            trustScore: 96,
            availability: 'Hired',
            expectedSalaryMonthly: hired.salary,
            dailyRate: 1200,
            about: '',
            acExpertise: ['Split AC'],
            technicalExpertise: ['Inverter'],
            brands: ['Daikin'],
            services: ['Installation'],
            experienceHistory: [],
            certificates: [],
          ),
        );

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryLight,
                      child: Text(
                        hired.technicianName.isNotEmpty ? hired.technicianName[0] : 'T',
                        style: const TextStyle(fontWeight: FontWeight.w700, color: AppTheme.primary, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hired.technicianName,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppTheme.textPrimary),
                          ),
                          Text(
                            hired.position,
                            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            'Job: ${hired.jobTitle}',
                            style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    StatusBadge.hiring(hired.status),
                  ],
                ),
                const SizedBox(height: 12),

                // Info Pill
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoColumn('Salary', '${Formatters.formatCurrency(hired.salary)} / ${hired.salaryPeriod}'),
                      _buildInfoColumn('Joining Date', Formatters.formatDate(hired.joiningDate)),
                      _buildInfoColumn('Rating', '${hired.rating}★'),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                const Divider(height: 1, color: AppTheme.borderLight),
                const SizedBox(height: 10),

                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TechnicianDetailScreen(technician: tech)),
                        );
                      },
                      child: const Text('Profile', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chat_outlined, color: AppTheme.primary, size: 20),
                          tooltip: 'Message',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ChatConversationScreen(technician: tech)),
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        if (!hired.hasBeenReviewed) ...[
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => RateTechnicianScreen(hiredTechnician: hired),
                                ),
                              );
                            },
                            icon: const Icon(Icons.star_rate_rounded, size: 14),
                            label: const Text('Rate Tech'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF59E0B),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppTheme.successBg,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded, color: AppTheme.successText, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  'Reviewed',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.successText),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textTertiary)),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
      ],
    );
  }
}
