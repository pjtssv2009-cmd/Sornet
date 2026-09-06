import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/work.dart';
import '../../providers/work_provider.dart';
import '../common/empty_state.dart';
import '../common/status_badge.dart';
import 'active_work_detail_screen.dart';
import 'my_ratings_screen.dart';

class MyWorkScreen extends StatefulWidget {
  const MyWorkScreen({super.key});

  @override
  State<MyWorkScreen> createState() => _MyWorkScreenState();
}

class _MyWorkScreenState extends State<MyWorkScreen>
    with SingleTickerProviderStateMixin {
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
    final workProvider = Provider.of<WorkProvider>(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundSoft,
      appBar: AppBar(
        title: const Text('My Work & Engagements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_outline_rounded),
            tooltip: 'My Ratings & Reviews',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyRatingsScreen(),
                ),
              );
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: AppTheme.textMuted,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: [
            Tab(text: 'Active (${workProvider.activeWork.length})'),
            Tab(text: 'Upcoming (${workProvider.upcomingWork.length})'),
            Tab(text: 'Completed (${workProvider.completedWork.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _WorkList(
            records: workProvider.activeWork,
            emptyTitle: 'No active work',
            emptySubtitle: 'Jobs you are currently working on will appear here.',
            emptyIcon: Icons.engineering_outlined,
          ),
          _WorkList(
            records: workProvider.upcomingWork,
            emptyTitle: 'No upcoming work',
            emptySubtitle: 'Accepted jobs starting soon will appear here.',
            emptyIcon: Icons.upcoming_outlined,
          ),
          _WorkList(
            records: workProvider.completedWork,
            emptyTitle: 'No completed engagements',
            emptySubtitle: 'Your past completed jobs and service history will appear here.',
            emptyIcon: Icons.task_alt_outlined,
          ),
        ],
      ),
    );
  }
}

class _WorkList extends StatelessWidget {
  final List<WorkRecord> records;
  final String emptyTitle;
  final String emptySubtitle;
  final IconData emptyIcon;

  const _WorkList({
    required this.records,
    required this.emptyTitle,
    required this.emptySubtitle,
    required this.emptyIcon,
  });

  @override
  Widget build(BuildContext context) {
    if (records.isEmpty) {
      return Center(
        child: EmptyState(
          icon: emptyIcon,
          title: emptyTitle,
          subtitle: emptySubtitle,
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: records.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final record = records[index];
        return _WorkCard(record: record);
      },
    );
  }
}

class _WorkCard extends StatelessWidget {
  final WorkRecord record;

  const _WorkCard({required this.record});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ActiveWorkDetailScreen(recordId: record.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.business_center_rounded,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.jobTitle,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          record.businessName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusBadge(
                    text: record.status.label,
                    color: Color(record.status.badgeColorValue),
                  ),
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        record.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 14, color: AppTheme.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        'Started ${Formatters.formatDate(record.startDate)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Formatters.formatSalary(
                        record.agreedSalary, record.salaryPeriod),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                  Text(
                    record.supervisorName != null
                        ? 'Supervisor: ${record.supervisorName}'
                        : record.workAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
