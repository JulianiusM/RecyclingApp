import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data_integration.dart';
import 'package:recycling/recycling_data.dart';

import 'lib/test_asset_bundle.dart';
import 'lib/test_utils.dart';

void main() {
  AssetBundle testBundle = TestAssetBundle();

  test("Test empty JSON", () async {
    List<RecyclingData> emptyData = await DataIntegration.generateRecyclingData(
        normalisePath("res/test/json/test_empty.json"),
        injectedBundle: testBundle);

    expect(emptyData.isEmpty, true);
  });

  test("Test JSON w/ 1 data point", () async {
    List<RecyclingData> oneData = await DataIntegration.generateRecyclingData(
        normalisePath("res/test/json/test_one.json"),
        injectedBundle: testBundle);

    expect(oneData.length, 1);

    expect(oneData[0].title, "SingleTest");
    expect(oneData[0].goesTo, "STB");
    expect(oneData[0].generalInformation, "SingleTestData");
    expect(oneData[0].imageUrl, "res/test/img/singleTest.jpg");
    expect(oneData[0].exampleData.isEmpty, true);
  });

  test("Test JSON w/ 1 data point and examples", () async {
    List<RecyclingData> oneData = await DataIntegration.generateRecyclingData(
        normalisePath("res/test/json/test_one_example.json"),
        injectedBundle: testBundle);

    expect(oneData.length, 1);

    expect(oneData[0].title, "SingleTest");
    expect(oneData[0].goesTo, "STB");
    expect(oneData[0].generalInformation, "SingleTestData");
    expect(oneData[0].imageUrl, "res/test/img/singleTest.jpg");
    expect(oneData[0].exampleData.length, 2);
    expect(oneData[0].exampleData[0], "EX1");
    expect(oneData[0].exampleData[1], "EX2");
  });

  test("Test JSON w/ 2 data point and examples", () async {
    List<RecyclingData> oneData = await DataIntegration.generateRecyclingData(
        normalisePath("res/test/json/test_two_example.json"),
        injectedBundle: testBundle);

    expect(oneData.length, 2);

    //First data point
    expect(oneData[0].title, "SingleTest");
    expect(oneData[0].goesTo, "STB");
    expect(oneData[0].generalInformation, "SingleTestData");
    expect(oneData[0].imageUrl, "res/test/img/singleTest.jpg");
    expect(oneData[0].exampleData.length, 2);
    expect(oneData[0].exampleData[0], "EX1");
    expect(oneData[0].exampleData[1], "EX2");

    //Second data point
    expect(oneData[1].title, "DoubleTest");
    expect(oneData[1].goesTo, "DTB");
    expect(oneData[1].generalInformation, "DoubleTestData");
    expect(oneData[1].imageUrl, "res/test/img/doubleTest.jpg");
    expect(oneData[1].exampleData.length, 2);
    expect(oneData[1].exampleData[0], "EX1");
    expect(oneData[1].exampleData[1], "EX3");
  });
}
