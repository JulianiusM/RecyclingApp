import 'package:json_annotation/json_annotation.dart';
import 'package:recycling/data/location_data_types.dart';

part 'location_data.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class LocationData {
  LocationData(
      {required this.type,
      required this.name,
      required this.description,
      required this.lat,
      required this.long});

  final LocationDataType type;
  final String name;
  final String description;
  final double lat;
  final double long;

  /// A necessary factory constructor for creating a new RecyclingData instance
  /// from a map. Pass the map to the generated `_$RecyclingDataFromJson()` constructor.
  /// The constructor is named after the source class, in this case, RecyclingData.
  factory LocationData.fromJson(Map<String, dynamic> json) =>
      _$LocationDataFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$RecyclingDataToJson`.
  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}
