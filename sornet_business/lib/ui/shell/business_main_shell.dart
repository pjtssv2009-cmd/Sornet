import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/application_provider.dart';
import '../dashboard/business_dashboard_screen.dart';
import '../jobs/my_jobs_screen.dart';
import '../discovery/technician_search_screen.dart';
import '../applications/applications_list_screen.dart';
import '../hiring/my_technicians_screen.dart';

class BusinessMainShell extends StatefulWidget {
  final int initialIndex;

  const BusinessMainShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<BusinessMainShell> createState() => _BusinessMainShellState();
}

class _BusinessMainShellState extends State<BusinessMainShell> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const BusinessDashboardScreen(),
    const MyJobsScreen(),
    const TechnicianSearchScreen(),
    const ApplicationsListScreen(),
    const MyTechniciansScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<ApplicationProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: const Border(
            top: BorderSide(color: AppTheme.border, width: 1),
          ),
          boxShadow: AppTheme.cardShadow,
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Overview',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.work_outline_rounded),
              activeIcon: Icon(Icons.work_rounded),
              label: 'My Jobs',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_rounded),
              activeIcon: Icon(Icons.person_search_rounded),
              label: 'Find Techs',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: appProvider.newApplications.isNotEmpty,
                label: Text('${appProvider.newApplications.length}'),
                backgroundColor: AppTheme.primary,
                child: const Icon(Icons.assignment_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: appProvider.newApplications.isNotEmpty,
                label: Text('${appProvider.newApplications.length}'),
                backgroundColor: AppTheme.primary,
                child: const Icon(Icons.assignment_rounded),
              ),
              label: 'Applications',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded),
              label: 'Technicians',
            ),
          ],
        ),
      ),
    );
  }
}
