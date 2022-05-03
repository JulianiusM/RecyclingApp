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
        List<RecyclingData> indexList;
        if (indexMap.containsKey(example)) {
          indexList = indexMap[example]!;
        } else {
          indexList = [];
        }

        if (!indexList.contains(recData)) {
          indexList.add(recData);
        }

        indexMap.putIfAbsent(example, () => indexList);
      }

      List<RecyclingData> indexList;
      if (indexMap.containsKey(recData.title)) {
        indexList = indexMap[recData.title]!;
      } else {
        indexList = [];
      }

      if (!indexList.contains(recData)) {
        indexList.add(recData);
      }

      indexMap.putIfAbsent(recData.title, () => indexList);
    }
    return indexMap;
  }
}
