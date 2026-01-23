// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clinician_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClinicianView _$ClinicianViewFromJson(Map<String, dynamic> json) =>
    ClinicianView(
      findings:
          (json['findings'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      criticalValues:
          (json['critical_values'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      considerations:
          (json['considerations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ClinicianViewToJson(ClinicianView instance) =>
    <String, dynamic>{
      'findings': instance.findings,
      'critical_values': instance.criticalValues,
      'considerations': instance.considerations,
    };
