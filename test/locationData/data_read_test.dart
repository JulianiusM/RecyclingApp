import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data/location_data.dart';
import 'package:recycling/data/location_data_types.dart';
import 'package:recycling/logic/data_integration.dart';

import '../util/test_asset_bundle.dart';
import '../util/test_utils.dart';

void main() {
  AssetBundle testBundle = TestAssetBundle();

  test("Test empty JSON", () async {
    List<LocationData> emptyData = await DataIntegration.generateLocationData(
        normalisePath("res/test/json/locationData/test_empty.json"),
        injectedBundle: testBundle);

    expect(emptyData.isEmpty, true);
  });

  test("Test JSON w/ 1 data point", () async {
    List<LocationData> oneData = await DataIntegration.generateLocationData(
        normalisePath("res/test/json/locationData/test_one.json"),
        injectedBundle: testBundle);

    expect(oneData.length, 1);

    expect(oneData[0].type, LocationDataType.recyclingCenter);
    expect(oneData[0].name, "WST");
    expect(oneData[0].description, "WSTD");
    expect(oneData[0].lat, 1.1);
    expect(oneData[0].long, 10.01);
  });

  test("Test JSON w/ all types", () async {
    List<LocationData> oneData = await DataIntegration.generateLocationData(
        normalisePath("res/test/json/locationData/test_all_types.json"),
        injectedBundle: testBundle);

    expect(oneData.length, LocationDataType.values.length);

    expect(oneData[0].type, LocationDataType.recyclingCenter);
    expect(oneData[0].name, "WST");
    expect(oneData[0].description, "WSTD");
    expect(oneData[0].lat, 1.1);
    expect(oneData[0].long, 10.01);

    expect(oneData[1].type, LocationDataType.bioContainer);
    expect(oneData[1].name, "BWC");
    expect(oneData[1].description, "BWCD");
    expect(oneData[1].lat, 2.2);
    expect(oneData[1].long, 10.02);

    expect(oneData[2].type, LocationDataType.glassContainer);
    expect(oneData[2].name, "GLC");
    expect(oneData[2].description, "GLCD");
    expect(oneData[2].lat, 3.3);
    expect(oneData[2].long, 10.03);

    expect(oneData[3].type, LocationDataType.greenWaste);
    expect(oneData[3].name, "GWC");
    expect(oneData[3].description, "GWCD");
    expect(oneData[3].lat, 4.4);
    expect(oneData[3].long, 10.04);

    expect(oneData[4].type, LocationDataType.oldClothesContainer);
    expect(oneData[4].name, "OCC");
    expect(oneData[4].description, "OCCD");
    expect(oneData[4].lat, 5.5);
    expect(oneData[4].long, 10.05);
  });
}
