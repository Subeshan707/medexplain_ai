import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../config/theme.dart';
import '../config/constants.dart';
import '../providers/history_provider.dart';
import '../models/analysis_history.dart';
import '../l10n/app_localizations.dart';
import 'results_screen.dart';
import '../providers/analysis_provider.dart';
import 'trends_screen.dart';

/// History screen showing past analyses as a Health Journey
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Load history on screen open
    Future.microtask(() => ref.read(historyProvider.notifier).loadHistory());
  }

  @override
  Widget build(BuildContext context) {
    final historyState = ref.watch(historyProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.lightSurface,
      appBar: AppBar(
        title: Text(l10n?.history ?? 'Health Journey'),
        backgroundColor: AppTheme.darkBlue,
        foregroundColor: AppTheme.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.show_chart),
            tooltip: 'Trend Analysis',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const TrendsScreen()),
              );
            },
          ),
          if (historyState.items.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () => _showClearConfirmation(context, l10n),
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: _buildBody(historyState, l10n),
    );
  }

  Widget _buildBody(HistoryState state, AppLocalizations? l10n) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: AppTheme.alertRed),
            const SizedBox(height: 16),
            Text('Error loading history', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () => ref.read(historyProvider.notifier).refresh(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.history, size: 64, color: AppTheme.primaryBlue),
            const SizedBox(height: 16),
            Text(
              l10n?.noHistoryYet ?? 'No analysis history yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Your analyzed reports will appear here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.black,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(historyProvider.notifier).refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final item = state.items[index];
          final isFirst = index == 0;
          final isLast = index == state.items.length - 1;
          return _buildTimelineItem(item, l10n, isFirst, isLast);
        },
      ),
    );
  }

  Widget _buildTimelineItem(AnalysisHistory item, AppLocalizations? l10n, bool isFirst, bool isLast) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');
    final isPatient = item.mode == AppConstants.patientMode;
    
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line & Dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Top Line
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : AppTheme.primaryBlue.withOpacity(0.3),
                  ),
                ),
                // Dot
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withOpacity(0.3),
                        blurRadius: 4,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                // Bottom Line
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : AppTheme.primaryBlue.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Dismissible(
                key: Key(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppTheme.alertRed,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: AppTheme.white),
                ),
                onDismissed: (_) => ref.read(historyProvider.notifier).deleteItem(item.id),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: InkWell(
                    onTap: () => _viewAnalysis(item),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                dateFormat.format(item.timestamp),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkBlue,
                                ),
                              ),
                              Text(
                                timeFormat.format(item.timestamp),
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Badges row
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isPatient 
                                      ? AppTheme.primaryBlue.withOpacity(0.1)
                                      : AppTheme.successBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  isPatient 
                                      ? '👤 ${l10n?.patient ?? "Patient"}'
                                      : '👨‍⚕️ ${l10n?.clinician ?? "Clinician"}',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: isPatient ? AppTheme.primaryBlue : AppTheme.successBlue,
                                  ),
                                ),
                              ),
                              if (item.response.redFlag) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.alertRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.warning_amber, size: 12, color: AppTheme.alertRed),
                                      SizedBox(width: 4),
                                      Text(
                                        'Critical',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: AppTheme.alertRed,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Preview Text
                          Text(
                            item.reportPreview ?? item.reportText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewAnalysis(AnalysisHistory item) {
    // Set the analysis response in provider and navigate
    ref.read(analysisProvider.notifier).setFromHistory(item.response, item.reportText);
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ResultsScreen()),
    );
  }

  void _showClearConfirmation(BuildContext context, AppLocalizations? l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All History?'),
        content: const Text('This will permanently delete all your analysis history. This action cannot be undone.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(historyProvider.notifier).clearAll();
            },
            child: const Text('Clear All', style: TextStyle(color: AppTheme.alertRed)),
          ),
        ],
      ),
    );
  }
}
