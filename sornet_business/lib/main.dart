import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'data/repositories/sornet_business_repository.dart';
import 'providers/auth_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/job_provider.dart';
import 'providers/technician_provider.dart';
import 'providers/application_provider.dart';
import 'providers/interview_provider.dart';
import 'providers/messaging_provider.dart';
import 'providers/offer_provider.dart';
import 'providers/hiring_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/business_profile_provider.dart';
import 'ui/auth/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure status bar style for light theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final repository = SornetBusinessRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider(repository)),
        ChangeNotifierProvider(create: (_) => JobProvider(repository)),
        ChangeNotifierProvider(create: (_) => TechnicianProvider(repository)),
        ChangeNotifierProvider(create: (_) => ApplicationProvider(repository)),
        ChangeNotifierProvider(create: (_) => InterviewProvider(repository)),
        ChangeNotifierProvider(create: (_) => MessagingProvider(repository)),
        ChangeNotifierProvider(create: (_) => OfferProvider(repository)),
        ChangeNotifierProvider(create: (_) => HiringProvider(repository)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(repository)),
        ChangeNotifierProvider(create: (_) => BusinessProfileProvider(repository)),
      ],
      child: const SornetBusinessApp(),
    ),
  );
}

class SornetBusinessApp extends StatelessWidget {
  const SornetBusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, // Strict Light Mode Only
      home: const SplashScreen(),
    );
  }
}
