// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
      type: $enumDecode(_$LocationDataTypeEnumMap, json['type']),
      name: json['name'] as String,
      description: json['description'] as String,
      lat: (json['lat'] as num).toDouble(),
      long: (json['long'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationDataToJson(LocationData instance) =>
    <String, dynamic>{
      'type': _$LocationDataTypeEnumMap[instance.type],
      'name': instance.name,
      'description': instance.description,
      'lat': instance.lat,
      'long': instance.long,
    };

const _$LocationDataTypeEnumMap = {
  LocationDataType.recyclingCenter: 'recyclingCenter',
  LocationDataType.bioContainer: 'bioContainer',
  LocationDataType.glassContainer: 'glassContainer',
  LocationDataType.greenWaste: 'greenWaste',
  LocationDataType.oldClothesContainer: 'oldClothesContainer',
};
