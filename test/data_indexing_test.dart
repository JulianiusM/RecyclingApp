import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recycling/data_integration.dart';
import 'package:recycling/recycling_data.dart';

import 'lib/test_asset_bundle.dart';
import 'lib/test_utils.dart';

void main() {
  AssetBundle testBundle = TestAssetBundle();

  test("Test indexing of empty data", () async {
    Map<String, RecyclingData> oneDataMap =
        await DataIntegration.generateRecyclingData(
            normalisePath("res/test/json/test_empty.json"),
            injectedBundle: testBundle);

    Map<String, List<RecyclingData>> dataIndex =
        DataIntegration.generateRuntimeIndex(oneDataMap.values.toList());

    expect(dataIndex.isEmpty, true);
  });

  test("Test indexing of one data point w/o examples", () async {
    Map<String, RecyclingData> oneDataMap =
        await DataIntegration.generateRecyclingData(
            normalisePath("res/test/json/test_one.json"),
            injectedBundle: testBundle);

    Map<String, List<RecyclingData>> dataIndex =
        DataIntegration.generateRuntimeIndex(oneDataMap.values.toList());

    expect(dataIndex.length, 1);

    expect(dataIndex.containsKey("SingleTest"), true);
    List<RecyclingData> singleData = dataIndex["SingleTest"]!;
    expect(singleData.length, 1);
    expect(singleData[0].title, "SingleTest");
  });

  test("Test indexing of one data point w/ examples", () async {
    Map<String, RecyclingData> oneDataMap =
        await DataIntegration.generateRecyclingData(
            normalisePath("res/test/json/test_one_example.json"),
            injectedBundle: testBundle);

    Map<String, List<RecyclingData>> dataIndex =
        DataIntegration.generateRuntimeIndex(oneDataMap.values.toList());

    expect(dataIndex.length, 3);

    // Test if all titles are included in index
    expect(dataIndex.containsKey("SingleTest"), true);

    // Test if all examples are included in index
    expect(dataIndex.containsKey("EX1"), true);
    expect(dataIndex.containsKey("EX2"), true);

    // Test if titles have correct data references
    List<RecyclingData> singleData = dataIndex["SingleTest"]!;
    expect(singleData.length, 1);
    expect(singleData[0].title, "SingleTest");

    // Test if examples have correct data references
    List<RecyclingData> ex1 = dataIndex["EX1"]!;
    expect(ex1.length, 1);
    expect(ex1[0].title, "SingleTest");

    List<RecyclingData> ex2 = dataIndex["EX2"]!;
    expect(ex2.length, 1);
    expect(ex2[0].title, "SingleTest");
  });

  test("Test indexing of two data points w/ examples", () async {
    Map<String, RecyclingData> oneDataMap =
        await DataIntegration.generateRecyclingData(
            normalisePath("res/test/json/test_two_example.json"),
            injectedBundle: testBundle);

    Map<String, List<RecyclingData>> dataIndex =
        DataIntegration.generateRuntimeIndex(oneDataMap.values.toList());

    expect(dataIndex.length, 5);

    // Test if all titles are included in index
    expect(dataIndex.containsKey("SingleTest"), true);
    expect(dataIndex.containsKey("DoubleTest"), true);
    expect(dataIndex.containsKey("TripleTest"), false);

    // Test if all examples are included in index
    expect(dataIndex.containsKey("EX1"), true);
    expect(dataIndex.containsKey("EX2"), true);
    expect(dataIndex.containsKey("EX3"), true);
    expect(dataIndex.containsKey("EX4"), false);

    // Test if titles have correct data references
    List<RecyclingData> singleData = dataIndex["SingleTest"]!;
    expect(singleData.length, 1);
    expect(singleData[0].title, "SingleTest");

    List<RecyclingData> doubleData = dataIndex["DoubleTest"]!;
    expect(doubleData.length, 1);
    expect(doubleData[0].title, "DoubleTest");

    // Test if examples have correct data references
    List<RecyclingData> ex1 = dataIndex["EX1"]!;
    expect(ex1.length, 2);
    expect(ex1.map((e) => e.title).contains("SingleTest"), true);
    expect(ex1.map((e) => e.title).contains("DoubleTest"), true);

    List<RecyclingData> ex2 = dataIndex["EX2"]!;
    expect(ex2.length, 1);
    expect(ex2[0].title, "SingleTest");

    List<RecyclingData> ex3 = dataIndex["EX3"]!;
    expect(ex3.length, 1);
    expect(ex3[0].title, "DoubleTest");
  });
}
