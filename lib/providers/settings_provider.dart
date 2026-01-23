import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/constants.dart';

/// Settings state class
class SettingsState {
  final String selectedMode;
  final String selectedLanguage;
  final bool isDarkMode;
  
  SettingsState({
    this.selectedMode = AppConstants.patientMode,
    this.selectedLanguage = 'en',
    this.isDarkMode = false,
  });
  
  SettingsState copyWith({
    String? selectedMode,
    String? selectedLanguage,
    bool? isDarkMode,
  }) {
    return SettingsState(
      selectedMode: selectedMode ?? this.selectedMode,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

/// Settings provider
class SettingsNotifier extends StateNotifier<SettingsState> {
  final SharedPreferences _prefs;
  
  SettingsNotifier(this._prefs) : super(SettingsState()) {
    _loadSettings();
  }
  
  void _loadSettings() {
    final mode = _prefs.getString(AppConstants.keySelectedMode) ?? 
        AppConstants.patientMode;
    final language = _prefs.getString(AppConstants.keySelectedLanguage) ?? 'en';
    final isDark = _prefs.getBool(AppConstants.keyThemeMode) ?? false;
    
    state = SettingsState(
      selectedMode: mode,
      selectedLanguage: language,
      isDarkMode: isDark,
    );
  }
  
  Future<void> setMode(String mode) async {
    await _prefs.setString(AppConstants.keySelectedMode, mode);
    state = state.copyWith(selectedMode: mode);
  }
  
  Future<void> setLanguage(String language) async {
    await _prefs.setString(AppConstants.keySelectedLanguage, language);
    state = state.copyWith(selectedLanguage: language);
  }
  
  Future<void> setDarkMode(bool isDark) async {
    await _prefs.setBool(AppConstants.keyThemeMode, isDark);
    state = state.copyWith(isDarkMode: isDark);
  }
  
  bool get isPatientMode => state.selectedMode == AppConstants.patientMode;
  bool get isClinicianMode => state.selectedMode == AppConstants.clinicianMode;
}

/// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Settings provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return SettingsNotifier(prefs);
  },
);
