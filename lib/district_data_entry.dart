import 'package:json_annotation/json_annotation.dart';

part 'district_data_entry.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class DistrictDataEntry {
  DistrictDataEntry(
      {required this.goesTo,
      required this.generalInformation,
      required this.dataTitles});

  final String goesTo;
  final String generalInformation;
  final List<String> dataTitles;

  /// A necessary factory constructor for creating a new RecyclingData instance
  /// from a map. Pass the map to the generated `_$RecyclingDataFromJson()` constructor.
  /// The constructor is named after the source class, in this case, RecyclingData.
  factory DistrictDataEntry.fromJson(Map<String, dynamic> json) =>
      _$DistrictDataEntryFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$RecyclingDataToJson`.
  Map<String, dynamic> toJson() => _$DistrictDataEntryToJson(this);
}
