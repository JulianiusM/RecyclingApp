// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recycling_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecyclingData _$RecyclingDataFromJson(Map<String, dynamic> json) =>
    RecyclingData(
      generalInformation: json['generalInformation'] as String,
      imageUrl: json['imageUrl'] as String,
      exampleData: (json['exampleData'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RecyclingDataToJson(RecyclingData instance) =>
    <String, dynamic>{
      'generalInformation': instance.generalInformation,
      'imageUrl': instance.imageUrl,
      'exampleData': instance.exampleData,
    };
