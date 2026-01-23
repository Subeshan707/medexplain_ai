import 'package:intl/intl.dart';

class AnalysisStats {
  final Map<String, double> metrics;

  AnalysisStats(this.metrics);

  factory AnalysisStats.fromText(String text) {
    final Map<String, double> extracted = {};

    // Common Regex patterns for blood work
    // Matches "Name: Value" or "Name Value"
    final patterns = {
      'Total Cholesterol': RegExp(r'Total Cholesterol\D+([\d\.]+)'),
      'LDL': RegExp(r'LDL\D+([\d\.]+)'),
      'HDL': RegExp(r'HDL\D+([\d\.]+)'),
      'Triglycerides': RegExp(r'Triglycerides\D+([\d\.]+)'),
      'Glucose': RegExp(r'Glucose\D+([\d\.]+)'),
      'HbA1c': RegExp(r'HbA1c\D+([\d\.]+)'),
      'Hemoglobin': RegExp(r'Hemoglobin\D+([\d\.]+)'),
      'Platelets': RegExp(r'Platelets\D+([\d\.]+)'),
      'WBC': RegExp(r'WBC\D+([\d\.]+)'),
      'RBC': RegExp(r'RBC\D+([\d\.]+)'),
    };

    for (var entry in patterns.entries) {
      final match = entry.value.firstMatch(text);
      if (match != null && match.groupCount >= 1) {
        final valStr = match.group(1);
        if (valStr != null) {
          final val = double.tryParse(valStr);
          if (val != null) {
            extracted[entry.key] = val;
          }
        }
      }
    }

    // Heuristics: if we didn't find specific labels, maybe we can try to guess based on context?
    // For now, let's stick to these patterns.
    
    return AnalysisStats(extracted);
  }

  bool get isEmpty => metrics.isEmpty;
  bool get isNotEmpty => metrics.isNotEmpty;
  
  double? getValue(String key) => metrics[key];
}
