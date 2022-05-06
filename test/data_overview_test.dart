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

    // Finish async init
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

    // Finish async init
    await tester.pumpAndSettle();

    // If everything works as intended, no errors have occurred and no test data was found
    expect(find.textContaining("error occurred"), findsNothing);
    expect(find.text('SingleTest'), findsNothing);
  });

  testWidgets("Overview search test", (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        home: DefaultAssetBundle(
            bundle: TestAssetBundle(),
            child: const DataOverview(title: "TEST")),
      ),
    );

    // Finish async init
    await tester.pumpAndSettle();

    // Check initial state
    expect(find.text('SingleTest'), findsOneWidget);
    expect(find.text('DoubleTest'), findsOneWidget);

    // Get and check search field
    var searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    // Simulate search entry (simple title)
    await tester.enterText(searchField, "SingleTest");
    await tester.pumpAndSettle();

    // Check for expected search results
    expect(find.text("SingleTest"), findsNWidgets(2));
    expect(find.text("DoubleTest"), findsNothing);

    // Simulate search entry (simple example)
    await tester.enterText(searchField, "Wine");
    await tester.pumpAndSettle();

    // Check for expected search results
    expect(find.text("SingleTest"), findsNothing);
    expect(find.text("DoubleTest"), findsOneWidget);
  });
}
