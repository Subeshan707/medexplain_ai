import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/theme.dart';
import '../providers/analysis_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/history_service.dart';
import 'results_screen.dart';

/// Processing screen with animation while analyzing report
class ProcessingScreen extends ConsumerStatefulWidget {
  final String reportText;
  final String mode;
  final String language;
  
  const ProcessingScreen({
    super.key,
    required this.reportText,
    required this.mode,
    required this.language,
  });

  @override
  ConsumerState<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends ConsumerState<ProcessingScreen> with SingleTickerProviderStateMixin {
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
    
    // Start analysis after widget tree is built (Riverpod requirement)
    Future(() => _startAnalysis());
  }
  
  Future<void> _startAnalysis() async {
    await ref.read(analysisProvider.notifier).analyzeReport(
      reportText: widget.reportText,
      mode: widget.mode,
      language: widget.language,
    );
    
    // Wait for state to update
    await Future.delayed(const Duration(milliseconds: 100));
    
    if (!mounted) return;
    
    final state = ref.read(analysisProvider);
    
    if (state.hasResponse) {
      // Save to history
      await HistoryService().saveAnalysis(
        mode: widget.mode,
        reportText: widget.reportText,
        response: state.response!,
      );
      
      // Success - navigate to results
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ResultsScreen()),
      );
    } else if (state.hasError) {
      // Error - show dialog
      _showErrorDialog(state.error!);
    }
  }
  
  void _showErrorDialog(String error) {
    final l10n = AppLocalizations.of(context);
    String userMessage = error;
    if (error.contains('after 3 attempts')) {
      userMessage = 'The server is having trouble processing your request. '
          'We tried 3 times but received invalid data each time.\n\n'
          'This might be a temporary issue. Please try again.';
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: AppTheme.alertRed),
            const SizedBox(width: 12),
            Text(l10n?.exportFailed ?? 'Analysis Failed'),
          ],
        ),
        content: Text(userMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Back to home
            },
            child: Text(l10n?.cancel ?? 'Go Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _startAnalysis(); // Retry
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
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: Container(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isSmallHeight = constraints.maxHeight < 400;
            
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallHeight ? 20 : 40,
                  horizontal: 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated Icon
                    ScaleTransition(
                      scale: _pulseAnimation,
                      child: Container(
                        width: isSmallHeight ? 80 : 100,
                        height: isSmallHeight ? 80 : 100,
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
                        child: Icon(
                          Icons.psychology,
                          size: isSmallHeight ? 40 : 50,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isSmallHeight ? 20 : 32),
                    
                    // Processing Text
                    Text(
                      l10n?.analyzingReport ?? 'Analyzing Report...',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallHeight ? 20 : null,
                      ),
                    ),
                    
                    SizedBox(height: isSmallHeight ? 8 : 12),
                    
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        l10n?.aiProcessing ?? 'Our AI is carefully reviewing your medical report',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.black,
                          fontSize: isSmallHeight ? 13 : null,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: isSmallHeight ? 20 : 32),
                    
                    // Progress Indicator
                    SizedBox(
                      width: isSmallHeight ? 150 : 200,
                      child: const LinearProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
