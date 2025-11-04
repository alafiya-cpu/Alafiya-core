import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/splash/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/patients/screens/patients_screen.dart';
import '../../features/treatments/screens/treatments_screen.dart';
import '../../features/payments/screens/payments_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/discharge/screens/discharge_screen.dart';

/// App Router Configuration
/// Manages navigation using Go Router
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash Screen Route (Entry Point)
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Authentication Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main App Routes
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/patients',
        name: 'patients',
        builder: (context, state) => const PatientsScreen(),
      ),
      GoRoute(
        path: '/treatments',
        name: 'treatments',
        builder: (context, state) => const TreatmentsScreen(),
      ),
      GoRoute(
        path: '/payments',
        name: 'payments',
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/discharge',
        name: 'discharge',
        builder: (context, state) => const DischargeScreen(),
      ),

      // Patient Detail Route
      GoRoute(
        path: '/patients/:patientId',
        name: 'patient-detail',
        builder: (context, state) {
          final patientId = state.pathParameters['patientId']!;
          return _buildPatientDetailScreen(patientId);
        },
      ),

      // Treatment Detail Route
      GoRoute(
        path: '/treatments/:treatmentId',
        name: 'treatment-detail',
        builder: (context, state) {
          final treatmentId = state.pathParameters['treatmentId']!;
          return _buildTreatmentDetailScreen(treatmentId);
        },
      ),
    ],
    errorBuilder: (context, state) => _buildErrorScreen(context, state),
  );

  /// Build patient detail screen
  static Widget _buildPatientDetailScreen(String patientId) {
    // This would be implemented with actual patient detail logic
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Details'),
      ),
      body: Center(
        child: Text('Patient ID: $patientId'),
      ),
    );
  }

  /// Build treatment detail screen
  static Widget _buildTreatmentDetailScreen(String treatmentId) {
    // This would be implemented with actual treatment detail logic
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treatment Details'),
      ),
      body: Center(
        child: Text('Treatment ID: $treatmentId'),
      ),
    );
  }

  /// Build error screen
  static Widget _buildErrorScreen(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.uri.path}" could not be found.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/dashboard'),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Navigation Helper Class
/// Provides easy navigation methods
class NavigationHelper {
  /// Go to login screen
  static void goToLogin(BuildContext context) {
    context.go('/login');
  }

  /// Go to register screen
  static void goToRegister(BuildContext context) {
    context.go('/register');
  }

  /// Go to dashboard
  static void goToDashboard(BuildContext context) {
    context.go('/dashboard');
  }

  /// Go to patients screen
  static void goToPatients(BuildContext context) {
    context.go('/patients');
  }

  /// Go to patient details
  static void goToPatientDetails(BuildContext context, String patientId) {
    context.go('/patients/$patientId');
  }

  /// Go to treatments screen
  static void goToTreatments(BuildContext context) {
    context.go('/treatments');
  }

  /// Go to treatment details
  static void goToTreatmentDetails(BuildContext context, String treatmentId) {
    context.go('/treatments/$treatmentId');
  }

  /// Go to payments screen
  static void goToPayments(BuildContext context) {
    context.go('/payments');
  }

  /// Go to notifications screen
  static void goToNotifications(BuildContext context) {
    context.go('/notifications');
  }

  /// Go to discharge screen
  static void goToDischarge(BuildContext context) {
    context.go('/discharge');
  }

  /// Go back to previous screen
  static bool canGoBack(BuildContext context) {
    return context.canPop();
  }

  /// Pop current screen
  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }
}