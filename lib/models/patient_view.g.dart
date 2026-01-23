// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientView _$PatientViewFromJson(Map<String, dynamic> json) => PatientView(
  summary: json['summary'] as String,
  possibleMeaning:
      (json['possible_meaning'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  questionsForDoctor:
      (json['questions_for_doctor'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$PatientViewToJson(PatientView instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'possible_meaning': instance.possibleMeaning,
      'questions_for_doctor': instance.questionsForDoctor,
    };
