import 'package:json_annotation/json_annotation.dart';

part 'patient_view.g.dart';

/// Patient-friendly view of medical report analysis
@JsonSerializable()
class PatientView {
  /// Simple, reassuring summary in 8th-grade language
  final String summary;
  
  /// Array of possible meanings (non-diagnostic)
  @JsonKey(name: 'possible_meaning')
  final List<String> possibleMeaning;
  
  /// Questions patient should ask their doctor
  @JsonKey(name: 'questions_for_doctor')
  final List<String> questionsForDoctor;
  
  PatientView({
    required this.summary,
    this.possibleMeaning = const [],
    this.questionsForDoctor = const [],
  });
  
  factory PatientView.fromJson(Map<String, dynamic> json) =>
      _$PatientViewFromJson(json);
  
  Map<String, dynamic> toJson() => _$PatientViewToJson(this);
}
