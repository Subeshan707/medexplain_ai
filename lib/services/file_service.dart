import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf_pdf;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdfx/pdfx.dart' as pdfx;
import '../config/constants.dart';

/// File handling service for medical reports
class FileService {
  final ImagePicker _imagePicker = ImagePicker();
  final TextRecognizer _textRecognizer = TextRecognizer();
  
  /// Pick files (PDF, TXT, or Images) - supports multiple selection
  Future<FilePickerResult?> pickFile({bool allowMultiple = true}) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.allowedFileExtensions,
        allowMultiple: allowMultiple,
        withData: true, // Load file bytes into memory
      );
      
      return result;
    } catch (e) {
      throw FileException('Error picking file: ${e.toString()}');
    }
  }
  
  /// Pick multiple images for OCR
  Future<List<XFile>> pickMultipleImages() async {
    try {
      final images = await _imagePicker.pickMultiImage(
        maxWidth: 2000,
        maxHeight: 2000,
        imageQuality: 85,
      );
      
      return images;
    } catch (e) {
      throw FileException('Error picking images: ${e.toString()}');
    }
  }
  
  /// Extract text from picked file
  Future<String> extractTextFromFile(PlatformFile file) async {
    try {
      if (file.bytes == null && file.path == null) {
        throw FileException('File data not available');
      }
      
      // Check file size
      if (file.size > AppConstants.maxFileSizeBytes) {
        throw FileException(
          'File too large. Maximum size is ${AppConstants.maxFileSizeBytes ~/ (1024 * 1024)}MB'
        );
      }
      
      final extension = file.extension?.toLowerCase();
      
      if (extension == 'txt') {
        // Simple text file
        if (file.bytes != null) {
          return utf8.decode(file.bytes!);
        } else if (file.path != null) {
          final fileContent = await File(file.path!).readAsString();
          return fileContent;
        }
      } else if (extension == 'pdf') {
        return await _extractTextFromPDF(file);
      } else if (extension == 'jpg' || extension == 'jpeg' || extension == 'png') {
        return await _extractTextFromImage(file);
      } else {
        throw FileException('Unsupported file type: $extension');
      }
      
      throw FileException('Unable to read file');
    } catch (e) {
      if (e is FileException) rethrow;
      throw FileException('Error reading file: ${e.toString()}');
    }
  }
  
  /// Extract text from PDF (handles both text-based and scanned)
  Future<String> _extractTextFromPDF(PlatformFile file) async {
    try {
      List<int> bytes;
      
      if (file.bytes != null) {
        bytes = file.bytes!;
      } else if (file.path != null) {
        bytes = await File(file.path!).readAsBytes();
      } else {
        throw FileException('Unable to load PDF');
      }
      
      // Load PDF document for text extraction
      final sf_pdf.PdfDocument document = sf_pdf.PdfDocument(inputBytes: bytes);
      
      // Extract text from all pages
      final String extractedText = sf_pdf.PdfTextExtractor(document).extractText();
      final cleanedText = extractedText.trim();
      
      // If text found, return it (text-based PDF)
      if (cleanedText.isNotEmpty && cleanedText.length >= 50) {
        document.dispose();
        return cleanedText;
      }
      
      // No text found - this is a scanned PDF
      // Convert to images and perform OCR
      print('DEBUG: PDF has no extractable text, performing OCR on pages...');
      document.dispose();
      
      try {
        return await _extractTextFromScannedPDF(bytes, file.path);
      } catch (e) {
        throw FileException(
          'Failed to process scanned PDF: ${e.toString()}\n\n'
          'Please try uploading the pages as separate images instead.'
        );
      }
    } catch (e) {
      if (e is FileException) rethrow;
      throw FileException('Error extracting text from PDF: ${e.toString()}');
    }
  }
  
  /// Extract text from scanned PDF by rendering pages and using OCR
  Future<String> _extractTextFromScannedPDF(List<int> pdfBytes, String? originalPath) async {
    try {
      // Open PDF document for rendering
      final uint8Data = Uint8List.fromList(pdfBytes);
      final doc = await pdfx.PdfDocument.openData(uint8Data);
      final pageCount = doc.pagesCount;
      
      if (pageCount == 0) {
        throw FileException('PDF has no pages');
      }
      
      print('DEBUG: Processing $pageCount PDF pages with OCR...');
      final StringBuffer combinedText = StringBuffer();
      final tempDir = await getTemporaryDirectory();
      
      // Process each page
      for (int pageNum = 1; pageNum <= pageCount; pageNum++) {
        try {
          // Get the page
          final page = await doc.getPage(pageNum);
          
          // Render page to image
          final pageImage = await page.render(
            width: page.width * 2, // 2x resolution for better OCR
            height: page.height * 2,
            format: pdfx.PdfPageImageFormat.png,
          );
          
          // Save rendered image to temp file
          final imagePath = '${tempDir.path}/pdf_page_${DateTime.now().millisecondsSinceEpoch}_$pageNum.png';
          final imageFile = File(imagePath);
          await imageFile.writeAsBytes(pageImage!.bytes);
          
          // Perform OCR on the rendered image
          final inputImage = InputImage.fromFilePath(imagePath);
          final recognizedText = await _textRecognizer.processImage(inputImage);
          
          // Add page marker and text
          if (pageNum > 1) {
            combinedText.writeln('\n--- Page $pageNum ---\n');
          }
          combinedText.writeln(recognizedText.text);
          
          // Clean up temp file
          await imageFile.delete();
          await page.close();
          
          print('DEBUG: Processed page $pageNum/$pageCount');
        } catch (e) {
          print('DEBUG: Error processing page $pageNum: $e');
          // Continue with other pages
        }
      }
      
      await doc.close();
      
      final result = combinedText.toString().trim();
      
      if (result.isEmpty) {
        throw FileException('No text could be extracted from the scanned PDF');
      }
      
      return result;
    } catch (e) {
      if (e is FileException) rethrow;
      throw FileException('Error processing scanned PDF: ${e.toString()}');
    }
  }
  
  /// Extract text from image using OCR
  Future<String> _extractTextFromImage(PlatformFile file) async {
    try {
      InputImage inputImage;
      
      if (file.path != null) {
        inputImage = InputImage.fromFilePath(file.path!);
      } else if (file.bytes != null) {
        // Save bytes to temp file
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/temp_${DateTime.now().millisecondsSinceEpoch}.${file.extension}');
        await tempFile.writeAsBytes(file.bytes!);
        inputImage = InputImage.fromFilePath(tempFile.path);
      } else {
        throw FileException('Unable to load image');
      }
      
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
      
      if (recognizedText.text.isEmpty) {
        throw FileException('No text detected in image. Please ensure the image is clear and contains readable text.');
      }
      
      return recognizedText.text;
    } catch (e) {
      if (e is FileException) rethrow;
      throw FileException('Error performing OCR: ${e.toString()}');
    }
  }
  
  /// Extract and combine text from multiple images
  Future<String> extractTextFromImages(List<XFile> images) async {
    try {
      if (images.isEmpty) {
        throw FileException('No images selected');
      }
      
      if (images.length > AppConstants.maxImagesPerUpload) {
        throw FileException(
          'Too many images. Maximum is ${AppConstants.maxImagesPerUpload}'
        );
      }
      
      final StringBuffer combinedText = StringBuffer();
      
      for (int i = 0; i < images.length; i++) {
        final image = images[i];
        final inputImage = InputImage.fromFilePath(image.path);
        final recognizedText = await _textRecognizer.processImage(inputImage);
        
        if (i > 0) combinedText.writeln('\n--- Page ${i + 1} ---\n');
        combinedText.writeln(recognizedText.text);
      }
      
      final result = combinedText.toString().trim();
      
      if (result.isEmpty) {
        throw FileException('No text detected in any of the images');
      }
      
      return result;
    } catch (e) {
      if (e is FileException) rethrow;
      throw FileException('Error processing images: ${e.toString()}');
    }
  }
  
  /// Save analysis result as JSON
  Future<String> saveAnalysisAsJson(
    Map<String, dynamic> data,
    String filename,
  ) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$filename.json');
      
      final jsonString = JsonEncoder.withIndent('  ').convert(data);
      await file.writeAsString(jsonString);
      
      return file.path;
    } catch (e) {
      throw FileException('Error saving file: ${e.toString()}');
    }
  }
  
  /// Clean up resources
  void dispose() {
    _textRecognizer.close();
  }
  
  /// Get file size in human-readable format
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Custom exception for file operations
class FileException implements Exception {
  final String message;
  
  FileException(this.message);
  
  @override
  String toString() => message;
}
