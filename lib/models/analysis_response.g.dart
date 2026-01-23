// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageDetails _$ImageDetailsFromJson(Map<String, dynamic> json) => ImageDetails(
  imageType: json['image_type'] as String?,
  anatomicalRegion: json['anatomical_region'] as String?,
  visibleStructures:
      (json['visible_structures'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  observations:
      (json['observations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  imageQuality: json['image_quality'] as String?,
);

Map<String, dynamic> _$ImageDetailsToJson(ImageDetails instance) =>
    <String, dynamic>{
      'image_type': instance.imageType,
      'anatomical_region': instance.anatomicalRegion,
      'visible_structures': instance.visibleStructures,
      'observations': instance.observations,
      'image_quality': instance.imageQuality,
    };

AnalysisResponse _$AnalysisResponseFromJson(
  Map<String, dynamic> json,
) => AnalysisResponse(
  status: json['status'] as String,
  redFlag: json['red_flag'] as bool,
  isImageAnalysis: json['is_image_analysis'] as bool? ?? false,
  imageDetails: json['image_details'] == null
      ? null
      : ImageDetails.fromJson(json['image_details'] as Map<String, dynamic>),
  patientView: PatientView.fromJson(
    json['patient_view'] as Map<String, dynamic>,
  ),
  clinicianView: ClinicianView.fromJson(
    json['clinician_view'] as Map<String, dynamic>,
  ),
  citations:
      (json['citations'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  disclaimer: json['disclaimer'] as String,
);

Map<String, dynamic> _$AnalysisResponseToJson(AnalysisResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'red_flag': instance.redFlag,
      'is_image_analysis': instance.isImageAnalysis,
      'image_details': instance.imageDetails?.toJson(),
      'patient_view': instance.patientView.toJson(),
      'clinician_view': instance.clinicianView.toJson(),
      'citations': instance.citations,
      'disclaimer': instance.disclaimer,
    };
