import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recycling/recycling_data.dart';

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

    List<RecyclingData> data =
        (json.decode(await bundle.loadString(path)) as List)
            .map((i) => RecyclingData.fromJson(i))
            .toList(growable: true);
    return data;
  }
}
