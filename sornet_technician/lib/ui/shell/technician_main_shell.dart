import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/application_provider.dart';
import '../../providers/interview_provider.dart';
import '../dashboard/technician_dashboard_screen.dart';
import '../jobs/job_search_screen.dart';
import '../applications/my_applications_screen.dart';
import '../interviews/my_interviews_screen.dart';
import '../profile/technician_profile_screen.dart';

class TechnicianMainShell extends StatefulWidget {
  final int initialIndex;

  const TechnicianMainShell({super.key, this.initialIndex = 0});

  @override
  State<TechnicianMainShell> createState() => _TechnicianMainShellState();
}

class _TechnicianMainShellState extends State<TechnicianMainShell> {
  late int _currentIndex;

  final List<Widget> _screens = [
    const TechnicianDashboardScreen(),
    const JobSearchScreen(),
    const MyApplicationsScreen(),
    const MyInterviewsScreen(),
    const TechnicianProfileScreen(),
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
    final interviewProvider = context.watch<InterviewProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: const Border(top: BorderSide(color: AppTheme.border, width: 1)),
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
              label: 'Find Jobs',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: appProvider.applications.isNotEmpty,
                label: Text('${appProvider.applications.length}'),
                backgroundColor: AppTheme.primary,
                child: const Icon(Icons.assignment_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: appProvider.applications.isNotEmpty,
                label: Text('${appProvider.applications.length}'),
                backgroundColor: AppTheme.primary,
                child: const Icon(Icons.assignment_rounded),
              ),
              label: 'Applications',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: interviewProvider.upcomingInterviews.isNotEmpty,
                label: Text('${interviewProvider.upcomingInterviews.length}'),
                backgroundColor: AppTheme.warning,
                child: const Icon(Icons.calendar_today_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: interviewProvider.upcomingInterviews.isNotEmpty,
                label: Text('${interviewProvider.upcomingInterviews.length}'),
                backgroundColor: AppTheme.warning,
                child: const Icon(Icons.calendar_month_rounded),
              ),
              label: 'Interviews',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
