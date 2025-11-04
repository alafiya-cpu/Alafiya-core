import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/providers/auth_provider_notifier.dart';
import '../../../shared/widgets/app_router.dart';

/// Splash Screen Widget
/// Shows app logo and checks authentication status
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  /// Navigate to the appropriate screen based on authentication status
  Future<void> _navigateToNextScreen() async {
    // Wait for minimum splash screen duration
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Wait for authentication to finish loading
    final authProviderInstance = ref.read(authProvider.notifier);
    
    // Wait while auth is still loading
    while (authProviderInstance.isLoading && mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    
    if (!mounted) return;
    
    // Check authentication status and navigate
    final authState = ref.read(authProvider);
    final isAuthenticated = authState.isAuthenticated;
    
    if (isAuthenticated) {
      // User is authenticated, go to dashboard
      NavigationHelper.goToDashboard(context);
    } else {
      // User is not authenticated, go to login
      NavigationHelper.goToLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 0.8,
            colors: [
              const Color(0xFF0C2D57), // Trust Blue
              const Color(0xFF001833), // Darker blue
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered logo
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.medical_services,
                            size: 80,
                            color: Color(0xFF0C2D57),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // "Al Afiya" - Gold Harmony
                  const Text(
                    'Al Afiya',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w600, // SemiBold
                      color: Color(0xFFD4AF37), // Gold Harmony
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // "Rehabilitation Center" - White
                  const Text(
                    'Rehabilitation Center',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFFFFFFF), // White
                      fontWeight: FontWeight.normal, // Regular
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom section with location and powered by
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                children: [
                  // Subtext - Muted White
                  const Text(
                    'Dr. Tajudin Adem, Jigjiga, Ethiopia',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFE3E7ED), // Muted White
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Powered by BitBirr
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFE3E7ED),
                        fontStyle: FontStyle.italic,
                      ),
                      children: [
                        TextSpan(text: 'Powered by '),
                        TextSpan(
                          text: 'BitBirr',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD4AF37),
                          ),
                        ),
                      ],
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
}