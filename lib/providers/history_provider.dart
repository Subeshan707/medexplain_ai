import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/analysis_history.dart';
import '../services/history_service.dart';

/// History state
class HistoryState {
  final bool isLoading;
  final List<AnalysisHistory> items;
  final String? error;

  HistoryState({
    this.isLoading = false,
    this.items = const [],
    this.error,
  });

  HistoryState copyWith({
    bool? isLoading,
    List<AnalysisHistory>? items,
    String? error,
  }) {
    return HistoryState(
      isLoading: isLoading ?? this.isLoading,
      items: items ?? this.items,
      error: error,
    );
  }
}

/// History provider notifier
class HistoryNotifier extends StateNotifier<HistoryState> {
  final HistoryService _historyService;

  HistoryNotifier(this._historyService) : super(HistoryState());

  /// Load history from Firestore
  Future<void> loadHistory() async {
    print('DEBUG HistoryProvider: loadHistory called');
    state = state.copyWith(isLoading: true, error: null);

    try {
      final items = await _historyService.getHistory();
      print('DEBUG HistoryProvider: Loaded ${items.length} items');
      state = HistoryState(isLoading: false, items: items);
    } catch (e) {
      print('DEBUG HistoryProvider: Error loading history: $e');
      state = HistoryState(isLoading: false, error: e.toString());
    }
  }

  /// Delete a single item
  Future<void> deleteItem(String id) async {
    final success = await _historyService.deleteAnalysis(id);
    if (success) {
      state = state.copyWith(
        items: state.items.where((item) => item.id != id).toList(),
      );
    }
  }

  /// Clear all history
  Future<void> clearAll() async {
    final success = await _historyService.clearHistory();
    if (success) {
      state = HistoryState(items: []);
    }
  }

  /// Refresh history
  Future<void> refresh() => loadHistory();
}

/// History service provider
final historyServiceProvider = Provider<HistoryService>((ref) {
  return HistoryService();
});

/// History provider
final historyProvider = StateNotifierProvider<HistoryNotifier, HistoryState>(
  (ref) {
    final service = ref.watch(historyServiceProvider);
    return HistoryNotifier(service);
  },
);
