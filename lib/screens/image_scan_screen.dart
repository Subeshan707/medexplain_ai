import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../config/theme.dart';
import '../providers/settings_provider.dart';
import '../providers/analysis_provider.dart';
import '../l10n/app_localizations.dart';
import 'results_screen.dart';
import '../services/history_service.dart';

/// Screen for capturing/selecting medical images for AI analysis
class ImageScanScreen extends ConsumerStatefulWidget {
  const ImageScanScreen({super.key});

  @override
  ConsumerState<ImageScanScreen> createState() => _ImageScanScreenState();
}

class _ImageScanScreenState extends ConsumerState<ImageScanScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String _selectedImageType = 'xray';
  bool _isProcessing = false;
  
  final List<Map<String, String>> _imageTypes = [
    {'value': 'xray', 'label': 'X-Ray', 'icon': '🩻'},
    {'value': 'ct_scan', 'label': 'CT Scan', 'icon': '🔬'},
    {'value': 'mri', 'label': 'MRI', 'icon': '🧲'},
    {'value': 'ultrasound', 'label': 'Ultrasound', 'icon': '📡'},
    {'value': 'other', 'label': 'Other', 'icon': '📷'},
  ];
  
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      _showError('Failed to pick image: $e');
    }
  }
  
  Future<void> _analyzeImage() async {
    if (_selectedImage == null) {
      _showError('Please select a medical image first');
      return;
    }
    
    setState(() => _isProcessing = true);
    
    try {
      // Read image and convert to base64
      final File imageFile = File(_selectedImage!.path);
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      final settings = ref.read(settingsProvider);
      
      // Navigate to processing screen for image
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ImageProcessingScreen(
            imageBase64: base64Image,
            imageType: _selectedImageType,
            mode: settings.selectedMode,
            language: settings.selectedLanguage,
            imagePath: _selectedImage!.path,
          ),
        ),
      );
    } catch (e) {
      _showError('Failed to process image: $e');
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.alertRed,
      ),
    );
  }
  
  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDarkMode = ref.watch(settingsProvider).isDarkMode;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Medical Image'),
        backgroundColor: AppTheme.darkBlue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryBlue.withOpacity(0.1),
                      AppTheme.darkBlue.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryBlue.withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.medical_information,
                      size: 48,
                      color: AppTheme.primaryBlue,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'AI Medical Image Analysis',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Upload or capture CT scans, X-rays, MRIs, or ultrasound images for AI-powered analysis',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Image Type Selector
              Text(
                'Select Image Type',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _imageTypes.map((type) {
                  final isSelected = _selectedImageType == type['value'];
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(type['icon']!),
                        const SizedBox(width: 6),
                        Text(type['label']!),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedImageType = type['value']!);
                      }
                    },
                    selectedColor: AppTheme.primaryBlue.withOpacity(0.2),
                    checkmarkColor: AppTheme.primaryBlue,
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Image Source Buttons
              Text(
                'Choose Image Source',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isProcessing ? null : () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Camera'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isProcessing ? null : () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Selected Image Preview
              if (_selectedImage != null) ...[
                Text(
                  'Selected Image',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                
                Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_selectedImage!.path),
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                          onPressed: _clearImage,
                          icon: const Icon(Icons.close),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 8),
                
                // Image info
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _selectedImage!.name,
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Analyze Button
                ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _analyzeImage,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.psychology),
                  label: Text(_isProcessing ? 'Processing...' : 'Analyze Image'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              
              // Disclaimer
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withOpacity(0.5),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.warning_amber,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'AI image analysis is for informational purposes only and is NOT intended for medical diagnosis. Always consult a qualified healthcare professional.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isDarkMode ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Processing screen specifically for image analysis
class ImageProcessingScreen extends ConsumerStatefulWidget {
  final String imageBase64;
  final String imageType;
  final String mode;
  final String language;
  final String imagePath;
  
  const ImageProcessingScreen({
    super.key,
    required this.imageBase64,
    required this.imageType,
    required this.mode,
    required this.language,
    required this.imagePath,
  });

  @override
  ConsumerState<ImageProcessingScreen> createState() => _ImageProcessingScreenState();
}

class _ImageProcessingScreenState extends ConsumerState<ImageProcessingScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    // Start analysis after widget tree is built
    Future(() => _startAnalysis());
  }
  
  Future<void> _startAnalysis() async {
    await ref.read(analysisProvider.notifier).analyzeImage(
      imageBase64: widget.imageBase64,
      imageType: widget.imageType,
      mode: widget.mode,
      language: widget.language,
    );
    
    // Wait for state to update
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (!mounted) return;
    
    final state = ref.read(analysisProvider);
    
    if (state.hasResponse) {
      // Save to history
      final summary = state.response!.patientView.summary;
      await HistoryService().saveAnalysis(
        mode: widget.mode,
        reportText: "Image Analysis (${widget.imageType})\n\n$summary",
        response: state.response!,
      );

      if (!mounted) return;

      // Navigate to results screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => const ResultsScreen(),
        ),
      );
    } else if (state.hasError) {
      _showErrorDialog(state.error!);
    }
  }
  
  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: AppTheme.alertRed),
            SizedBox(width: 12),
            Text('Analysis Failed'),
          ],
        ),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Go Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startAnalysis();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.primaryBlue.withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image preview thumbnail
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryBlue.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Animated Icon
                ScaleTransition(
                  scale: _pulseAnimation,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryBlue.withOpacity(0.3),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.medical_information,
                      size: 40,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  'Analyzing ${widget.imageType.replaceAll('_', ' ').toUpperCase()}...',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: 12),
                
                Text(
                  'Gemini Vision AI is examining your medical image',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.black54,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                const SizedBox(
                  width: 200,
                  child: LinearProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
