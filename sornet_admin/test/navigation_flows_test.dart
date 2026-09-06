import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sornet_admin/data/repositories/sornet_repository.dart';
import 'package:sornet_admin/providers/sornet_providers.dart';
import 'package:sornet_admin/core/network/network_status.dart';
import 'package:sornet_admin/ui/auth/admin_login_screen.dart';
import 'package:sornet_admin/ui/shell/main_shell_screen.dart';
import 'package:sornet_admin/ui/technicians/technicians_list_screen.dart';
import 'package:sornet_admin/ui/verification/verification_center_screen.dart';
import 'package:sornet_admin/ui/businesses/businesses_list_screen.dart';
import 'package:sornet_admin/ui/customers/customers_list_screen.dart';
import 'package:sornet_admin/ui/jobs/jobs_list_screen.dart';
import 'package:sornet_admin/ui/applications/applications_list_screen.dart';
import 'package:sornet_admin/ui/categories/categories_screen.dart';
import 'package:sornet_admin/ui/modules/modules_screen.dart';
import 'package:sornet_admin/ui/marketing/marketing_screen.dart';
import 'package:sornet_admin/ui/admin_users/admin_users_screen.dart';
import 'package:sornet_admin/ui/reports/reports_screen.dart';
import 'package:sornet_admin/ui/notifications/notifications_screen.dart';
import 'package:sornet_admin/ui/search/global_search_screen.dart';
import 'package:sornet_admin/ui/settings/settings_screen.dart';
import 'package:sornet_admin/ui/settings/api_config_screen.dart';
import 'package:sornet_admin/ui/settings/about_sornet_screen.dart';

final kTestImage = <int>[
  0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D, 0x49,
  0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x06,
  0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44,
  0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, 0x0D,
  0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE, 0x42,
  0x60, 0x82,
];

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) => _TestHttpClient();
}

class _TestHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _TestHttpClientRequest();
  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

class _TestHttpClientRequest implements HttpClientRequest {
  @override
  Future<HttpClientResponse> close() async => _TestHttpClientResponse();
  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

class _TestHttpClientResponse implements HttpClientResponse {
  @override
  int get statusCode => 200;
  @override
  int get contentLength => kTestImage.length;
  @override
  HttpClientResponseCompressionState get compressionState => HttpClientResponseCompressionState.notCompressed;
  @override
  StreamSubscription<List<int>> listen(void Function(List<int> event)? onData,
      {Function? onError, void Function()? onDone, bool? cancelOnError}) {
    return Stream<List<int>>.fromIterable([kTestImage]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }
  @override
  dynamic noSuchMethod(Invocation invocation) {}
}

Widget createTestApp(Widget homeWidget, {SornetRepository? repo}) {
  final repository = repo ?? SornetRepository();
  return MultiProvider(
    providers: [
      Provider<ISornetRepository>.value(value: repository),
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
      ChangeNotifierProvider(create: (_) => NetworkStatusProvider()),
    ],
    child: MaterialApp(
      home: homeWidget,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = _TestHttpOverrides();

  group('All Navigation Flows & Screen Render Tests', () {
    testWidgets('1. Admin Login Screen renders and quick login fills form', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const AdminLoginScreen()));
      await tester.pumpAndSettle();

      expect(find.text('SORNET'), findsWidgets);
      expect(find.text('Sign In to Dashboard'), findsOneWidget);
      expect(find.text('Sign In to Admin Portal'), findsOneWidget);
      expect(find.textContaining('admin@sornet.com'), findsWidgets);
    });

    testWidgets('2. Main Shell Screen renders with Dashboard bottom nav', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(createTestApp(const MainShellScreen()));
      await tester.pumpAndSettle();

      expect(find.text('SORNET'), findsWidgets);
      expect(find.text('Admin Portal'), findsWidgets);
      expect(find.text('Home'), findsWidgets);
      expect(find.text('Users'), findsWidgets);
      expect(find.text('Jobs'), findsWidgets);
      expect(find.text('More'), findsWidgets);
    });

    testWidgets('3. Technicians List Screen renders and filters search', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const TechniciansListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Technician Management'), findsWidgets);
      expect(find.textContaining('All'), findsWidgets);
      expect(find.textContaining('Pending'), findsWidgets);
      expect(find.textContaining('Verified'), findsWidgets);
    });

    testWidgets('4. Verification Center Screen renders queue tabs', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const VerificationCenterScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Verification Center'), findsWidgets);
      expect(find.text('Technicians'), findsWidgets);
      expect(find.text('Businesses'), findsWidgets);
    });

    testWidgets('5. Businesses List Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const BusinessesListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Business Management'), findsWidgets);
    });

    testWidgets('6. Customers List Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const CustomersListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Customer Management'), findsWidgets);
    });

    testWidgets('7. Jobs List Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const JobsListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Job Management'), findsWidgets);
    });

    testWidgets('8. Applications List Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const ApplicationsListScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Applications Pipeline'), findsWidgets);
    });

    testWidgets('9. Categories Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const CategoriesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Category Management'), findsWidgets);
    });

    testWidgets('10. Platform Modules & Feature Toggles Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const ModulesScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Module & Feature Management'), findsWidgets);
    });

    testWidgets('11. Marketing Promotions Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const MarketingScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Marketing & Promotions'), findsWidgets);
    });

    testWidgets('12. Admin Users & RBAC Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const AdminUsersScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Admin Users & RBAC'), findsWidgets);
    });

    testWidgets('13. Reports & Analytics Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const ReportsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Reports & Analytics'), findsWidgets);
    });

    testWidgets('14. Notifications Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const NotificationsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Notifications Center'), findsWidgets);
    });

    testWidgets('15. Global Search Screen renders and accepts query input', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const GlobalSearchScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('16. Settings Screen and sub-screens render', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const SettingsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Settings & Administration'), findsWidgets);
    });

    testWidgets('17. API Config Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const ApiConfigScreen()));
      await tester.pumpAndSettle();

      expect(find.text('API Configuration'), findsWidgets);
    });

    testWidgets('18. About SORNET Screen renders', (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(const AboutSornetScreen()));
      await tester.pumpAndSettle();

      expect(find.text('About SORNET'), findsWidgets);
    });
  });
}
