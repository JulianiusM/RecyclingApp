import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/app.dart';
import 'package:recycling/data_overview.dart';

import '../lib/test_asset_bundle.dart';

void main() {
  testWidgets('Overview data test (DE)', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        home: DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: Localizations(
            delegates: AppLocalizations.localizationsDelegates,
            locale: const Locale("de"),
            child: const DataOverview(title: "TEST"),
          ),
        ),
      ),
    );

    // Finish async init
    await tester.pumpAndSettle();

    // Verify data
    expect(find.text('SingleTestDE'), findsOneWidget);
    expect(find.text('STB'), findsOneWidget);

    expect(find.text('DoubleTestLANG'), findsOneWidget);
    expect(find.text('DTB'), findsOneWidget);

    expect(find.text('TripleTest'), findsNothing);
  });

  testWidgets("Overview search test (DE)", (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        home: DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: Localizations(
            delegates: AppLocalizations.localizationsDelegates,
            locale: const Locale("de"),
            child: const DataOverview(title: "TEST"),
          ),
        ),
      ),
    );

    // Finish async init
    await tester.pumpAndSettle();

    // Check initial state
    expect(find.text('SingleTestDE'), findsOneWidget);
    expect(find.text('DoubleTestLANG'), findsOneWidget);

    // Get and check search field
    var searchField = find.byType(TextField);
    expect(searchField, findsOneWidget);

    // Simulate search entry (simple title)
    await tester.enterText(searchField, "SingleTestDE");
    await tester.pumpAndSettle();

    // Check for expected search results
    expect(find.text("SingleTestDE"), findsNWidgets(2));
    expect(find.text("DoubleTestLANG"), findsNothing);

    // Simulate search entry (simple example)
    await tester.enterText(searchField, "WineGER");
    await tester.pumpAndSettle();

    // Check for expected search results
    expect(find.text("SingleTestDE"), findsNothing);
    expect(find.text("DoubleTestLANG"), findsOneWidget);
  });

  testWidgets('Overview to detail view data test (DE)',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        home: DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: Localizations(
            delegates: AppLocalizations.localizationsDelegates,
            locale: const Locale("de"),
            child: const DataOverview(title: "TEST"),
          ),
        ),
      ),
    );

    // Finish async init
    await tester.pumpAndSettle();

    // Get and check search field
    var tapField = find.widgetWithText(InkWell, "SingleTestDE");
    expect(tapField, findsOneWidget);

    // Perform tap
    await tester.tap(tapField);
    await tester.pumpAndSettle();

    // Check data of detail view
    expect(find.text("SingleTestDE"), findsNWidgets(2));
    expect(find.textContaining(": STB"), findsOneWidget);
    expect(find.text("SingleTestDataDE"), findsOneWidget);
  });
}
