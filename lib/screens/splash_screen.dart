import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/constants.dart';
import '../config/theme.dart';
import 'login_screen.dart';
import 'role_selection_screen.dart';
import 'home_screen.dart';
import '../services/auth_service.dart';

/// Splash screen with app name and medical disclaimer
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    
    _startAnimationSequence();
  }

  Future<void> _startAnimationSequence() async {
    // 1. Appear (Fade In)
    await _controller.forward();
    
    // 2. Hold for a moment
    await Future.delayed(const Duration(seconds: 1));
    
    // 3. Disappear (Fade Out)
    await _controller.reverse();
    
    // 4. Navigate
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    
    if (user == null) {
      // No user -> Go to Login
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionDuration: Duration.zero, // Instant transition since we faded out
        ),
      );
    } else {
      // User exists -> Check Profile
      final authService = AuthService();
      final exists = await authService.checkUserExists(user.uid);
      
      if (!mounted) return;
      
      if (!exists) {
        // No profile -> Go to Role Selection
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
             pageBuilder: (_, __, ___) => const RoleSelectionScreen(),
             transitionDuration: Duration.zero,
          ),
        );
      } else {
        // Has profile -> Go to Home
        Navigator.of(context).pushReplacement(
           PageRouteBuilder(
             pageBuilder: (_, __, ___) => const HomeScreen(),
             transitionDuration: Duration.zero,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Matching dark background color from the logo
      backgroundColor: const Color(0xFF021118), 
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/splash_logo.jpg',
            fit: BoxFit.contain, // Ensures FULL image is visible without cropping
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
