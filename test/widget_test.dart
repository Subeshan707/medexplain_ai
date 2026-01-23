import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:medexplain_ai/app.dart';

void main() {
  testWidgets('App launches without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: MedExplainApp(),
      ),
    );

    // Verify splash screen appears
    expect(find.text('MedExplain AI'), findsOneWidget);
  });
}
