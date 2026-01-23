import 'package:cloud_firestore/cloud_firestore.dart';
import 'analysis_response.dart';

/// Model for storing analysis history
class AnalysisHistory {
  final String id;
  final String userId;
  final String mode;
  final String reportText;
  final AnalysisResponse response;
  final DateTime timestamp;
  final String? reportPreview; // First 100 chars for display

  AnalysisHistory({
    required this.id,
    required this.userId,
    required this.mode,
    required this.reportText,
    required this.response,
    required this.timestamp,
    this.reportPreview,
  });

  /// Create from Firestore document
  factory AnalysisHistory.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AnalysisHistory(
      id: doc.id,
      userId: data['userId'] ?? '',
      mode: data['mode'] ?? 'patient',
      reportText: data['reportText'] ?? '',
      response: AnalysisResponse.fromJson(data['response'] ?? {}),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      reportPreview: data['reportPreview'],
    );
  }

  /// Convert to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'mode': mode,
      'reportText': reportText,
      'response': response.toJson(),
      'timestamp': Timestamp.fromDate(timestamp),
      'reportPreview': reportPreview ?? reportText.substring(0, reportText.length > 100 ? 100 : reportText.length),
    };
  }
}
