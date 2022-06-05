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
        try {
          return loadFromFile(parts[0] + parts[1]);
        } on FileSystemException {
          //Second chance using production asset
        }
      }
    }

    try {
      return loadFromFile(key);
    } on FileSystemException {
      // Third chance using root bundle (e.g. for internal flutter assets)
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

  ByteData loadFromFile(String path) {
    File file = File(path);
    return ByteData.view(file.readAsBytesSync().buffer);
  }
}
