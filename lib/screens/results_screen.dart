import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../config/constants.dart';
import '../config/theme.dart';
import '../providers/analysis_provider.dart';
import '../providers/settings_provider.dart';
import '../services/file_service.dart';
import '../widgets/disclaimer_footer.dart';
import '../l10n/app_localizations.dart';
import '../widgets/report_chat_widget.dart';

/// Results screen with swipeable colorful cards
class ResultsScreen extends ConsumerStatefulWidget {
  const ResultsScreen({super.key});

  @override
  ConsumerState<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends ConsumerState<ResultsScreen> 
    with TickerProviderStateMixin {
  final FileService _fileService = FileService();
  late PageController _pageController;
  late AnimationController _fadeController;
  int _currentPage = 0;
  
  final GlobalKey _pageViewKey = GlobalKey();
  
  @override
  void initState() {
    super.initState();
    super.initState();
    _pageController = PageController(viewportFraction: 1.0); // Full width
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeController.forward();
  }
  

  
  @override
  void dispose() {
    _pageController.dispose();
    _fadeController.dispose();
    super.dispose();
  }
  
  Future<void> _exportAsJson() async {
    try {
      final state = ref.read(analysisProvider);
      if (state.response == null) return;
      
      final filename = 'medexplain_analysis_${DateTime.now().millisecondsSinceEpoch}';
      final path = await _fileService.saveAnalysisAsJson(
        state.response!.toJson(),
        filename,
      );
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Analysis exported to: $path'),
          backgroundColor: AppTheme.successBlue,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export failed: ${e.toString()}'),
          backgroundColor: AppTheme.alertRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
  
  void _startNewAnalysis() {
    ref.read(analysisProvider.notifier).clear();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analysisProvider);
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context);
    
    if (state.response == null) {
      return Scaffold(
        body: Center(
          child: Text(l10n?.noResults ?? 'No analysis results available'),
        ),
      );
    }
    
    final response = state.response!;
    final isPatientMode = settings.selectedMode == AppConstants.patientMode;
    final cards = _buildCards(response, isPatientMode);
    
    return Scaffold(
      // backgroundColor uses theme default (lightSurface)
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Reusable PageView definition
            final pageView = PageView.builder(
              key: _pageViewKey,
              controller: _pageController,
              onPageChanged: (page) => setState(() => _currentPage = page),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                // No scaling, full screen card
                return cards[index];
              },
            );

            // Check if screen is too short for fixed layout
            if (constraints.maxHeight < 600) {
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildAppBar(isPatientMode),
                        if (response.redFlag) _buildRedFlagBanner(),
                        _buildPageIndicator(cards.length),
                        // Fixed height for cards in scroll view
                        SizedBox(height: 400, child: pageView),
                        _buildBottomBar(),
                        const SizedBox(height: 80), // Space for chat
                      ],
                    ),
                  ),
                  // Chat widget at bottom
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: ReportChatWidget(
                      reportContext: state.reportText ?? '',
                      language: settings.selectedLanguage,
                    ),
                  ),
                ],
              );
            }

            // Standard layout for taller screens
            return Stack(
              children: [
                Column(
                  children: [
                    _buildAppBar(isPatientMode),
                    if (response.redFlag) _buildRedFlagBanner(),
                    _buildPageIndicator(cards.length),
                    Expanded(child: pageView),
                    _buildBottomBar(),
                    const SizedBox(height: 60), // Space for chat header
                  ],
                ),
                // Chat widget at bottom
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ReportChatWidget(
                    reportContext: state.reportText ?? '',
                    language: settings.selectedLanguage,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildAppBar(bool isPatientMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppTheme.darkBlue,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: _startNewAnalysis,
            icon: const Icon(Icons.arrow_back_ios, color: AppTheme.white),
          ),
          Expanded(
            child: Text(
              'Analysis Results',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: _exportAsJson,
            icon: const Icon(Icons.share, color: AppTheme.primaryBlue),
          ),
        ],
      ),
    );
  }
  
  Widget _buildRedFlagBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.alertRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.alertRed.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: AppTheme.alertRed, size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Critical findings detected. Please consult a doctor.',
              style: TextStyle(
                color: AppTheme.alertRed, 
                fontWeight: FontWeight.w600, 
                fontSize: 14
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPageIndicator(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(count, (i) => AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: _currentPage == i ? 24 : 8,
          decoration: BoxDecoration(
            color: _currentPage == i ? AppTheme.primaryBlue : AppTheme.white,
            borderRadius: BorderRadius.circular(4),
          ),
        )),
      ),
    );
  }
  
  List<Widget> _buildCards(dynamic response, bool isPatientMode) {
    final List<Widget> cards = [];
    
    // Strict Medical Theme - White Cards
    
    if (isPatientMode) {
      cards.add(_infoCard('Summary', 'Overview', response.patientView.summary, Icons.summarize));
      
      if (response.patientView.possibleMeaning.isNotEmpty)
        cards.add(_listCard('What This Means', 'Interpretation',
            response.patientView.possibleMeaning, Icons.lightbulb_outline));
      
      if (response.patientView.questionsForDoctor.isNotEmpty)
        cards.add(_listCard('Ask Your Doctor', 'Suggested Questions',
            response.patientView.questionsForDoctor, Icons.help_outline));
    } else {
      if (response.clinicianView.findings.isNotEmpty)
        cards.add(_listCard('Clinical Findings', 'Key Observations',
            response.clinicianView.findings, Icons.biotech));
      
      if (response.clinicianView.criticalValues.isNotEmpty)
        cards.add(_listCard('Critical Values', 'Actionable Findings',
            response.clinicianView.criticalValues, Icons.warning_amber_rounded, isAlert: true));
      
      if (response.clinicianView.considerations.isNotEmpty)
        cards.add(_listCard('Considerations', 'Recommendations',
            response.clinicianView.considerations, Icons.psychology_outlined));
    }
    
    if (response.citations.isNotEmpty)
      cards.add(_listCard('References', 'Sources',
          response.citations, Icons.menu_book));
    
    cards.add(_disclaimerCard(response.disclaimer));
    
    return cards;
  }
  
  Widget _infoCard(String title, String subtitle, String content, IconData icon) {
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // Minimized margin
        // No decoration - Flat design
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppTheme.primaryBlue, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: const TextStyle(color: AppTheme.neutralBlack, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: AppTheme.black, fontSize: 13)),
                ])),
              ]),
              const SizedBox(height: 24),
              Text(content, style: const TextStyle(color: AppTheme.black, fontSize: 16, height: 1.6)),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _listCard(String title, String subtitle, List<String> items, IconData icon, {bool isAlert = false}) {
    final primaryColor = isAlert ? AppTheme.alertRed : AppTheme.primaryBlue;
    final bgColor = isAlert ? AppTheme.alertRed : AppTheme.white;
    final iconBg = isAlert ? AppTheme.alertRed : AppTheme.white;
    
    return FadeTransition(
      opacity: _fadeController,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // Minimized margin
        // No decoration - Flat design
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: primaryColor, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(color: isAlert ? AppTheme.alertRed : AppTheme.neutralBlack, fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(subtitle, style: const TextStyle(color: AppTheme.black, fontSize: 13)),
                ])),
              ]),
              const SizedBox(height: 24),
              ...items.asMap().entries.map((e) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6, height: 6,
                    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value, style: const TextStyle(color: AppTheme.black, fontSize: 15, height: 1.5))),
                ]),
              )),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _disclaimerCard(String disclaimer) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4), // Minimized margin
      // No decoration - Flat design
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(children: [
              const Icon(Icons.info_outline, color: AppTheme.black, size: 24),
              const SizedBox(width: 12),
              const Text('Disclaimer', style: TextStyle(color: AppTheme.black, fontSize: 16, fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 12),
            Text(disclaimer, style: const TextStyle(color: AppTheme.black, fontSize: 12, height: 1.5)),
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        onPressed: _startNewAnalysis,
        icon: const Icon(Icons.add),
        label: const Text('New Analysis'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryBlue,
          foregroundColor: AppTheme.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          elevation: 4,
          shadowColor: AppTheme.primaryBlue,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
