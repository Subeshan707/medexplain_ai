import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../config/constants.dart';
import '../config/theme.dart';
import '../providers/settings_provider.dart';
import '../providers/analysis_provider.dart';
import '../services/file_service.dart';
import '../widgets/disclaimer_footer.dart';
import '../widgets/mode_selector.dart';
import '../services/auth_service.dart';
import '../providers/user_provider.dart';
import '../models/user_profile.dart';
import '../l10n/app_localizations.dart';
import 'processing_screen.dart';
import 'login_screen.dart';
import 'settings_screen.dart';
import 'image_scan_screen.dart';

/// Home screen for report upload and configuration
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _reportController = TextEditingController();
  final FileService _fileService = FileService();
  String? _selectedFileName;
  int? _selectedFileSize;
  List<XFile>? _selectedImages;
  bool _isProcessingImages = false;
  
  @override
  void dispose() {
    _reportController.dispose();
    super.dispose();
  }

  void _syncModeWithProfile(UserProfile? profile) {
    if (profile == null) return;
    
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final currentMode = ref.read(settingsProvider).selectedMode;
    
    String targetMode;
    if (profile.role == 'clinician') {
      targetMode = AppConstants.clinicianMode;
    } else {
      targetMode = AppConstants.patientMode;
    }

    if (currentMode != targetMode) {
      // Use Future.microtask to avoid build-phase state updates if called during build
      Future.microtask(() => settingsNotifier.setMode(targetMode));
    }
  }
  
  Future<void> _pickFiles() async {
    try {
      setState(() => _isProcessingImages = true);
      
      final result = await _fileService.pickFile(allowMultiple: true);
      
      if (result != null && result.files.isNotEmpty) {
        if (result.files.length == 1) {
          // Single file selected - extract text directly
          final file = result.files.first;
          try {
            final text = await _fileService.extractTextFromFile(file);
            setState(() {
              _reportController.text = text;
              _selectedFileName = file.name;
              _selectedFileSize = file.size;
              _selectedImages = null;
              _isProcessingImages = false;
            });
          } catch (e) {
            setState(() => _isProcessingImages = false);
            if (!mounted) return;
            _showError(e.toString());
          }
        } else {
          // Multiple files selected - process as images
          final images = <XFile>[];
          for (var file in result.files) {
            if (file.path != null) {
              images.add(XFile(file.path!));
            }
          }
          
          if (images.isNotEmpty) {
            final text = await _fileService.extractTextFromImages(images);
            
            // Calculate total size
            int totalSize = 0;
            for (var file in result.files) {
              totalSize += file.size;
            }
            
            setState(() {
              _reportController.text = text;
              _selectedImages = images;
              _selectedFileName = null;
              _selectedFileSize = totalSize;
              _isProcessingImages = false;
            });
          } else {
            setState(() => _isProcessingImages = false);
          }
        }
      } else {
        setState(() => _isProcessingImages = false);
      }
    } catch (e) {
      setState(() => _isProcessingImages = false);
      if (!mounted) return;
      _showError(e.toString());
    }
  }
  
  Future<void> _analyzeReport() async {
    final reportText = _reportController.text.trim();
    
    if (reportText.isEmpty) {
      _showError('Please enter or upload a medical report');
      return;
    }
    
    final settings = ref.read(settingsProvider);
    
    // Navigate to processing screen
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProcessingScreen(
          reportText: reportText,
          mode: settings.selectedMode,
          language: settings.selectedLanguage,
        ),
      ),
    );
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.alertRed,
      ),
    );
  }
  
  void _clearReport() {
    setState(() {
      _reportController.clear();
      _selectedFileName = null;
      _selectedFileSize = null;
      _selectedImages = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDarkMode = settings.isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > AppConstants.tabletBreakpoint;
    final l10n = AppLocalizations.of(context);

    // Listen to profile changes to enforce mode
    ref.listen<AsyncValue<UserProfile?>>(userProfileProvider, (previous, next) {
      next.whenData((profile) => _syncModeWithProfile(profile));
    });
    
    // Also check on initial build
    final currentProfile = ref.watch(userProfileProvider).asData?.value;
    if (currentProfile != null) {
      _syncModeWithProfile(currentProfile);
    }
    
    return Scaffold(
      // backgroundColor uses theme default (lightSurface)
      appBar: AppBar(
        title: Text(l10n?.appName ?? 'MedExplain AI'),
        backgroundColor: AppTheme.darkBlue,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer(
            builder: (context, ref, _) {
              final userProfileAsync = ref.watch(userProfileProvider);
              return userProfileAsync.when(
                data: (profile) => CircleAvatar(
                  backgroundImage: profile?.photoUrl != null 
                      ? NetworkImage(profile!.photoUrl!) 
                      : null,
                  backgroundColor: AppTheme.lightSurface,
                  child: profile?.photoUrl == null 
                      ? const Icon(Icons.person, color: AppTheme.primaryBlue) 
                      : null,
                ),
                loading: () => const CircleAvatar(backgroundColor: Colors.transparent),
                error: (_, __) => const Icon(Icons.error),
              );
            },
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref.read(settingsProvider.notifier).setDarkMode(!isDarkMode);
            },
            tooltip: isDarkMode ? 'Light mode' : 'Dark mode',
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
      ),
      drawer: Drawer(
        child: Consumer(
          builder: (context, ref, _) {
            final userProfileAsync = ref.watch(userProfileProvider);
            return userProfileAsync.when(
              data: (profile) => ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(color: AppTheme.primaryBlue),
                    accountName: Text(
                      profile?.role == 'clinician' 
                          ? '${profile?.name}\n${profile?.clinicName ?? ""}' 
                          : profile?.name ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    accountEmail: Text(profile?.email ?? ''),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: profile?.photoUrl != null 
                          ? NetworkImage(profile!.photoUrl!) 
                          : null,
                      backgroundColor: AppTheme.white,
                      child: profile?.photoUrl == null 
                          ? const Text('?', style: TextStyle(fontSize: 24, color: AppTheme.primaryBlue)) 
                          : null,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.history, color: AppTheme.darkBlue),
                    title: const Text('History'),
                    subtitle: const Text('Global History Coming Soon'),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('History feature coming soon!')),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.logout, color: AppTheme.alertRed),
                    title: const Text('Sign Out'),
                    onTap: () async {
                      await AuthService().signOut();
                      if (mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Error loading profile')),
            );
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isDesktop ? 24 : 16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: isDesktop ? 800 : double.infinity,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Text(
                      'Simplify Your Medical Reports',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.neutralBlack,
                      ),
                    ),    
                        const SizedBox(height: 8),
                        
                        Text(
                          'Upload or paste your medical report for an instant AI-powered explanation.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                          textAlign: isDesktop ? TextAlign.center : TextAlign.start,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Mode Selector - Only show if no user profile (guest)
                        // For logged in users, mode is auto-set by role
                        Consumer(
                          builder: (context, ref, _) {
                            final userProfileAsync = ref.watch(userProfileProvider);
                            
                            // Hide while loading to prevent flicker
                            if (userProfileAsync.isLoading) {
                              return const SizedBox.shrink();
                            }
                            
                            // If profile exists (logged in), hide selector
                            final userProfile = userProfileAsync.valueOrNull;
                            if (userProfile != null) return const SizedBox.shrink();
                            
                            // Only show for Guest users
                            return const Column(
                              children: [
                                ModeSelector(),
                                SizedBox(height: 24),
                              ],
                            );
                          },
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Upload Section - DIRECT ON SCREEN
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.upload_file, color: AppTheme.primaryBlue),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        l10n?.uploadReport ?? 'Upload Report',
                                        style: Theme.of(context).textTheme.titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Unified Upload Button
                                OutlinedButton.icon(
                                  onPressed: _isProcessingImages ? null : _pickFiles,
                                  icon: _isProcessingImages 
                                      ? const SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : const Icon(Icons.upload_file),
                                  label: Text(
                                    _isProcessingImages 
                                        ? (l10n?.processing ?? 'Processing...')
                                        : (l10n?.uploadFiles ?? 'Upload Files (PDF, Images, TXT)'),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.all(20),
                                  ),
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Helper text
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    'Select one file or multiple images. PDFs and images support OCR.',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).textTheme.bodySmall?.color,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                
                                // Display selected file
                                if (_selectedFileName != null && _selectedImages == null) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.description, size: 20, color: Theme.of(context).iconTheme.color),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _selectedFileName!,
                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              if (_selectedFileSize != null)
                                                Text(
                                                  FileService.formatFileSize(_selectedFileSize!),
                                                  style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                                                ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.close, size: 20),
                                          onPressed: _clearReport,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                
                                // Display selected images
                                if (_selectedImages != null && _selectedImages!.isNotEmpty) ...[
                                  const SizedBox(height: 12),
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: AppTheme.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.photo_library, size: 20, color: AppTheme.primaryBlue),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${_selectedImages!.length} image${_selectedImages!.length > 1 ? 's' : ''} selected',
                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                            if (_selectedFileSize != null)
                                              Text(
                                                FileService.formatFileSize(_selectedFileSize!),
                                                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                                              ),
                                            IconButton(
                                              icon: const Icon(Icons.close, size: 20),
                                              onPressed: _clearReport,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        ...List.generate(
                                          _selectedImages!.length > 3 ? 3 : _selectedImages!.length,
                                          (index) {
                                            final imageName = _selectedImages![index].name;
                                            return Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Row(
                                                children: [
                                                  const SizedBox(width: 28),
                                                  Icon(Icons.image, size: 16, color: Theme.of(context).iconTheme.color),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: Text(
                                                      imageName,
                                                      style: const TextStyle(fontSize: 12),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        if (_selectedImages!.length > 3)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 4, left: 28),
                                            child: Text(
                                              '+ ${_selectedImages!.length - 3} more',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Theme.of(context).textTheme.bodySmall?.color,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                                
                                const SizedBox(height: 24),
                                
                                // OR Divider
                                Row(
                                  children: [
                                    const Expanded(child: Divider()),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'OR',
                                        style: Theme.of(context).textTheme.labelLarge,
                                      ),
                                    ),
                                    const Expanded(child: Divider()),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Paste Text Area
                                Row(
                                  children: [
                                    const Icon(Icons.edit_note, color: AppTheme.primaryBlue),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        l10n?.pasteReportText ?? 'Paste Report Text',
                                        style: Theme.of(context).textTheme.titleLarge,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                TextField(
                                  controller: _reportController,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                    hintText: l10n?.pasteHint ?? 'Paste your medical report here...',
                                    border: const OutlineInputBorder(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        
                        const SizedBox(height: 24),
                        
                        // Analyze Button
                        OutlinedButton.icon(
                          onPressed: _analyzeReport,
                          icon: const Icon(Icons.psychology),
                          label: Text(l10n?.analyzeReport ?? 'Analyze Report'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.all(20),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Scan Medical Image Button (NEW - Gemini Vision)
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const ImageScanScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.medical_information),
                          label: const Text('Scan Medical Image (CT/X-Ray/MRI)'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.darkBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Safety Notice
                        Container(
                          padding: const EdgeInsets.all(16),
                          // No decoration - Safety notice direct on screen
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Theme.of(context).iconTheme.color),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Your report is processed securely. No data is stored permanently.',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).textTheme.bodyMedium?.color,
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
              ),
            ),
            
            // Disclaimer Footer
            const DisclaimerFooter(),
          ],
        ),
      ),
    );
  }
}
