import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycling/recycling_data.dart';

class DataIntegration {
  static Future<Map<String, RecyclingData>> generateRecyclingData(String path,
      {BuildContext? context, AssetBundle? injectedBundle}) async {
    AssetBundle bundle;
    if (injectedBundle != null) {
      bundle = injectedBundle;
    } else if (context != null) {
      bundle = DefaultAssetBundle.of(context);
    } else {
      bundle = rootBundle;
    }

    Map<String, RecyclingData> data = {
      for (RecyclingData recData
          in (json.decode(await bundle.loadString(path)) as List)
              .map((i) => RecyclingData.fromJson(i)))
        recData.title: recData
    };
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
}
