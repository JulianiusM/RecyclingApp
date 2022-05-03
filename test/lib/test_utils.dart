import 'dart:io';

String normalisePath(String name) {
  var dir = Directory.current.path;
  if (dir.endsWith('/test')) {
    dir = dir.replaceAll('/test', '');
  }
  return '$dir/$name';
}
