import 'package:json_annotation/json_annotation.dart';
import 'package:recycling/district_data_entry.dart';

part 'district_data.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class DistrictData {
  DistrictData(
      {required this.name,
      required this.description,
      required this.imageUrl,
      required this.entryList});

  final String name;
  final String description;
  final String imageUrl;
  final List<DistrictDataEntry> entryList;

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
