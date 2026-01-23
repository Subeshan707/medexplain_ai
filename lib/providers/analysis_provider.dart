import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analysis_response.dart';
import '../models/report_request.dart';
import '../services/api_service.dart';

/// Analysis state
class AnalysisState {
  final bool isLoading;
  final AnalysisResponse? response;
  final String? error;
  final String? reportText;
  final bool isImageAnalysis;
  
  AnalysisState({
    this.isLoading = false,
    this.response,
    this.error,
    this.reportText,
    this.isImageAnalysis = false,
  });
  
  AnalysisState copyWith({
    bool? isLoading,
    AnalysisResponse? response,
    String? error,
    String? reportText,
    bool? isImageAnalysis,
  }) {
    return AnalysisState(
      isLoading: isLoading ?? this.isLoading,
      response: response ?? this.response,
      error: error,
      reportText: reportText ?? this.reportText,
      isImageAnalysis: isImageAnalysis ?? this.isImageAnalysis,
    );
  }
  
  bool get hasResponse => response != null;
  bool get hasError => error != null;
}

/// Analysis provider notifier
class AnalysisNotifier extends StateNotifier<AnalysisState> {
  final ApiService _apiService;
  
  AnalysisNotifier(this._apiService) : super(AnalysisState());
  
  /// Analyze text report
  Future<void> analyzeReport({
    required String reportText,
    required String mode,
    required String language,
  }) async {
    print('DEBUG PROVIDER: analyzeReport called');
    state = AnalysisState(isLoading: true, reportText: reportText, isImageAnalysis: false);
    
    try {
      String finalReportText = reportText;
      
      // Add language instruction
      String languageInstruction = '';
      if (language == 'ta') {
        languageInstruction = 'IMPORTANT: Please respond ENTIRELY in Tamil (தமிழ்). All text in your response must be in Tamil language.\n\n';
      } else if (language != 'en') {
        languageInstruction = 'IMPORTANT: Please respond in the language code: $language.\n\n';
      }
      
      // Inject technical instruction for Clinician Mode
      if (mode == 'clinician') {
        finalReportText = "${languageInstruction}INSTRUCTION FOR AI: The user is a medical professional. Please use technical medical terminology, precise anatomical descriptions, and professional tone (e.g., use 'air-space opacity', 'etiology', 'consolidation'). Avoid simplified layperson language.\n\nREPORT CONTENT:\n$reportText";
      } else {
        finalReportText = "${languageInstruction}REPORT CONTENT:\n$reportText";
      }
      
      final request = ReportRequest(
        mode: mode,
        language: language,
        reportText: finalReportText,
      );
      
      print('DEBUG PROVIDER: Calling API service...');
      final response = await _apiService.analyzeReport(request);
      print('DEBUG PROVIDER: API call successful');
      
      state = AnalysisState(
        isLoading: false,
        response: response,
        reportText: reportText,
        isImageAnalysis: false,
      );
    } catch (e) {
      print('DEBUG PROVIDER: Error occurred: $e');
      state = AnalysisState(
        isLoading: false,
        error: e.toString(),
        reportText: reportText,
        isImageAnalysis: false,
      );
    }
  }
  
  /// Analyze medical image (CT scan, X-ray, MRI, etc.)
  Future<void> analyzeImage({
    required String imageBase64,
    required String imageType,
    required String mode,
    required String language,
  }) async {
    print('DEBUG PROVIDER: analyzeImage called for type: $imageType');
    state = AnalysisState(isLoading: true, isImageAnalysis: true);
    
    try {
      final request = ReportRequest(
        mode: mode,
        language: language,
        imageBase64: imageBase64,
        imageType: imageType,
      );
      
      print('DEBUG PROVIDER: Calling API service for image analysis...');
      final response = await _apiService.analyzeReport(request);
      print('DEBUG PROVIDER: Image analysis API call successful');
      
      state = AnalysisState(
        isLoading: false,
        response: response,
        isImageAnalysis: true,
      );
    } catch (e) {
      print('DEBUG PROVIDER: Image analysis error: $e');
      state = AnalysisState(
        isLoading: false,
        error: e.toString(),
        isImageAnalysis: true,
      );
    }
  }
  
  /// Clear current analysis
  void clear() {
    state = AnalysisState();
  }
  
  /// Set analysis from history (for viewing past analyses)
  void setFromHistory(AnalysisResponse response, String reportText) {
    state = AnalysisState(
      isLoading: false,
      response: response,
      reportText: reportText,
      isImageAnalysis: response.isImageAnalysis,
    );
  }
  
  /// Test API connectivity
  Future<bool> testConnection() async {
    return await _apiService.testConnection();
  }
}

/// API Service provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

/// Analysis provider
final analysisProvider = StateNotifierProvider<AnalysisNotifier, AnalysisState>(
  (ref) {
    final apiService = ref.watch(apiServiceProvider);
    return AnalysisNotifier(apiService);
  },
);
