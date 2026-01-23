import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/theme.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'patient_onboarding_screen.dart';
import 'clinician_onboarding_screen.dart';

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  void _selectRole(String role) {
    if (role == 'patient') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PatientOnboardingScreen()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const ClinicianOnboardingScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightSurface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              const Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkBlue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Please select your role to customize your experience:',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 48),
              
              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                // Patient Card
                _buildRoleCard(
                  title: 'I am a Patient',
                  description: 'I want to understand my medical reports in simple language.',
                  icon: Icons.person,
                  role: 'patient',
                ),
                
                const SizedBox(height: 24),
                
                // Clinician Card
                _buildRoleCard(
                  title: 'I am a Clinician',
                  description: 'I want detailed technical summaries for clinical review.',
                  icon: Icons.medical_services,
                  role: 'clinician',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard({
    required String title,
    required String description,
    required IconData icon,
    required String role,
  }) {
    return InkWell(
      onTap: () => _selectRole(role),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.lightSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: AppTheme.primaryBlue),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkBlue,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppTheme.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
