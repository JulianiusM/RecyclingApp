import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/data/recycling_data.dart';
import 'package:recycling/logic/data_integration.dart';

import 'util/test_asset_bundle.dart';
import 'util/test_utils.dart';

void main() {
  TestAssetBundle testBundle = TestAssetBundle();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test("Test english waste data integrity", () async {
    List<RecyclingData> emptyData = await DataIntegration.generateRecyclingData(
        normalisePath("res/json/en/data.json"),
        injectedBundle: testBundle);

    expect(emptyData, isNotEmpty);
  });

  test("Test german waste data integrity", () async {
    List<RecyclingData> emptyData = await DataIntegration.generateRecyclingData(
        normalisePath("res/json/de/data.json"),
        injectedBundle: testBundle);

    expect(emptyData, isNotEmpty);
  });

  test("Test english district data integrity", () async {
    List<DistrictData> emptyData = await DataIntegration.generateDistrictData(
        normalisePath("res/json/en/districtData.json"),
        injectedBundle: testBundle);

    expect(emptyData, isNotEmpty);
  });

  test("Test german district data integrity", () async {
    List<DistrictData> emptyData = await DataIntegration.generateDistrictData(
        normalisePath("res/json/de/districtData.json"),
        injectedBundle: testBundle);

    expect(emptyData, isNotEmpty);
  });
}
