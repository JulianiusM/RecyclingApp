import 'dart:io';

import 'package:flutter/services.dart';

class TestAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    List<String> parts;

    //Handle absolute and relative resource paths
    if (key.startsWith("res/")) {
      parts = ["res/", key.replaceFirst("res/", "")];
    } else {
      parts = key.split("/res/");
      parts[0] = parts[0] + "/res/";
    }

    //Try to get test asset instead of production asset
    if (parts.length == 2) {
      parts[1] = rewriteToTestPath(parts[1]);

      if (parts[1].startsWith("test/")) {
        File file = File(parts[0] + parts[1]);
        try {
          return ByteData.view(file.readAsBytesSync().buffer);
        } on FileSystemException {
          //Second chance using production asset
        }
      }
    }
    return rootBundle.load(key);
  }

  //Rewrite logic to map production assets to test assets
  String rewriteToTestPath(String path) {
    if (path.startsWith("json")) {
      path = path.replaceFirst("json", "test/json");
    }

    return path;
  }
}
