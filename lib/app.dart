import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'config/theme.dart';
import 'providers/theme_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/splash_screen.dart';

/// Main application widget
class MedExplainApp extends ConsumerWidget {
  const MedExplainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeProvider);
    final settings = ref.watch(settingsProvider);
    
    // Get locale from settings
    final locale = Locale(settings.selectedLanguage);
    
    return MaterialApp(
      title: 'MedExplain AI',
      debugShowCheckedModeBanner: false,
      
      // Localization
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ta'),
      ],
      
      // Theme
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      // Home
      home: const SplashScreen(),
    );
  }
}
