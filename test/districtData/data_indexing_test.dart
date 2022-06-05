import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data/data_access_interface.dart';
import 'package:recycling/data/district_data.dart';
import 'package:recycling/logic/data_integration.dart';

import '../util/test_asset_bundle.dart';
import '../util/test_utils.dart';

void main() {
  AssetBundle testBundle = TestAssetBundle();

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  test("Test indexing of one data point w/o examples", () async {
    List<DistrictData> oneData = await DataIntegration.generateDistrictData(
        normalisePath("res/test/json/districtData/test_one.json"),
        injectedBundle: testBundle);

    Map<String, List<DataAccessInterface>> dataIndex =
        DataIntegration.generateRuntimeIndex(oneData.first.entryList);

    expect(dataIndex, isEmpty);
  });

  test("Test indexing of one data point w/ examples", () async {
    List<DistrictData> oneData = await DataIntegration.generateDistrictData(
        normalisePath("res/test/json/districtData/test_one_example.json"),
        injectedBundle: testBundle);

    Map<String, List<DataAccessInterface>> dataIndex =
        DataIntegration.generateRuntimeIndex(oneData.first.entryList);

    expect(dataIndex.length, 2);

    // Test if all titles are included in index
    expect(dataIndex.containsKey("STB-B"), true);

    // Test if all examples are included in index
    expect(dataIndex.containsKey("ST_EXMPL_ALLOW"), true);

    // Test if titles have correct data references
    List<DataAccessInterface> singleData = dataIndex["STB-B"]!;
    expect(singleData.length, 1);
    expect(singleData[0].getId(), "STB-B");

    // Test if examples have correct data references
    List<DataAccessInterface> ex1 = dataIndex["ST_EXMPL_ALLOW"]!;
    expect(ex1.length, 1);
    expect(ex1[0].getId(), "STB-B");
  });

  test("Test indexing of two data points w/ examples", () async {
    List<DistrictData> oneData = await DataIntegration.generateDistrictData(
        normalisePath("res/test/json/districtData/test_two_example.json"),
        injectedBundle: testBundle);

    Map<String, List<DataAccessInterface>> dataIndex =
        DataIntegration.generateRuntimeIndex(oneData.first.entryList);

    expect(dataIndex.length, 4);

    // Test if all titles are included in index
    expect(dataIndex.containsKey("STB-B"), true);
    expect(dataIndex.containsKey("DTB-B"), true);

    // Test if all examples are included in index
    expect(dataIndex.containsKey("ST_EXMPL_ALLOW"), true);
    expect(dataIndex.containsKey("ST_DOUBLE_ALLOW"), true);

    // Test if titles have correct data references
    List<DataAccessInterface> singleData = dataIndex["STB-B"]!;
    expect(singleData.length, 1);
    expect(singleData[0].getId(), "STB-B");

    List<DataAccessInterface> doubleData = dataIndex["DTB-B"]!;
    expect(doubleData.length, 1);
    expect(doubleData[0].getId(), "DTB-B");

    // Test if examples have correct data references
    List<DataAccessInterface> ex1 = dataIndex["ST_EXMPL_ALLOW"]!;
    expect(ex1.length, 1);
    expect(ex1[0].getId(), "STB-B");

    List<DataAccessInterface> ex2 = dataIndex["ST_DOUBLE_ALLOW"]!;
    expect(ex2.length, 1);
    expect(ex2[0].getId(), "DTB-B");
  });
}
