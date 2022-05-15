import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data_integration.dart';
import 'package:recycling/recycling_data.dart';

import 'util/test_asset_bundle.dart';
import 'util/test_utils.dart';

void main() async {
  // Setup index
  AssetBundle testBundle = TestAssetBundle();
  List<RecyclingData> oneData = await DataIntegration.generateRecyclingData(
      normalisePath("res/test/json/test_splitting.json"),
      injectedBundle: testBundle);
  Map<String, List<RecyclingData>> dataIndex =
      DataIntegration.generateRuntimeIndex(oneData);

  test("Test searching for simple title", () async {
    List<RecyclingData> result =
        DataIntegration.performSearchOnIndex(dataIndex, "Single Test");
    expect(result.length, 1);
    expect(result[0].title, "Single Test");
  });

  test("Test searching for simple partial title", () async {
    List<RecyclingData> result =
        DataIntegration.performSearchOnIndex(dataIndex, "Double Test");
    expect(result.length, 1);
    expect(result[0].title, "Double Test Test");
  });

  test("Test searching for ambiguous partial title", () async {
    List<RecyclingData> result =
        DataIntegration.performSearchOnIndex(dataIndex, "Test");
    expect(result.length, 2);

    List<String> titleData = result.map((e) => e.title).toList();
    expect(titleData.contains("Double Test Test"), true);
    expect(titleData.contains("Single Test"), true);
  });

  test("Test searching for simple example", () async {
    List<RecyclingData> result =
        DataIntegration.performSearchOnIndex(dataIndex, "Example2 Wine");
    expect(result.length, 1);
    expect(result[0].title, "Single Test");
  });

  test("Test searching for simple partial example", () async {
    List<RecyclingData> result =
        DataIntegration.performSearchOnIndex(dataIndex, "Example2");
    expect(result.length, 1);
    expect(result[0].title, "Single Test");
  });

  test("Test searching for ambiguous partial example", () async {
    List<RecyclingData> result =
        DataIntegration.performSearchOnIndex(dataIndex, "Wine");
    expect(result.length, 2);

    List<String> titleData = result.map((e) => e.title).toList();
    expect(titleData.contains("Double Test Test"), true);
    expect(titleData.contains("Single Test"), true);
  });
}
