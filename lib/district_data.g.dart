// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistrictData _$DistrictDataFromJson(Map<String, dynamic> json) => DistrictData(
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      entryList: (json['entryList'] as List<dynamic>)
          .map((e) => DistrictDataEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DistrictDataToJson(DistrictData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'entryList': instance.entryList.map((e) => e.toJson()).toList(),
    };
