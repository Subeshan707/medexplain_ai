// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportRequest _$ReportRequestFromJson(Map<String, dynamic> json) =>
    ReportRequest(
      mode: json['mode'] as String,
      language: json['language'] as String,
      reportText: json['report_text'] as String?,
      imageBase64: json['image_base64'] as String?,
      imageType: json['image_type'] as String?,
    );

Map<String, dynamic> _$ReportRequestToJson(ReportRequest instance) =>
    <String, dynamic>{
      'mode': instance.mode,
      'language': instance.language,
      'report_text': instance.reportText,
      'image_base64': instance.imageBase64,
      'image_type': instance.imageType,
    };
