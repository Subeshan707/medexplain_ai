/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'MedExplain AI';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  // IMPORTANT: Update this URL to your n8n instance
  // Development: http://localhost:5678/webhook/medexplain-analyze
  // Production: https://your-domain.com/webhook/medexplain-analyze
  static const String analysisWebhookUrl = String.fromEnvironment(
    'ANALYSIS_WEBHOOK_URL',
    defaultValue: 'https://n8n-production-4ec8.up.railway.app/webhook/medexplain-analyze');
    
  static const String chatWebhookUrl = String.fromEnvironment(
    'CHAT_WEBHOOK_URL',
    defaultValue: 'https://primary-production-71b6a8.up.railway.app/webhook/medexplain-analyze');
  
  // Timeout Configuration
  // Increased to handle Railway cold starts (30-60s on first request)
  static const Duration networkTimeout = Duration(seconds: 90);
  
  // Medical Disclaimers
  static const String primaryDisclaimer = 
      'MEDICAL DISCLAIMER: This application provides informational explanations '
      'only and does NOT constitute medical advice, diagnosis, or treatment. '
      'Always consult with a qualified healthcare provider for medical decisions.';
  
  static const String splashDisclaimer = 
      '⚕️ This app explains medical reports but does not provide diagnosis or treatment.\n\n'
      'Always consult your healthcare provider for medical advice.';
  
  static const String footerDisclaimer = 
      'Not medical advice • Consult your doctor';
  
  // Mode Options
  static const String patientMode = 'patient';
  static const String clinicianMode = 'clinician';
  
  // Language Options
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'ta': 'தமிழ் (Tamil)',
    // Future: Add more languages
    // 'es': 'Spanish',
    // 'hi': 'Hindi',
  };
  
  // SharedPreferences Keys
  static const String keySelectedMode = 'selected_mode';
  static const String keySelectedLanguage = 'selected_language';
  static const String keyThemeMode = 'theme_mode';
  static const String keyDisclaimerAccepted = 'disclaimer_accepted';
  
  // File Upload
  static const List<String> allowedFileExtensions = ['pdf', 'txt', 'jpg', 'jpeg', 'png'];
  static const int maxFileSizeBytes = 10 * 1024 * 1024; // 10MB
  static const int maxImagesPerUpload = 5;
  
  // Red Flag Keywords (for UI highlighting)
  static const List<String> redFlagKeywords = [
    'malignant',
    'cancer',
    'tumor',
    'critical',
    'urgent',
    'emergency',
    'stroke',
    'heart attack',
    'myocardial infarction',
    'severe',
    'life-threatening',
  ];
  
  // Trusted Medical Sources
  static const List<String> trustedSources = [
    'RSNA - Radiological Society of North America',
    'CDC - Centers for Disease Control and Prevention',
    'NIH - National Institutes of Health',
    'WHO - World Health Organization',
    'Mayo Clinic',
    'Johns Hopkins Medicine',
  ];
  
  // Animation Durations
  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Responsive Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
}
