import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/network/network_status.dart';
import 'data/repositories/sornet_repository.dart';
import 'providers/sornet_providers.dart';
import 'ui/auth/admin_login_screen.dart';
import 'ui/shell/main_shell_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar to light mode styling
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final repository = SornetRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NetworkStatusProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => DashboardProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => TechniciansProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => BusinessesProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => CustomersProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => JobsProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => ApplicationsProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => CategoriesProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => ModulesProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => MarketingProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => AdminUsersProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => NotificationsProvider(repository: repository)),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: const SornetAdminApp(),
    ),
  );
}

class SornetAdminApp extends StatelessWidget {
  const SornetAdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SORNET Admin',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, // Strict light mode only
      home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoggedIn) {
            return const MainShellScreen();
          } else {
            return const AdminLoginScreen();
          }
        },
      ),
    );
  }
}
