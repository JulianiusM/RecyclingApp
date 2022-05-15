import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/app.dart';
import 'package:recycling/data_detail_view.dart';
import 'package:recycling/recycling_data.dart';

import 'util/test_asset_bundle.dart';

void main() {
  testWidgets("Data detail view unit test", (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        home: DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: DataDetailView(
            recData: RecyclingData(
              title: "SingleTest",
              goesTo: "STB",
              generalInformation: "SingleTestData",
              imageUrl: "res/test/img/singleTest.jpg",
              exampleData: ["A", "B"],
            ),
          ),
        ),
      ),
    );

    // Finish async init
    await tester.pumpAndSettle();

    expect(find.text("SingleTest"), findsNWidgets(2));
    expect(find.textContaining("STB"), findsOneWidget);
    expect(find.text("SingleTestData"), findsOneWidget);
  });
}
