import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/constants.dart';
import '../config/theme.dart';
import '../providers/settings_provider.dart';

/// Mode selector widget for patient/clinician toggle
class ModeSelector extends ConsumerWidget {
  const ModeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final isPatientMode = settings.selectedMode == AppConstants.patientMode;
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.tune, color: AppTheme.primaryBlue),
                const SizedBox(width: 8),
                Text(
                  'Select Mode',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.neutralBlack,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _ModeOption(
                    icon: Icons.person,
                    title: 'Patient',
                    description: 'Simple, easy-to-understand explanations',
                    isSelected: isPatientMode,
                    onTap: () {
                      ref.read(settingsProvider.notifier)
                          .setMode(AppConstants.patientMode);
                    },
                  ),
                ),
                
                const SizedBox(width: 12),
                
                Expanded(
                  child: _ModeOption(
                    icon: Icons.medical_services,
                    title: 'Clinician',
                    description: 'Detailed clinical analysis',
                    isSelected: !isPatientMode,
                    onTap: () {
                      ref.read(settingsProvider.notifier)
                          .setMode(AppConstants.clinicianMode);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _ModeOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppTheme.primaryBlue.withOpacity(0.1) 
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? AppTheme.primaryBlue 
                : AppTheme.black,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? AppTheme.primaryBlue : AppTheme.black,
            ),
            
            const SizedBox(height: 6),
            
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppTheme.primaryBlue : AppTheme.black,
              ),
            ),
            
            const SizedBox(height: 2),
            
            Text(
              description,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.black,
                fontSize: 11,
              ),
            ),
            
            if (isSelected) ...[
              const SizedBox(height: 4),
              const Icon(
                Icons.check_circle,
                size: 16,
                color: AppTheme.primaryBlue,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
