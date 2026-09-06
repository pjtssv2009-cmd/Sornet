import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'data/repositories/sornet_technician_repository.dart';
import 'providers/application_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/interview_provider.dart';
import 'providers/job_provider.dart';
import 'providers/messaging_provider.dart';
import 'providers/notification_provider.dart';
import 'providers/offer_provider.dart';
import 'providers/support_provider.dart';
import 'providers/technician_profile_provider.dart';
import 'providers/work_provider.dart';
import 'ui/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set system navigation & status bar colors for premium light theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  final repository = SornetTechnicianRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(repository)),
        ChangeNotifierProvider(create: (_) => TechnicianProfileProvider(repository)),
        ChangeNotifierProvider(create: (_) => JobProvider(repository)),
        ChangeNotifierProvider(create: (_) => ApplicationProvider(repository)),
        ChangeNotifierProvider(create: (_) => InterviewProvider(repository)),
        ChangeNotifierProvider(create: (_) => OfferProvider(repository)),
        ChangeNotifierProvider(create: (_) => WorkProvider(repository)),
        ChangeNotifierProvider(create: (_) => MessagingProvider(repository)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(repository)),
        ChangeNotifierProvider(create: (_) => SupportProvider(repository)),
      ],
      child: const SornetTechnicianApp(),
    ),
  );
}

class SornetTechnicianApp extends StatelessWidget {
  const SornetTechnicianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SORNET Technician',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, // Strict Light Mode Only
      home: const SplashScreen(),
    );
  }
}
