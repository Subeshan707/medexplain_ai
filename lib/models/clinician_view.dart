import 'package:json_annotation/json_annotation.dart';

part 'clinician_view.g.dart';

/// Clinician-focused view of medical report analysis
@JsonSerializable()
class ClinicianView {
  /// Bullet-point key findings
  final List<String> findings;
  
  /// Critical or abnormal values highlighted
  @JsonKey(name: 'critical_values')
  final List<String> criticalValues;
  
  /// Non-prescriptive clinical considerations/next steps
  final List<String> considerations;
  
  ClinicianView({
    this.findings = const [],
    this.criticalValues = const [],
    this.considerations = const [],
  });
  
  factory ClinicianView.fromJson(Map<String, dynamic> json) =>
      _$ClinicianViewFromJson(json);
  
  Map<String, dynamic> toJson() => _$ClinicianViewToJson(this);
}
