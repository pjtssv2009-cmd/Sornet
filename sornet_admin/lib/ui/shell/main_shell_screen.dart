import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/sornet_providers.dart';
import '../common/offline_banner.dart';
import '../dashboard/admin_dashboard_screen.dart';
import '../technicians/technicians_list_screen.dart';
import '../businesses/businesses_list_screen.dart';
import '../customers/customers_list_screen.dart';
import '../jobs/jobs_list_screen.dart';
import '../applications/applications_list_screen.dart';
import '../verification/verification_center_screen.dart';
import '../categories/categories_screen.dart';
import '../modules/modules_screen.dart';
import '../marketing/marketing_screen.dart';
import '../admin_users/admin_users_screen.dart';
import '../reports/reports_screen.dart';
import '../notifications/notifications_screen.dart';
import '../search/global_search_screen.dart';
import '../settings/settings_screen.dart';
import '../settings/admin_profile_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTopAppBar(context),
      body: Column(
        children: [
          const OfflineBanner(),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                const AdminDashboardScreen(),
                const _UsersHubScreen(),
                const _JobsHubScreen(),
                const _MoreHubScreen(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded),
              activeIcon: Icon(Icons.people_rounded),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline_rounded),
              activeIcon: Icon(Icons.work_rounded),
              label: 'Jobs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.grid_view_outlined),
              activeIcon: Icon(Icons.grid_view_rounded),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final user = auth.currentUser;

    return AppBar(
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'S',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.appName,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                'Admin Portal',
                style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded, size: 22),
          tooltip: 'Global Search',
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const GlobalSearchScreen()),
          ),
        ),
        Consumer<NotificationsProvider>(
          builder: (context, notifProvider, child) {
            final unread = notifProvider.unreadCount;
            return Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined, size: 22),
                  tooltip: 'Notifications',
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                  ),
                ),
                if (unread > 0)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                      child: Text(
                        '$unread',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12, left: 4),
          child: GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminProfileScreen()),
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primaryLight,
              backgroundImage: user?.avatarUrl.isNotEmpty == true ? NetworkImage(user!.avatarUrl) : null,
              child: user?.avatarUrl.isEmpty != false
                  ? Text(
                      user?.name.isNotEmpty == true ? user!.name[0] : 'A',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}

// --- Users Hub Screen (Technicians, Businesses, Customers tabs) ---
class _UsersHubScreen extends StatelessWidget {
  const _UsersHubScreen();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: const TabBar(
              tabs: [
                Tab(text: 'Technicians'),
                Tab(text: 'Businesses'),
                Tab(text: 'Customers'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                TechniciansListScreen(showAppBar: false),
                BusinessesListScreen(showAppBar: false),
                CustomersListScreen(showAppBar: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Jobs Hub Screen (Jobs and Applications) ---
class _JobsHubScreen extends StatelessWidget {
  const _JobsHubScreen();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppColors.surface,
            child: const TabBar(
              tabs: [
                Tab(text: 'Active Jobs'),
                Tab(text: 'Candidate Applications'),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                JobsListScreen(showAppBar: false),
                ApplicationsListScreen(showAppBar: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- More Section Hub (Enterprise Dashboard Navigation Grid) ---
class _MoreHubScreen extends StatelessWidget {
  const _MoreHubScreen();

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _MoreItem(
        title: 'Verification Center',
        subtitle: 'Review pending IDs & trade licenses',
        icon: Icons.verified_user_rounded,
        iconColor: AppColors.warning,
        iconBg: AppColors.warningBg,
        badgeText: 'Action',
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const VerificationCenterScreen()),
        ),
      ),
      _MoreItem(
        title: 'Categories & Services',
        subtitle: 'AC, Electrical, Plumbing, Appliances',
        icon: Icons.category_rounded,
        iconColor: AppColors.primary,
        iconBg: AppColors.primaryLight,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const CategoriesScreen()),
        ),
      ),
      _MoreItem(
        title: 'Platform Modules',
        subtitle: 'Toggle core features and registrations',
        icon: Icons.toggle_on_rounded,
        iconColor: const Color(0xFF0D9488),
        iconBg: const Color(0xFFCCFBF1),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ModulesScreen()),
        ),
      ),
      _MoreItem(
        title: 'Marketing & Promotions',
        subtitle: 'Banner promotions & hiring drives',
        icon: Icons.campaign_rounded,
        iconColor: const Color(0xFFE11D48),
        iconBg: const Color(0xFFFFE4E6),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const MarketingScreen()),
        ),
      ),
      _MoreItem(
        title: 'Admin Users & RBAC',
        subtitle: 'Manage administrative roles & permissions',
        icon: Icons.admin_panel_settings_rounded,
        iconColor: AppColors.purple,
        iconBg: AppColors.purpleBg,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AdminUsersScreen()),
        ),
      ),
      _MoreItem(
        title: 'Reports & Analytics',
        subtitle: 'Platform metrics & CSV data export',
        icon: Icons.bar_chart_rounded,
        iconColor: AppColors.info,
        iconBg: AppColors.infoBg,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ReportsScreen()),
        ),
      ),
      _MoreItem(
        title: 'Notification Center',
        subtitle: 'System alerts and real-time updates',
        icon: Icons.notifications_rounded,
        iconColor: const Color(0xFFF97316),
        iconBg: const Color(0xFFFFEDD5),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const NotificationsScreen()),
        ),
      ),
      _MoreItem(
        title: 'Settings & API Config',
        subtitle: 'Security, biometrics & backend REST API',
        icon: Icons.settings_rounded,
        iconColor: AppColors.textSecondary,
        iconBg: AppColors.surfaceSecondary,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
        ),
      ),
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Enterprise Admin Tools',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: navItems.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final item = navItems[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: item.iconBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 22),
                  ),
                  title: Row(
                    children: [
                      Text(
                        item.title,
                        style: GoogleFonts.inter(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (item.badgeText != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.warningBg,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppColors.warningBorder),
                          ),
                          child: Text(
                            item.badgeText!,
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warning,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      item.subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted, size: 20),
                  onTap: item.onTap,
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _MoreItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String? badgeText;
  final VoidCallback onTap;

  _MoreItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.badgeText,
    required this.onTap,
  });
}
