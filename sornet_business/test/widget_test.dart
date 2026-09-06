import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sornet_business/data/repositories/sornet_business_repository.dart';
import 'package:sornet_business/providers/auth_provider.dart';
import 'package:sornet_business/providers/dashboard_provider.dart';
import 'package:sornet_business/providers/job_provider.dart';
import 'package:sornet_business/providers/technician_provider.dart';
import 'package:sornet_business/providers/application_provider.dart';
import 'package:sornet_business/providers/interview_provider.dart';
import 'package:sornet_business/providers/messaging_provider.dart';
import 'package:sornet_business/providers/offer_provider.dart';
import 'package:sornet_business/providers/hiring_provider.dart';
import 'package:sornet_business/providers/notification_provider.dart';
import 'package:sornet_business/providers/business_profile_provider.dart';
import 'package:sornet_business/main.dart';

void main() {
  testWidgets('SORNET Business App smoke test', (WidgetTester tester) async {
    final repository = SornetBusinessRepository();

    await tester.pumpWidget(
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

    // Initial splash frame verification
    expect(find.byType(MaterialApp), findsOneWidget);

    // Advance splash screen timer
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
