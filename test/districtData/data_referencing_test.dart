import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/data/recycling_data.dart';
import 'package:recycling/logic/data_integration.dart';

import '../util/test_asset_bundle.dart';
import '../util/test_utils.dart';

void main() async {
  AssetBundle testBundle = TestAssetBundle();

  List<DistrictData> districtDataList =
      await DataIntegration.generateDistrictData(
          normalisePath("res/test/json/districtData/test_two_example.json"),
          injectedBundle: testBundle);

  // Use district ST as default test district
  DistrictData distDataDef = districtDataList[0];

  test("Test referencing empty data", () async {
    List<RecyclingData> recData = await DataIntegration.generateRecyclingData(
        normalisePath("res/test/json/recyclingData/test_empty.json"),
        injectedBundle: testBundle);

    List<RecyclingData> refData = DataIntegration.mergeRecyclingDistrictData(
        recData, distDataDef.entryList);

    expect(refData, isEmpty);
  });

  test("Test referencing one data", () async {
    List<RecyclingData> recData = await DataIntegration.generateRecyclingData(
        normalisePath("res/test/json/recyclingData/test_one_example.json"),
        injectedBundle: testBundle);

    List<RecyclingData> refData = DataIntegration.mergeRecyclingDistrictData(
        recData, distDataDef.entryList);

    expect(refData.length, 1);

    expect(refData[0].title, "SingleTest");
    expect(refData[0].goesTo, "STB-B");
    expect(refData[0].generalInformation, "SingleTestData");
    expect(refData[0].imageUrl, "res/test/img/singleTest.jpg");
    expect(refData[0].exampleData.length, 2);
    expect(refData[0].exampleData[0], "EX1");
    expect(refData[0].exampleData[1], "EX2");
  });

  test("Test referencing two data", () async {
    List<RecyclingData> recData = await DataIntegration.generateRecyclingData(
        normalisePath("res/test/json/recyclingData/test_two_example.json"),
        injectedBundle: testBundle);

    List<RecyclingData> refData = DataIntegration.mergeRecyclingDistrictData(
        recData, distDataDef.entryList);

    expect(refData.length, 2);

    // First data point
    expect(refData[0].title, "SingleTest");
    expect(refData[0].goesTo, "STB-B");
    expect(refData[0].generalInformation, "SingleTestData");
    expect(refData[0].imageUrl, "res/test/img/singleTest.jpg");
    expect(refData[0].exampleData.length, 2);
    expect(refData[0].exampleData[0], "EX1");
    expect(refData[0].exampleData[1], "EX2");

    // Second data point
    expect(refData[1].title, "DoubleTest");
    expect(refData[1].goesTo, "DTB-B");
    expect(refData[1].generalInformation, "DoubleTestData");
    expect(refData[1].imageUrl, "res/test/img/doubleTest.jpg");
    expect(refData[1].exampleData.length, 2);
    expect(refData[1].exampleData[0], "EX1");
    expect(refData[1].exampleData[1], "EX3");
  });

  test("Test referencing two data using DT district", () async {
    List<RecyclingData> recData = await DataIntegration.generateRecyclingData(
        normalisePath("res/test/json/recyclingData/test_two_example.json"),
        injectedBundle: testBundle);

    List<RecyclingData> refData = DataIntegration.mergeRecyclingDistrictData(
        recData, districtDataList[1].entryList);

    expect(refData.length, 2);

    // First data point
    expect(refData[0].title, "SingleTest");
    expect(refData[0].goesTo, "DSTB-B");
    expect(refData[0].generalInformation, "SingleTestData");
    expect(refData[0].imageUrl, "res/test/img/singleTest.jpg");
    expect(refData[0].exampleData.length, 2);
    expect(refData[0].exampleData[0], "EX1");
    expect(refData[0].exampleData[1], "EX2");

    // Second data point
    expect(refData[1].title, "DoubleTest");
    expect(refData[1].goesTo, "DDTB-B");
    expect(refData[1].generalInformation, "DoubleTestData");
    expect(refData[1].imageUrl, "res/test/img/doubleTest.jpg");
    expect(refData[1].exampleData.length, 2);
    expect(refData[1].exampleData[0], "EX1");
    expect(refData[1].exampleData[1], "EX3");
  });
}
