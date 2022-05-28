import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/app.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/data/district_data_entry.dart';
import 'package:recycling/ui/district_data_detail_view.dart';

import 'util/test_asset_bundle.dart';

void main() {
  testWidgets("District data entry detail view test",
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        home: DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: DistrictDataDetailView(
            districtDataEntry: DistrictDataEntry(
              goesTo: "STB",
              generalInformation: "genInfo",
              imageUrl: "res/test/img/singleTest.jpg",
              allowedExamples: ["AllowEx"],
              disallowedExamples: ["DisallowEx"],
              dataTitles: ["SingleTest"],
            ),
          ),
        ),
      ),
    );

    // Finish async init
    await tester.pumpAndSettle();

    expect(find.text("STB"), findsNWidgets(2));
    expect(find.text("genInfo"), findsOneWidget);
    expect(find.text("AllowEx"), findsOneWidget);
    expect(find.text("DisallowEx"), findsOneWidget);
  });

  testWidgets("District data detail view test", (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(
        home: DefaultAssetBundle(
          bundle: TestAssetBundle(),
          child: DistrictDataDetailView(
            districtData: DistrictData(
              name: "STB",
              description: "genInfo",
              imageUrl: "res/test/img/singleTest.jpg",
              lat: 0.0,
              long: 0.0,
              zoom: 0.0,
              hasAdditionalInformation: true,
              additionalInformation: [
                "Responsible city deputy:",
                "Mrs. Example",
                "Office for environment",
                "Examplestr. 4",
                "12345 ST"
              ],
              entryList: [],
              locationList: [],
            ),
          ),
        ),
      ),
    );

    // Finish async init
    await tester.pumpAndSettle();

    expect(find.text("STB"), findsNWidgets(2));
    expect(find.text("genInfo"), findsOneWidget);
    expect(
        find.text(
            "Responsible city deputy:\nMrs. Example\nOffice for environment\nExamplestr. 4\n12345 ST"),
        findsOneWidget);
  });
}
