import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sornet_technician/data/repositories/sornet_technician_repository.dart';
import 'package:sornet_technician/main.dart';
import 'package:sornet_technician/providers/application_provider.dart';
import 'package:sornet_technician/providers/auth_provider.dart';
import 'package:sornet_technician/providers/interview_provider.dart';
import 'package:sornet_technician/providers/job_provider.dart';
import 'package:sornet_technician/providers/messaging_provider.dart';
import 'package:sornet_technician/providers/notification_provider.dart';
import 'package:sornet_technician/providers/offer_provider.dart';
import 'package:sornet_technician/providers/support_provider.dart';
import 'package:sornet_technician/providers/technician_profile_provider.dart';
import 'package:sornet_technician/providers/work_provider.dart';

void main() {
  testWidgets('App renders splash screen and loads without errors',
      (WidgetTester tester) async {
    final repository = SornetTechnicianRepository();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider(repository)),
          ChangeNotifierProvider(
              create: (_) => TechnicianProfileProvider(repository)),
          ChangeNotifierProvider(create: (_) => JobProvider(repository)),
          ChangeNotifierProvider(
              create: (_) => ApplicationProvider(repository)),
          ChangeNotifierProvider(
              create: (_) => InterviewProvider(repository)),
          ChangeNotifierProvider(create: (_) => OfferProvider(repository)),
          ChangeNotifierProvider(create: (_) => WorkProvider(repository)),
          ChangeNotifierProvider(create: (_) => MessagingProvider(repository)),
          ChangeNotifierProvider(
              create: (_) => NotificationProvider(repository)),
          ChangeNotifierProvider(create: (_) => SupportProvider(repository)),
        ],
        child: const SornetTechnicianApp(),
      ),
    );

    expect(find.text('SORNET'), findsWidgets);
    expect(find.text('TECHNICIAN APP'), findsOneWidget);
  });
}
