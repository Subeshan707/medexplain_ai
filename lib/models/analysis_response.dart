import 'package:json_annotation/json_annotation.dart';
import 'patient_view.dart';
import 'clinician_view.dart';

part 'analysis_response.g.dart';

/// Image analysis details from Gemini Vision
@JsonSerializable()
class ImageDetails {
  @JsonKey(name: 'image_type')
  final String? imageType;
  
  @JsonKey(name: 'anatomical_region')
  final String? anatomicalRegion;
  
  @JsonKey(name: 'visible_structures')
  final List<String> visibleStructures;
  
  final List<String> observations;
  
  @JsonKey(name: 'image_quality')
  final String? imageQuality;
  
  ImageDetails({
    this.imageType,
    this.anatomicalRegion,
    this.visibleStructures = const [],
    this.observations = const [],
    this.imageQuality,
  });
  
  factory ImageDetails.fromJson(Map<String, dynamic> json) =>
      _$ImageDetailsFromJson(json);
  
  Map<String, dynamic> toJson() => _$ImageDetailsToJson(this);
}

/// Complete analysis response from n8n webhook
@JsonSerializable(explicitToJson: true)
class AnalysisResponse {
  /// Status of the analysis
  final String status;
  
  /// Whether red-flag findings were detected
  @JsonKey(name: 'red_flag')
  final bool redFlag;
  
  /// Whether this is an image analysis result
  @JsonKey(name: 'is_image_analysis')
  final bool isImageAnalysis;
  
  /// Image analysis details (only present for image analysis)
  @JsonKey(name: 'image_details')
  final ImageDetails? imageDetails;
  
  /// Patient-friendly explanation
  @JsonKey(name: 'patient_view')
  final PatientView patientView;
  
  /// Clinician-focused analysis
  @JsonKey(name: 'clinician_view')
  final ClinicianView clinicianView;
  
  /// Medical source citations
  final List<String> citations;
  
  /// Legal/medical disclaimer
  final String disclaimer;
  
  AnalysisResponse({
    required this.status,
    required this.redFlag,
    this.isImageAnalysis = false,
    this.imageDetails,
    required this.patientView,
    required this.clinicianView,
    this.citations = const [],
    required this.disclaimer,
  });
  
  factory AnalysisResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResponseFromJson(json);
  
  Map<String, dynamic> toJson() => _$AnalysisResponseToJson(this);
  
  /// Check if analysis was successful
  bool get isSuccess => status.toLowerCase() == 'success';
}
