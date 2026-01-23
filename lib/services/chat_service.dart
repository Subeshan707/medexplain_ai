import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/constants.dart';

/// Service for RAG-based chat with report context
class ChatService {
  /// Send a chat message with report context
  Future<String> sendMessage({
    required String message,
    required String reportContext,
    required String language,
    List<Map<String, String>> conversationHistory = const [],
  }) async {
    try {
      // Build conversation context
      final historyText = conversationHistory
          .map((m) => '${m['role']}: ${m['content']}')
          .join('\n');
      
      // Build prompt with context
      String languageInstruction = '';
      if (language == 'ta') {
        languageInstruction = 'IMPORTANT: Respond ENTIRELY in Tamil (தமிழ்).\n\n';
      }
      
      final prompt = '''${languageInstruction}You are a helpful medical assistant. The user has analyzed a medical report and has follow-up questions.

ORIGINAL REPORT:
$reportContext

${historyText.isNotEmpty ? 'CONVERSATION HISTORY:\n$historyText\n\n' : ''}USER QUESTION: $message

Please answer the user's question based on the report context. Be helpful but remind them to consult their healthcare provider for medical decisions.''';

      print('DEBUG Chat: Sending request to ${AppConstants.chatWebhookUrl}');
      
      final response = await http.post(
        Uri.parse(AppConstants.chatWebhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'mode': 'chat',  // Changed from 'patient' to 'chat' to indicate chat mode
          'chat_mode': true,  // Explicit flag for n8n to detect chat requests
          'question': message,  // The user's question
          'report_context': reportContext,  // The original report for context
          'language': language,
          'reportText': prompt,  // Full prompt as fallback
        }),
      ).timeout(AppConstants.networkTimeout);

      print('DEBUG Chat: Response status ${response.statusCode}');
      print('DEBUG Chat: Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        // Handle empty response
        if (response.body.isEmpty) {
          return 'The chat feature is not yet configured on the server. Please ensure your n8n workflow has a chat handler that responds to mode="chat" requests. For now, please refer to the analysis results above.';
        }
        
        try {
          final data = jsonDecode(response.body);
          
          // Try to extract response from various possible formats
          if (data is Map) {
            // Check for chat response field (from our new workflow)
            if (data.containsKey('response') && data['response'] != null) {
              return data['response'].toString();
            }
            // Check for status error
            if (data.containsKey('status') && data['status'] == 'error') {
              return 'Sorry, I could not process your question. Please try again.';
            }
            // Check for patient view summary as fallback
            if (data.containsKey('patient_view')) {
              final summary = data['patient_view']['summary']?.toString();
              if (summary != null && summary.isNotEmpty) {
                return summary;
              }
            }
            // Try clinician view
            if (data.containsKey('clinician_view')) {
              final findings = data['clinician_view']['findings'];
              if (findings is List && findings.isNotEmpty) {
                return findings.join('\n');
              }
            }
            // Return a formatted answer from available data
            return 'Based on your report analysis, I found relevant information. Please consult your healthcare provider for specific medical advice.';
          }
          
          return response.body;
        } catch (parseError) {
          print('DEBUG Chat: JSON parse error: $parseError');
          // If JSON parsing fails, return the raw body as a response
          if (response.body.length > 10) {
            return response.body;
          }
          return 'I received a response but could not process it properly. Please try again.';
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('DEBUG Chat: Error occurred: $e');
      throw Exception('Failed to send message: $e');
    }
  }
}
