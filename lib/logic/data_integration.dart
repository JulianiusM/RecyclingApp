import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fuzzy/fuzzy.dart';
import 'package:recycling/data/district_data_entry.dart';
import 'package:recycling/data/location_data.dart';

import '../data/district_data.dart';
import '../data/recycling_data.dart';

class DataIntegration {
  static Future<List<RecyclingData>> generateRecyclingData(String path,
      {BuildContext? context, AssetBundle? injectedBundle}) async {
    AssetBundle bundle;
    if (injectedBundle != null) {
      bundle = injectedBundle;
    } else if (context != null) {
      bundle = DefaultAssetBundle.of(context);
    } else {
      bundle = rootBundle;
    }

    List<RecyclingData> data = [];
    for (RecyclingData recData
        in (json.decode(await bundle.loadString(path)) as List)
            .map((i) => RecyclingData.fromJson(i))) {
      data.add(recData);
    }
    return data;
  }

  static Map<String, List<RecyclingData>> generateRuntimeIndex(
      List<RecyclingData> data) {
    Map<String, List<RecyclingData>> indexMap = {};
    for (RecyclingData recData in data) {
      for (String example in recData.exampleData) {
        _indexPerformSplit(indexMap, example, recData);
      }
      _indexPerformSplit(indexMap, recData.title, recData);
    }
    return indexMap;
  }

  static void _indexAddToMap(Map<String, List<RecyclingData>> indexMap,
      String key, RecyclingData recData) {
    List<RecyclingData> indexList;
    if (indexMap.containsKey(key)) {
      indexList = indexMap[key]!;
    } else {
      indexList = [];
    }

    if (!indexList.contains(recData)) {
      indexList.add(recData);
    }

    indexMap.putIfAbsent(key, () => indexList);
  }

  static void _indexPerformSplit(Map<String, List<RecyclingData>> indexMap,
      String key, RecyclingData recData) {
    List<String> keyParts = key.split(" ");
    for (int i = 0; i < keyParts.length; i++) {
      for (int j = 0; j < keyParts.length - i; j++) {
        String currentKey = "";
        for (int k = j; k <= j + i; k++) {
          currentKey += " ${keyParts[k]}";
        }
        currentKey = currentKey.trim();
        _indexAddToMap(indexMap, currentKey, recData);
      }
    }
  }

  static List<RecyclingData> performSearchOnIndex(
      Map<String, List<RecyclingData>> index, String pattern) {
    final fuzzy = Fuzzy(
      index.keys.toList(),
      options: FuzzyOptions(
        threshold: 0.3,
      ),
    );

    final results = fuzzy.search(pattern);

    List<RecyclingData> returnList = [];
    for (String key in results.map((e) => e.item)) {
      for (RecyclingData recData in index[key]!) {
        if (!returnList.contains(recData)) {
          returnList.add(recData);
        }
      }
    }

    return returnList;
  }

  static Future<List<DistrictData>> generateDistrictData(String path,
      {BuildContext? context, AssetBundle? injectedBundle}) async {
    AssetBundle bundle;
    if (injectedBundle != null) {
      bundle = injectedBundle;
    } else if (context != null) {
      bundle = DefaultAssetBundle.of(context);
    } else {
      bundle = rootBundle;
    }

    List<DistrictData> data = [];
    for (DistrictData recData
        in (json.decode(await bundle.loadString(path)) as List)
            .map((i) => DistrictData.fromJson(i))) {
      data.add(recData);
    }
    return data;
  }

  static List<RecyclingData> mergeRecyclingDistrictData(
      List<RecyclingData> recData, List<DistrictDataEntry> distData) {
    List<RecyclingData> data = [];
    Map<String, DistrictDataEntry> distMap =
        _mergeRecDistDataGenerateDistrictMap(distData);

    for (RecyclingData rData in recData) {
      DistrictDataEntry? dde = distMap[rData.title];
      if (dde != null) {
        data.add(rData.copyWith(goesTo: dde.goesTo));
      }
    }

    return data;
  }

  static Map<String, DistrictDataEntry> _mergeRecDistDataGenerateDistrictMap(
      List<DistrictDataEntry> distData) {
    Map<String, DistrictDataEntry> map = {};

    for (DistrictDataEntry dde in distData) {
      for (String title in dde.dataTitles) {
        if (map.containsKey(title)) {
          throw Exception(
              "Unique mapping failed: Duplicate entry $title in $dde");
        }

        map.putIfAbsent(title, () => dde);
      }
    }

    return map;
  }

  static Future<List<LocationData>> generateLocationData(String path,
      {BuildContext? context, AssetBundle? injectedBundle}) async {
    AssetBundle bundle;
    if (injectedBundle != null) {
      bundle = injectedBundle;
    } else if (context != null) {
      bundle = DefaultAssetBundle.of(context);
    } else {
      bundle = rootBundle;
    }

    List<LocationData> data = [];
    for (LocationData recData
        in (json.decode(await bundle.loadString(path)) as List)
            .map((i) => LocationData.fromJson(i))) {
      data.add(recData);
    }
    return data;
  }
}
