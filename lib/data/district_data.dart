import 'package:json_annotation/json_annotation.dart';
import 'package:recycling/data/district_data_entry.dart';
import 'package:recycling/data/location_data.dart';

part 'district_data.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class DistrictData {
  DistrictData(
      {required this.name,
      required this.description,
      required this.imageUrl,
      required this.lat,
      required this.long,
      // required this.opens,
      // required this.closes,
      required this.zoom,
      required this.hasAdditionalInformation,
      required this.additionalInformation,
      required this.entryList,
      required this.locationList});

  final String name;
  final String description;
  final String imageUrl;
  final double lat;
  final double long;
  final double zoom;
  // final String opens;
  // final String closes;
  final bool hasAdditionalInformation;
  final List<String> additionalInformation;
  final List<DistrictDataEntry> entryList;
  final List<LocationData> locationList;

  /// A necessary factory constructor for creating a new RecyclingData instance
  /// from a map. Pass the map to the generated `_$RecyclingDataFromJson()` constructor.
  /// The constructor is named after the source class, in this case, RecyclingData.
  factory DistrictData.fromJson(Map<String, dynamic> json) =>
      _$DistrictDataFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$RecyclingDataToJson`.
  Map<String, dynamic> toJson() => _$DistrictDataToJson(this);
}
