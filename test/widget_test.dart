import 'package:custom_license_page/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:custom_license_page/license_screen.dart';



void main() {
  testWidgets('Basic Smoke Test', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());
    expect(find.byType(LicenseScreen), findsOneWidget);
    expect(find.text('Open Source Licenses'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(ListView), findsOneWidget);
  });
}
