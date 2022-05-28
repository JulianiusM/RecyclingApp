// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'district_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistrictData _$DistrictDataFromJson(Map<String, dynamic> json) => DistrictData(
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      lat: (json['lat'] as num).toDouble(),
      long: (json['long'] as num).toDouble(),
      zoom: (json['zoom'] as num).toDouble(),
      hasAdditionalInformation: json['hasAdditionalInformation'] as bool,
      additionalInformation: (json['additionalInformation'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      entryList: (json['entryList'] as List<dynamic>)
          .map((e) => DistrictDataEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      locationList: (json['locationList'] as List<dynamic>)
          .map((e) => LocationData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DistrictDataToJson(DistrictData instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'lat': instance.lat,
      'long': instance.long,
      'zoom': instance.zoom,
      'hasAdditionalInformation': instance.hasAdditionalInformation,
      'additionalInformation': instance.additionalInformation,
      'entryList': instance.entryList.map((e) => e.toJson()).toList(),
      'locationList': instance.locationList.map((e) => e.toJson()).toList(),
    };
