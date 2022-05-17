import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data_integration.dart';
import 'package:recycling/district_data.dart';
import 'package:recycling/district_data_entry.dart';

import '../util/test_asset_bundle.dart';
import '../util/test_utils.dart';

void main() {
  AssetBundle testBundle = TestAssetBundle();

  test("Test empty JSON", () async {
    List<DistrictData> emptyData = await DataIntegration.generateDistrictData(
        normalisePath("res/test/json/districtData/test_empty.json"),
        injectedBundle: testBundle);

    expect(emptyData.isEmpty, true);
  });

  test("Test JSON w/ 1 data point", () async {
    List<DistrictData> oneData = await DataIntegration.generateDistrictData(
        normalisePath("res/test/json/districtData/test_one.json"),
        injectedBundle: testBundle);

    expect(oneData.length, 1);

    expect(oneData[0].name, "ST");
    expect(oneData[0].description, "ST DESC");
    expect(oneData[0].entryList.isEmpty, true);
  });

  test("Test JSON w/ 1 data point and examples", () async {
    List<DistrictData> oneData = await DataIntegration.generateDistrictData(
        normalisePath("res/test/json/districtData/test_one_example.json"),
        injectedBundle: testBundle);

    expect(oneData.length, 1);

    expect(oneData[0].name, "ST");
    expect(oneData[0].description, "ST DESC");
    expect(oneData[0].entryList.length, 1);

    DistrictDataEntry oneEntry = oneData[0].entryList[0];
    expect(oneEntry.goesTo, "STB");
    expect(oneEntry.generalInformation, "SingleTestData");
    expect(oneEntry.dataTitles.length, 2);
    expect(oneEntry.dataTitles[0], "SingleTest");
    expect(oneEntry.dataTitles[1], "DoubleTest");
  });

  test("Test JSON w/ 2 data point and examples", () async {
    List<DistrictData> oneData = await DataIntegration.generateDistrictData(
        normalisePath("res/test/json/districtData/test_two_example.json"),
        injectedBundle: testBundle);

    expect(oneData.length, 2);

    //First data point
    expect(oneData[0].name, "ST");
    expect(oneData[0].description, "ST DESC");
    expect(oneData[0].entryList.length, 2);

    {
      DistrictDataEntry oneEntry = oneData[0].entryList[0];
      expect(oneEntry.goesTo, "STB");
      expect(oneEntry.generalInformation, "SingleTestData");
      expect(oneEntry.dataTitles.length, 1);
      expect(oneEntry.dataTitles[0], "SingleTest");
    }
    {
      DistrictDataEntry oneEntry = oneData[0].entryList[1];
      expect(oneEntry.goesTo, "DTB");
      expect(oneEntry.generalInformation, "DoubleTestData");
      expect(oneEntry.dataTitles.length, 1);
      expect(oneEntry.dataTitles[0], "DoubleTest");
    }

    //Second data point
    expect(oneData[1].name, "DT");
    expect(oneData[1].description, "DT DESC");
    expect(oneData[1].entryList.length, 2);

    {
      DistrictDataEntry oneEntry = oneData[1].entryList[0];
      expect(oneEntry.goesTo, "DSTB");
      expect(oneEntry.generalInformation, "DualSingleTestData");
      expect(oneEntry.dataTitles.length, 1);
      expect(oneEntry.dataTitles[0], "SingleTest");
    }
    {
      DistrictDataEntry oneEntry = oneData[1].entryList[1];
      expect(oneEntry.goesTo, "DDTB");
      expect(oneEntry.generalInformation, "DualDoubleTestData");
      expect(oneEntry.dataTitles.length, 1);
      expect(oneEntry.dataTitles[0], "DoubleTest");
    }
  });
}
