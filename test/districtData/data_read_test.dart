import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/data/district_data_entry.dart';
import 'package:recycling/data/location_data.dart';
import 'package:recycling/data/location_data_types.dart';
import 'package:recycling/logic/data_integration.dart';

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
    expect(oneData[0].imageUrl, "res/test/img/singleTest.jpg");
    expect(oneData[0].lat, 5.55);
    expect(oneData[0].long, 7.77);
    expect(oneData[0].zoom, 11.11);
    expect(oneData[0].hasAdditionalInformation, false);
    expect(oneData[0].additionalInformation, isEmpty);
    expect(oneData[0].entryList, isEmpty);
    expect(oneData[0].locationList, isEmpty);
  });

  test("Test JSON w/ 1 data point and examples", () async {
    List<DistrictData> oneData = await DataIntegration.generateDistrictData(
        normalisePath("res/test/json/districtData/test_one_example.json"),
        injectedBundle: testBundle);

    expect(oneData.length, 1);

    expect(oneData[0].name, "ST");
    expect(oneData[0].description, "ST DESC");
    expect(oneData[0].imageUrl, "res/test/img/singleTest.jpg");
    expect(oneData[0].lat, 5.55);
    expect(oneData[0].long, 7.77);
    expect(oneData[0].zoom, 11.11);
    expect(oneData[0].hasAdditionalInformation, true);
    expect(oneData[0].additionalInformation.length, 5);
    expect(oneData[0].additionalInformation[0], "Responsible city deputy:");
    expect(oneData[0].additionalInformation[1], "Mrs. Example");
    expect(oneData[0].additionalInformation[2], "Office for environment");
    expect(oneData[0].additionalInformation[3], "Examplestr. 4");
    expect(oneData[0].additionalInformation[4], "12345 ST");
    expect(oneData[0].entryList.length, 1);
    expect(oneData[0].locationList.length, 1);

    DistrictDataEntry oneEntry = oneData[0].entryList[0];
    expect(oneEntry.goesTo, "STB-B");
    expect(oneEntry.generalInformation, "SingleTestData");
    expect(oneEntry.imageUrl, "res/test/img/singleTest.jpg");
    expect(oneEntry.allowedExamples.length, 1);
    expect(oneEntry.allowedExamples[0], "ST_EXMPL_ALLOW");
    expect(oneEntry.disallowedExamples.length, 1);
    expect(oneEntry.disallowedExamples[0], "ST_EXMPL_DISALLOW");
    expect(oneEntry.dataTitles.length, 2);
    expect(oneEntry.dataTitles[0], "SingleTest");
    expect(oneEntry.dataTitles[1], "DoubleTest");

    LocationData oneLoc = oneData[0].locationList[0];
    expect(oneLoc.type, LocationDataType.recyclingCenter);
    expect(oneLoc.name, "WST");
    expect(oneLoc.description, "WSTD");
    expect(oneLoc.lat, 1.1);
    expect(oneLoc.long, 10.01);
  });

  test("Test JSON w/ 2 data point and examples", () async {
    List<DistrictData> oneData = await DataIntegration.generateDistrictData(
        normalisePath("res/test/json/districtData/test_two_example.json"),
        injectedBundle: testBundle);

    expect(oneData.length, 2);

    //First data point
    expect(oneData[0].name, "ST");
    expect(oneData[0].description, "ST DESC");
    expect(oneData[0].imageUrl, "res/test/img/singleTest.jpg");
    expect(oneData[0].lat, 5.55);
    expect(oneData[0].long, 7.77);
    expect(oneData[0].zoom, 11.11);
    expect(oneData[0].hasAdditionalInformation, true);
    expect(oneData[0].additionalInformation.length, 5);
    expect(oneData[0].additionalInformation[0], "Responsible city deputy:");
    expect(oneData[0].additionalInformation[1], "Mrs. Example");
    expect(oneData[0].additionalInformation[2], "Office for environment");
    expect(oneData[0].additionalInformation[3], "Examplestr. 4");
    expect(oneData[0].additionalInformation[4], "12345 ST");
    expect(oneData[0].entryList.length, 2);
    expect(oneData[0].locationList.length, 2);

    {
      DistrictDataEntry oneEntry = oneData[0].entryList[0];
      expect(oneEntry.goesTo, "STB-B");
      expect(oneEntry.generalInformation, "SingleTestData");
      expect(oneEntry.imageUrl, "res/test/img/singleTest.jpg");
      expect(oneEntry.allowedExamples.length, 1);
      expect(oneEntry.allowedExamples[0], "ST_EXMPL_ALLOW");
      expect(oneEntry.disallowedExamples.length, 1);
      expect(oneEntry.disallowedExamples[0], "ST_EXMPL_DISALLOW");
      expect(oneEntry.dataTitles.length, 1);
      expect(oneEntry.dataTitles[0], "SingleTest");
    }
    {
      DistrictDataEntry oneEntry = oneData[0].entryList[1];
      expect(oneEntry.goesTo, "DTB-B");
      expect(oneEntry.generalInformation, "DoubleTestData");
      expect(oneEntry.imageUrl, "res/test/img/doubleTest.jpg");
      expect(oneEntry.allowedExamples.length, 1);
      expect(oneEntry.allowedExamples[0], "ST_DOUBLE_ALLOW");
      expect(oneEntry.disallowedExamples.length, 1);
      expect(oneEntry.disallowedExamples[0], "ST_DOUBLE_DISALLOW");
      expect(oneEntry.dataTitles.length, 1);
      expect(oneEntry.dataTitles[0], "DoubleTest");
    }

    {
      LocationData oneLoc = oneData[0].locationList[0];
      expect(oneLoc.type, LocationDataType.recyclingCenter);
      expect(oneLoc.name, "WST");
      expect(oneLoc.description, "WSTD");
      expect(oneLoc.lat, 1.1);
      expect(oneLoc.long, 10.01);
    }
    {
      LocationData oneLoc = oneData[0].locationList[1];
      expect(oneLoc.type, LocationDataType.greenWaste);
      expect(oneLoc.name, "GWC");
      expect(oneLoc.description, "GWCD");
      expect(oneLoc.lat, 4.4);
      expect(oneLoc.long, 10.04);
    }

    //Second data point
    expect(oneData[1].name, "DT");
    expect(oneData[1].description, "DT DESC");
    expect(oneData[1].imageUrl, "res/test/img/doubleTest.jpg");
    expect(oneData[1].lat, 9.99);
    expect(oneData[1].long, 8.88);
    expect(oneData[1].zoom, 2.22);
    expect(oneData[1].hasAdditionalInformation, true);
    expect(oneData[1].additionalInformation.length, 5);
    expect(oneData[1].additionalInformation[0], "Responsible city deputy:");
    expect(oneData[1].additionalInformation[1], "Mr. Example");
    expect(oneData[1].additionalInformation[2], "Office for environment");
    expect(oneData[1].additionalInformation[3], "Examplestr. 7");
    expect(oneData[1].additionalInformation[4], "54321 DT");
    expect(oneData[1].entryList.length, 2);
    expect(oneData[1].locationList.length, 2);

    {
      DistrictDataEntry oneEntry = oneData[1].entryList[0];
      expect(oneEntry.goesTo, "DSTB-B");
      expect(oneEntry.generalInformation, "DualSingleTestData");
      expect(oneEntry.imageUrl, "res/test/img/singleTest.jpg");
      expect(oneEntry.allowedExamples.length, 1);
      expect(oneEntry.allowedExamples[0], "DST_EXMPL_ALLOW");
      expect(oneEntry.disallowedExamples.length, 1);
      expect(oneEntry.disallowedExamples[0], "DST_EXMPL_DISALLOW");
      expect(oneEntry.dataTitles.length, 1);
      expect(oneEntry.dataTitles[0], "SingleTest");
    }
    {
      DistrictDataEntry oneEntry = oneData[1].entryList[1];
      expect(oneEntry.goesTo, "DDTB-B");
      expect(oneEntry.generalInformation, "DualDoubleTestData");
      expect(oneEntry.imageUrl, "res/test/img/doubleTest.jpg");
      expect(oneEntry.allowedExamples.length, 1);
      expect(oneEntry.allowedExamples[0], "DST_DOUBLE_ALLOW");
      expect(oneEntry.disallowedExamples.length, 1);
      expect(oneEntry.disallowedExamples[0], "DST_DOUBLE_DISALLOW");
      expect(oneEntry.dataTitles.length, 1);
      expect(oneEntry.dataTitles[0], "DoubleTest");
    }

    {
      LocationData oneLoc = oneData[1].locationList[0];
      expect(oneLoc.type, LocationDataType.oldClothesContainer);
      expect(oneLoc.name, "WST-B");
      expect(oneLoc.description, "WSTD-B");
      expect(oneLoc.lat, 1.11);
      expect(oneLoc.long, 10.11);
    }
    {
      LocationData oneLoc = oneData[1].locationList[1];
      expect(oneLoc.type, LocationDataType.bioContainer);
      expect(oneLoc.name, "GWC-B");
      expect(oneLoc.description, "GWCD-B");
      expect(oneLoc.lat, 4.14);
      expect(oneLoc.long, 10.14);
    }
  });
}
