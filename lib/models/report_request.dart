import 'package:json_annotation/json_annotation.dart';

part 'report_request.g.dart';

/// Request model for sending report analysis to n8n webhook
@JsonSerializable()
class ReportRequest {
  /// Analysis mode: 'patient' or 'clinician'
  final String mode;
  
  /// Language code (e.g., 'en')
  final String language;
  
  /// The medical report text content (optional if image is provided)
  @JsonKey(name: 'report_text')
  final String? reportText;
  
  /// Base64 encoded image data for medical image analysis
  @JsonKey(name: 'image_base64')
  final String? imageBase64;
  
  /// Type of medical image: ct_scan, xray, mri, ultrasound
  @JsonKey(name: 'image_type')
  final String? imageType;
  
  ReportRequest({
    required this.mode,
    required this.language,
    this.reportText,
    this.imageBase64,
    this.imageType,
  }) : assert(reportText != null || imageBase64 != null, 
              'Either reportText or imageBase64 must be provided');
  
  factory ReportRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportRequestFromJson(json);
  
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      'mode': mode,
      'language': language,
    };
    
    // Only include non-null fields
    if (reportText != null) {
      json['report_text'] = reportText;
    }
    if (imageBase64 != null) {
      json['image_base64'] = imageBase64;
    }
    if (imageType != null) {
      json['image_type'] = imageType;
    }
    
    return json;
  }
  
  /// Check if this is an image analysis request
  bool get isImageAnalysis => imageBase64 != null && imageBase64!.isNotEmpty;
}
