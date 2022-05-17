// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_data_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistrictDataEntry _$DistrictDataEntryFromJson(Map<String, dynamic> json) =>
    DistrictDataEntry(
      goesTo: json['goesTo'] as String,
      generalInformation: json['generalInformation'] as String,
      dataTitles: (json['dataTitles'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DistrictDataEntryToJson(DistrictDataEntry instance) =>
    <String, dynamic>{
      'goesTo': instance.goesTo,
      'generalInformation': instance.generalInformation,
      'dataTitles': instance.dataTitles,
    };
