import 'package:sprintf/sprintf.dart';

extension StringFormatExtension on String {
  String format(List<String> arguments) => sprintf(this, arguments);
}
