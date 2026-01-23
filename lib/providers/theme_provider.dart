import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'settings_provider.dart';

/// Theme provider that reacts to settings
final themeProvider = Provider<bool>((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.isDarkMode;
});
