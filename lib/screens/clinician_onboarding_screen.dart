import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/theme.dart';
import '../services/auth_service.dart';
import '../models/user_profile.dart';
import 'home_screen.dart';

class ClinicianOnboardingScreen extends StatefulWidget {
  const ClinicianOnboardingScreen({super.key});

  @override
  State<ClinicianOnboardingScreen> createState() => _ClinicianOnboardingScreenState();
}

class _ClinicianOnboardingScreenState extends State<ClinicianOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _clinicNameController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _addressController = TextEditingController();
  
  bool _isLoading = false;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Pre-fill name from Google Auth if available
    final user = FirebaseAuth.instance.currentUser;
    if (user?.displayName != null) {
      _nameController.text = user!.displayName!;
    }
  }

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final profile = UserProfile(
        uid: user.uid,
        email: user.email ?? '',
        role: 'clinician',
        name: _nameController.text.trim(),
        photoUrl: user.photoURL,
        clinicName: _clinicNameController.text.trim(),
        specialty: _specialtyController.text.trim(),
        clinicAddress: _addressController.text.trim(),
        createdAt: DateTime.now(),
      );

      await _authService.saveUserProfile(profile.toJson());

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightSurface,
      appBar: AppBar(
        title: const Text('Clinician Profile'),
        backgroundColor: AppTheme.lightSurface,
        elevation: 0,
        foregroundColor: AppTheme.darkBlue,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Set up your professional profile',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 32),
                
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  icon: Icons.person,
                  validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _clinicNameController,
                  label: 'Clinic / Hospital Name',
                  icon: Icons.local_hospital,
                  validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _specialtyController,
                  label: 'Specialty (Optional)',
                  icon: Icons.medical_services,
                ),
                const SizedBox(height: 16),
                
                _buildTextField(
                  controller: _addressController,
                  label: 'Clinic Address (Optional)',
                  icon: Icons.location_on,
                  maxLines: 2,
                ),
                
                const SizedBox(height: 48),
                
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppTheme.primaryBlue,
                    foregroundColor: AppTheme.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20, width: 20, 
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                        )
                      : const Text('Complete Setup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppTheme.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
        ),
        filled: true,
        fillColor: AppTheme.white,
      ),
    );
  }
}
