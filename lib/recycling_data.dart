import 'package:json_annotation/json_annotation.dart';

part 'recycling_data.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable()
class RecyclingData {
  RecyclingData(
      {required this.generalInformation,
      required this.imageUrl,
      required this.exampleData});

  final String generalInformation;
  final String imageUrl;
  final List<String> exampleData;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory RecyclingData.fromJson(Map<String, dynamic> json) =>
      _$RecyclingDataFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RecyclingDataToJson(this);
}
