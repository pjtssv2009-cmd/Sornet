import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sornet_admin/ui/common/status_badge.dart';
import 'package:sornet_admin/data/models/technician.dart';
import 'package:sornet_admin/data/models/job.dart';

void main() {
  group('Common Widgets Tests', () {
    testWidgets('StatusBadge fromVerificationStatus displays correct text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge.fromVerificationStatus(VerificationStatus.verified),
          ),
        ),
      );

      expect(find.text('Verified'), findsOneWidget);
    });

    testWidgets('StatusBadge fromJobStatus displays correct label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatusBadge.fromJobStatus(JobStatus.open),
          ),
        ),
      );

      expect(find.text('Open'), findsOneWidget);
    });
  });
}
