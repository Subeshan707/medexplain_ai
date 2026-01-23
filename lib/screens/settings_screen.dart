import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../l10n/app_localizations.dart';
import '../config/constants.dart';
import '../config/theme.dart';
import '../providers/settings_provider.dart';
import '../providers/user_provider.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'history_screen.dart';

/// Professional Settings Screen with Localization
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final userProfileAsync = ref.watch(userProfileProvider);
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        foregroundColor: Theme.of(context).appBarTheme.foregroundColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Account Section
          _buildSectionHeader(context, l10n.account),
          userProfileAsync.when(
            data: (profile) => _buildProfileCard(context, ref, profile, l10n),
            loading: () => const Center(child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            )),
            error: (_, __) => _buildProfileCard(context, ref, null, l10n),
          ),
          
          const SizedBox(height: 8),
          
          // History tile
          _buildSettingsTile(
            context: context,
            icon: Icons.history,
            title: l10n.history,
            subtitle: 'View past analyses',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Appearance Section
          _buildSectionHeader(context, l10n.appearance),
          _buildSettingsTile(
            context: context,
            icon: Icons.dark_mode,
            title: l10n.darkMode,
            subtitle: l10n.darkModeSubtitle,
            trailing: Switch(
              value: settings.isDarkMode,
              onChanged: (value) {
                ref.read(settingsProvider.notifier).setDarkMode(value);
              },
              activeColor: AppTheme.primaryBlue,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Preferences Section
          _buildSectionHeader(context, l10n.preferences),
          _buildSettingsTile(
            context: context,
            icon: Icons.language,
            title: l10n.language,
            subtitle: AppConstants.supportedLanguages[settings.selectedLanguage] ?? 'English',
            onTap: () => _showLanguageDialog(context, ref, settings.selectedLanguage, l10n),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.notifications_outlined,
            title: l10n.notifications,
            subtitle: l10n.comingSoon,
            enabled: false,
          ),
          
          const SizedBox(height: 16),
          
          // Privacy & Security Section
          _buildSectionHeader(context, l10n.privacyAndSecurity),
          _buildSettingsTile(
            context: context,
            icon: Icons.privacy_tip_outlined,
            title: l10n.privacyPolicy,
            onTap: () => _launchUrl('https://example.com/privacy'),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.description_outlined,
            title: l10n.termsOfService,
            onTap: () => _launchUrl('https://example.com/terms'),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.delete_outline,
            title: l10n.clearCache,
            subtitle: l10n.clearCacheSubtitle,
            onTap: () => _showClearCacheDialog(context, l10n),
          ),
          
          const SizedBox(height: 16),
          
          // About Section
          _buildSectionHeader(context, l10n.about),
          _buildSettingsTile(
            context: context,
            icon: Icons.info_outline,
            title: l10n.appVersion,
            subtitle: 'v${AppConstants.appVersion}',
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.star_outline,
            title: l10n.rateApp,
            subtitle: l10n.rateAppSubtitle,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.appStoreLinkComingSoon)),
              );
            },
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.feedback_outlined,
            title: l10n.sendFeedback,
            onTap: () => _launchUrl('mailto:support@medexplain.ai?subject=MedExplain%20AI%20Feedback'),
          ),
          _buildSettingsTile(
            context: context,
            icon: Icons.code,
            title: l10n.openSourceLicenses,
            onTap: () => showLicensePage(
              context: context,
              applicationName: AppConstants.appName,
              applicationVersion: AppConstants.appVersion,
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Sign Out Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton.icon(
              onPressed: () => _handleSignOut(context, ref, l10n),
              icon: const Icon(Icons.logout, color: AppTheme.alertRed),
              label: Text(l10n.signOut, style: const TextStyle(color: AppTheme.alertRed)),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: AppTheme.alertRed),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppTheme.primaryBlue,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context, WidgetRef ref, UserProfile? profile, AppLocalizations l10n) {
    final String roleBadge = profile?.role == 'clinician' 
        ? '👨‍⚕️ ${l10n.clinician}' 
        : '👤 ${l10n.patient}';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundImage: profile?.photoUrl != null 
                  ? NetworkImage(profile!.photoUrl!) 
                  : null,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: profile?.photoUrl == null 
                  ? Icon(Icons.person, size: 32, color: Theme.of(context).colorScheme.primary)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile?.name ?? l10n.user,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    profile?.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      roleBadge,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool enabled = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        enabled: enabled,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark 
                ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                : AppTheme.lightSurface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: enabled 
              ? Theme.of(context).colorScheme.primary 
              : Theme.of(context).textTheme.bodySmall?.color),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: enabled 
                ? Theme.of(context).textTheme.bodyLarge?.color 
                : Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        subtitle: subtitle != null 
            ? Text(subtitle, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color))
            : null,
        trailing: trailing ?? (onTap != null 
            ? Icon(Icons.chevron_right, color: Theme.of(context).textTheme.bodySmall?.color)
            : null),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, String currentLanguage, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AppConstants.supportedLanguages.entries.map((entry) {
            final isSelected = entry.key == currentLanguage;
            return ListTile(
              title: Text(entry.value),
              trailing: isSelected 
                  ? const Icon(Icons.check, color: AppTheme.primaryBlue)
                  : null,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              selected: isSelected,
              selectedTileColor: AppTheme.primaryBlue.withOpacity(0.1),
              onTap: () {
                ref.read(settingsProvider.notifier).setLanguage(entry.key);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearCacheConfirm),
        content: Text(l10n.clearCacheMessage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.cacheCleared)),
              );
            },
            child: Text(l10n.clearCache, style: const TextStyle(color: AppTheme.alertRed)),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOutConfirm),
        content: Text(l10n.signOutMessage),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.signOut, style: const TextStyle(color: AppTheme.alertRed)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService().signOut();
      ref.read(userProfileProvider.notifier).clear();
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }
}
