import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/app.dart';
import 'package:recycling/data_overview.dart';

import 'lib/test_asset_bundle.dart';

void main() {
  testWidgets('Overview data test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const DataOverview(title: "TEST")),
      ),
    );

    await tester.pumpAndSettle();

    // Verify data
    expect(find.text('SingleTest'), findsOneWidget);
    expect(find.text('STB'), findsOneWidget);

    expect(find.text('DoubleTest'), findsOneWidget);
    expect(find.text('DTB'), findsOneWidget);

    expect(find.text('TripleTest'), findsNothing);
  });

  testWidgets('Overview smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const App(),
    );

    await tester.pumpAndSettle();

    // If everything works as intended, no errors have occurred and no test data was found
    expect(find.textContaining("error occurred"), findsNothing);
    expect(find.text('SingleTest'), findsNothing);
  });
}
