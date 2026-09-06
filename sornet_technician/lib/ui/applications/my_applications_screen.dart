import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../data/models/application.dart';
import '../../providers/application_provider.dart';
import '../common/status_badge.dart';
import '../common/empty_state.dart';
import '../common/confirm_dialog.dart';
import 'application_detail_screen.dart';

class MyApplicationsScreen extends StatefulWidget {
  final int initialTab;

  const MyApplicationsScreen({super.key, this.initialTab = 0});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'All',
    'Applied',
    'Shortlisted',
    'Interview',
    'Selected / Offer',
    'Rejected',
    'Withdrawn',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Application> _filterApplications(List<Application> all, int tabIndex) {
    switch (tabIndex) {
      case 1:
        return all.where((a) => a.status == ApplicationStatus.applied || a.status == ApplicationStatus.reviewed).toList();
      case 2:
        return all.where((a) => a.status == ApplicationStatus.shortlisted).toList();
      case 3:
        return all.where((a) => a.status == ApplicationStatus.interviewScheduled).toList();
      case 4:
        return all.where((a) => a.status == ApplicationStatus.offerReceived || a.status == ApplicationStatus.hired).toList();
      case 5:
        return all.where((a) => a.status == ApplicationStatus.rejected).toList();
      case 6:
        return all.where((a) => a.status == ApplicationStatus.withdrawn).toList();
      case 0:
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<ApplicationProvider>();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Applications'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppTheme.primary,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.primary,
          labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: List.generate(_tabs.length, (tabIndex) {
            final filtered = _filterApplications(appProvider.applications, tabIndex);

            if (filtered.isEmpty) {
              return EmptyState(
                icon: Icons.assignment_late_outlined,
                title: 'No Applications in this Stage',
                description: tabIndex == 0
                    ? 'You have not submitted any job applications yet. Browse open jobs to apply.'
                    : 'No applications currently marked as ${_tabs[tabIndex]}.',
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final app = filtered[index];
                return _buildApplicationCard(context, app, appProvider);
              },
            );
          }),
        ),
      ),
    );
  }

  Widget _buildApplicationCard(BuildContext context, Application app, ApplicationProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.primaryLight,
                child: const Icon(Icons.business_rounded, color: AppTheme.primary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.jobTitle,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: AppTheme.textPrimary),
                    ),
                    Row(
                      children: [
                        Text(
                          app.businessName,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.textSecondary),
                        ),
                        if (app.isBusinessVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, size: 13, color: AppTheme.success),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              StatusBadge.application(app.status),
            ],
          ),
          const Divider(height: 20),

          // Location & Expected Salary
          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 14, color: AppTheme.textTertiary),
              const SizedBox(width: 4),
              Text(app.city, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              const SizedBox(width: 16),
              const Icon(Icons.payments_outlined, size: 14, color: AppTheme.textTertiary),
              const SizedBox(width: 4),
              Text(
                'Expected: ${Formatters.formatCurrency(app.expectedSalary)}/mo',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Action Buttons & Applied Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Applied ${Formatters.formatDate(app.appliedDate)}',
                style: const TextStyle(fontSize: 11, color: AppTheme.textTertiary),
              ),
              Row(
                children: [
                  if (app.status != ApplicationStatus.withdrawn &&
                      app.status != ApplicationStatus.rejected &&
                      app.status != ApplicationStatus.hired)
                    TextButton(
                      onPressed: () async {
                        final confirm = await ConfirmDialog.show(
                          context,
                          title: 'Withdraw Application?',
                          message: 'Are you sure you want to withdraw your application for "${app.jobTitle}" at ${app.businessName}?',
                          confirmText: 'Withdraw',
                          isDestructive: true,
                        );
                        if (confirm == true) {
                          provider.withdrawApplication(app.id);
                        }
                      },
                      child: const Text('Withdraw', style: TextStyle(fontSize: 12, color: AppTheme.error)),
                    ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => ApplicationDetailScreen(application: app)),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(100, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('View Status', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
