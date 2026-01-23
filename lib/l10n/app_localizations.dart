import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MedExplain AI'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @privacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get privacyAndSecurity;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @darkModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Switch between light and dark theme'**
  String get darkModeSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoon;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @clearCache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// No description provided for @clearCacheSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get clearCacheSubtitle;

  /// No description provided for @clearCacheConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache?'**
  String get clearCacheConfirm;

  /// No description provided for @clearCacheMessage.
  ///
  /// In en, this message translates to:
  /// **'This will clear temporary files. Your saved data will not be affected.'**
  String get clearCacheMessage;

  /// No description provided for @cacheCleared.
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate App'**
  String get rateApp;

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your feedback on the store'**
  String get rateAppSubtitle;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @openSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get openSourceLicenses;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Sign Out?'**
  String get signOutConfirm;

  /// No description provided for @signOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @patient.
  ///
  /// In en, this message translates to:
  /// **'Patient'**
  String get patient;

  /// No description provided for @clinician.
  ///
  /// In en, this message translates to:
  /// **'Clinician'**
  String get clinician;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Simplify Your Medical Reports'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload or paste your medical report for an instant AI-powered explanation.'**
  String get homeSubtitle;

  /// No description provided for @uploadReport.
  ///
  /// In en, this message translates to:
  /// **'Upload Report'**
  String get uploadReport;

  /// No description provided for @uploadFiles.
  ///
  /// In en, this message translates to:
  /// **'Upload Files (PDF, Images, TXT)'**
  String get uploadFiles;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @uploadHelper.
  ///
  /// In en, this message translates to:
  /// **'Select one file or multiple images. PDFs and images support OCR.'**
  String get uploadHelper;

  /// No description provided for @pasteReportText.
  ///
  /// In en, this message translates to:
  /// **'Paste Report Text'**
  String get pasteReportText;

  /// No description provided for @pasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste your medical report here...'**
  String get pasteHint;

  /// No description provided for @analyzeReport.
  ///
  /// In en, this message translates to:
  /// **'Analyze Report'**
  String get analyzeReport;

  /// No description provided for @safetyNotice.
  ///
  /// In en, this message translates to:
  /// **'Your report is processed securely. No data is stored permanently.'**
  String get safetyNotice;

  /// No description provided for @pleaseEnterReport.
  ///
  /// In en, this message translates to:
  /// **'Please enter or upload a medical report'**
  String get pleaseEnterReport;

  /// No description provided for @analysisResults.
  ///
  /// In en, this message translates to:
  /// **'Analysis Results'**
  String get analysisResults;

  /// No description provided for @criticalFindingsDetected.
  ///
  /// In en, this message translates to:
  /// **'Critical findings detected'**
  String get criticalFindingsDetected;

  /// No description provided for @newAnalysis.
  ///
  /// In en, this message translates to:
  /// **'New Analysis'**
  String get newAnalysis;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No analysis results available'**
  String get noResults;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @whatThisMeans.
  ///
  /// In en, this message translates to:
  /// **'What This Means'**
  String get whatThisMeans;

  /// No description provided for @interpretation.
  ///
  /// In en, this message translates to:
  /// **'Interpretation'**
  String get interpretation;

  /// No description provided for @askYourDoctor.
  ///
  /// In en, this message translates to:
  /// **'Ask Your Doctor'**
  String get askYourDoctor;

  /// No description provided for @suggestedQuestions.
  ///
  /// In en, this message translates to:
  /// **'Suggested Questions'**
  String get suggestedQuestions;

  /// No description provided for @clinicalFindings.
  ///
  /// In en, this message translates to:
  /// **'Clinical Findings'**
  String get clinicalFindings;

  /// No description provided for @keyObservations.
  ///
  /// In en, this message translates to:
  /// **'Key Observations'**
  String get keyObservations;

  /// No description provided for @criticalValues.
  ///
  /// In en, this message translates to:
  /// **'Critical Values'**
  String get criticalValues;

  /// No description provided for @actionableFindings.
  ///
  /// In en, this message translates to:
  /// **'Actionable Findings'**
  String get actionableFindings;

  /// No description provided for @considerations.
  ///
  /// In en, this message translates to:
  /// **'Considerations'**
  String get considerations;

  /// No description provided for @recommendations.
  ///
  /// In en, this message translates to:
  /// **'Recommendations'**
  String get recommendations;

  /// No description provided for @references.
  ///
  /// In en, this message translates to:
  /// **'References'**
  String get references;

  /// No description provided for @sources.
  ///
  /// In en, this message translates to:
  /// **'Sources'**
  String get sources;

  /// No description provided for @disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Disclaimer'**
  String get disclaimer;

  /// No description provided for @analyzingReport.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your report...'**
  String get analyzingReport;

  /// No description provided for @aiProcessing.
  ///
  /// In en, this message translates to:
  /// **'Our AI is processing your medical document'**
  String get aiProcessing;

  /// No description provided for @extractingInfo.
  ///
  /// In en, this message translates to:
  /// **'Extracting key information'**
  String get extractingInfo;

  /// No description provided for @generatingExplanation.
  ///
  /// In en, this message translates to:
  /// **'Generating easy-to-understand explanation'**
  String get generatingExplanation;

  /// No description provided for @checkingRedFlags.
  ///
  /// In en, this message translates to:
  /// **'Checking for important findings'**
  String get checkingRedFlags;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Safe, AI-powered medical report explanations'**
  String get loginSubtitle;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select Your Role'**
  String get selectRole;

  /// No description provided for @selectRoleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This helps us personalize your experience'**
  String get selectRoleSubtitle;

  /// No description provided for @iAmPatient.
  ///
  /// In en, this message translates to:
  /// **'I am a Patient'**
  String get iAmPatient;

  /// No description provided for @patientDesc.
  ///
  /// In en, this message translates to:
  /// **'Get simple, easy-to-understand explanations of your medical reports'**
  String get patientDesc;

  /// No description provided for @iAmClinician.
  ///
  /// In en, this message translates to:
  /// **'I am a Clinician'**
  String get iAmClinician;

  /// No description provided for @clinicianDesc.
  ///
  /// In en, this message translates to:
  /// **'Get detailed clinical analysis and professional insights'**
  String get clinicianDesc;

  /// No description provided for @clinicianProfile.
  ///
  /// In en, this message translates to:
  /// **'Clinician Profile'**
  String get clinicianProfile;

  /// No description provided for @setupProfessionalProfile.
  ///
  /// In en, this message translates to:
  /// **'Set up your professional profile'**
  String get setupProfessionalProfile;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @clinicHospitalName.
  ///
  /// In en, this message translates to:
  /// **'Clinic / Hospital Name'**
  String get clinicHospitalName;

  /// No description provided for @specialtyOptional.
  ///
  /// In en, this message translates to:
  /// **'Specialty (Optional)'**
  String get specialtyOptional;

  /// No description provided for @clinicAddressOptional.
  ///
  /// In en, this message translates to:
  /// **'Clinic Address (Optional)'**
  String get clinicAddressOptional;

  /// No description provided for @completeSetup.
  ///
  /// In en, this message translates to:
  /// **'Complete Setup'**
  String get completeSetup;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @patientProfile.
  ///
  /// In en, this message translates to:
  /// **'Patient Profile'**
  String get patientProfile;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself'**
  String get tellUsAboutYourself;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @invalidAge.
  ///
  /// In en, this message translates to:
  /// **'Invalid age'**
  String get invalidAge;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @historyComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Global History Coming Soon'**
  String get historyComingSoon;

  /// No description provided for @noHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No analysis history yet'**
  String get noHistoryYet;

  /// No description provided for @historyFeatureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'History feature coming soon!'**
  String get historyFeatureComingSoon;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @medicalDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'MEDICAL DISCLAIMER: This application provides informational explanations only and does NOT constitute medical advice, diagnosis, or treatment. Always consult with a qualified healthcare provider for medical decisions.'**
  String get medicalDisclaimer;

  /// No description provided for @footerDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Not medical advice • Consult your doctor'**
  String get footerDisclaimer;

  /// No description provided for @errorSavingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error saving profile'**
  String get errorSavingProfile;

  /// No description provided for @exportedTo.
  ///
  /// In en, this message translates to:
  /// **'Analysis exported to'**
  String get exportedTo;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @appStoreLinkComingSoon.
  ///
  /// In en, this message translates to:
  /// **'App store link coming soon!'**
  String get appStoreLinkComingSoon;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error loading profile'**
  String get errorLoadingProfile;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
