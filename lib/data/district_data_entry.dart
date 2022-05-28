import 'package:json_annotation/json_annotation.dart';
import 'package:recycling/data/data_access_interface.dart';

part 'district_data_entry.g.dart';

/// An annotation for the code generator to know that this class needs the
/// JSON serialization logic to be generated.
@JsonSerializable(explicitToJson: true)
class DistrictDataEntry implements DataAccessInterface {
  DistrictDataEntry(
      {required this.goesTo,
      required this.generalInformation,
      required this.imageUrl,
      required this.allowedExamples,
      required this.disallowedExamples,
      required this.dataTitles});

  final String goesTo;
  final String generalInformation;
  final String imageUrl;
  final List<String> allowedExamples;
  final List<String> disallowedExamples;
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

  @override
  List<String> getExamples() {
    return allowedExamples;
  }

  @override
  String getId() {
    return goesTo;
  }

  @override
  String getDescription() {
    return generalInformation;
  }

  @override
  String getImagePath() {
    return imageUrl;
  }
}
