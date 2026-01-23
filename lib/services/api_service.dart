import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/report_request.dart';
import '../models/analysis_response.dart';
import '../config/constants.dart';

/// API Service for communicating with n8n webhook
class ApiService {
  final String webhookUrl;
  
  ApiService({String? customUrl})
      : webhookUrl = customUrl ?? AppConstants.analysisWebhookUrl;
  
  /// Analyze medical report via n8n webhook
  /// 
  /// Returns [AnalysisResponse] on success
  /// Throws [ApiException] on error
  /// 
  /// Automatically retries up to 3 times with exponential backoff
  /// to handle intermittent malformed responses from the backend
  Future<AnalysisResponse> analyzeReport(ReportRequest request) async {
    const maxRetries = 3;
    const baseDelayMs = 500;
    
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        final uri = Uri.parse(webhookUrl);
        print('DEBUG: Attempt ${attempt + 1}/$maxRetries - Sending request to: $webhookUrl');
        print('DEBUG: Request body: ${jsonEncode(request.toJson())}');
        
        final response = await http
            .post(
              uri,
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
              body: jsonEncode(request.toJson()),
            )
            .timeout(AppConstants.networkTimeout);
        
        print('DEBUG: Response status: ${response.statusCode}');
        print('DEBUG: Response body length: ${response.body.length}');
        
        if (response.statusCode == 200) {
          // Validate response is not empty
          if (response.body.trim().isEmpty) {
            throw const FormatException('Response body is empty');
          }
          
          // Attempt to decode JSON
          final jsonData = jsonDecode(response.body);
          print('DEBUG: JSON decoded successfully');
          
          // Validate response structure
          if (jsonData is! Map<String, dynamic>) {
            throw ApiException(
              'Invalid response format from server',
              statusCode: response.statusCode,
            );
          }
          
          // Validate required fields are present
          if (!jsonData.containsKey('status')) {
            throw const FormatException('Missing required field: status');
          }
          
          print('DEBUG: Response validation passed');
          return AnalysisResponse.fromJson(jsonData);
        } else if (response.statusCode == 400) {
          throw ApiException(
            'Invalid request: Please check your report content',
            statusCode: response.statusCode,
          );
        } else if (response.statusCode == 429) {
          // Rate limit - don't retry, tell user to wait
          throw ApiException(
            'Rate limit exceeded: Please wait a minute and try again',
            statusCode: response.statusCode,
          );
        } else if (response.statusCode == 500) {
          // Retry on 500 errors (helps with Railway cold starts)
          print('DEBUG: 500 error on attempt ${attempt + 1}, will retry...');
          if (attempt == maxRetries - 1) {
            throw ApiException(
              'Server error: Please try again later',
              statusCode: response.statusCode,
            );
          }
        } else {
          throw ApiException(
            'Unexpected error: ${response.statusCode}',
            statusCode: response.statusCode,
          );
        }
      } on SocketException catch (e) {
        print('DEBUG: SocketException on attempt ${attempt + 1}: $e');
        if (attempt == maxRetries - 1) {
          throw ApiException(
            'Network error: Please check your internet connection',
            isNetworkError: true,
          );
        }
      } on http.ClientException catch (e) {
        print('DEBUG: ClientException on attempt ${attempt + 1}: $e');
        if (attempt == maxRetries - 1) {
          throw ApiException(
            'Connection failed: Cannot reach the server',
            isNetworkError: true,
          );
        }
      } on FormatException catch (e) {
        print('DEBUG: FormatException on attempt ${attempt + 1}: $e');
        if (attempt == maxRetries - 1) {
          throw ApiException(
            'Invalid response: Server returned malformed data after $maxRetries attempts',
          );
        }
      } catch (e) {
        print('DEBUG: Unexpected error on attempt ${attempt + 1}: $e');
        if (e is ApiException) rethrow;
        if (attempt == maxRetries - 1) {
          throw ApiException('Unexpected error: ${e.toString()}');
        }
      }
      
      // Wait before retrying (exponential backoff)
      if (attempt < maxRetries - 1) {
        final delayMs = baseDelayMs * (attempt + 1);
        print('DEBUG: Waiting ${delayMs}ms before retry...');
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
    
    // Should never reach here, but just in case
    throw ApiException('Failed after $maxRetries attempts');
  }
  
  /// Test webhook connectivity
  Future<bool> testConnection() async {
    try {
      final uri = Uri.parse(webhookUrl);
      final response = await http
          .head(uri)
          .timeout(const Duration(seconds: 10));
      return response.statusCode < 500;
    } catch (e) {
      return false;
    }
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isNetworkError;
  
  ApiException(
    this.message, {
    this.statusCode,
    this.isNetworkError = false,
  });
  
  @override
  String toString() => message;
}
