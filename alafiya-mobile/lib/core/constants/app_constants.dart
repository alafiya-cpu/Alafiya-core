/// Application Constants
/// Centralized constant definitions for the application
class AppConstants {
  // App Information
  static const String appName = 'Al-Afiya Mobile';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Rehabilitation Center';

  // API Endpoints
  static const String apiBaseUrl = 'https://taaju.bitbirr.net';
  static const String authEndpoint = '/auth';
  static const String patientsEndpoint = '/patients';
  static const String treatmentsEndpoint = '/treatments';
  static const String paymentsEndpoint = '/payments';
  static const String notificationsEndpoint = '/notifications';
  static const String dischargeEndpoint = '/discharge';

  // SharedPreferences Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'current_user';
  static const String themeKey = 'app_theme';
  static const String languageKey = 'app_language';
  static const String firstLaunchKey = 'first_launch';
  static const String offlineDataKey = 'offline_data';
  static const String pushTokenKey = 'push_token';
  static const String biometricEnabledKey = 'biometric_enabled';

  // Cache Keys
  static const String cachePatientsKey = 'cached_patients';
  static const String cacheTreatmentsKey = 'cached_treatments';
  static const String cachePaymentsKey = 'cached_payments';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Form Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxEmailLength = 100;
  static const int maxPhoneLength = 15;
  static const int minPhoneLength = 10;

  // UI Dimensions
  static const double borderRadius = 8.0;
  static const double smallSpacing = 8.0;
  static const double mediumSpacing = 16.0;
  static const double largeSpacing = 24.0;
  static const double extraLargeSpacing = 32.0;

  static const double buttonHeight = 48.0;
  static const double inputFieldHeight = 56.0;
  static const double cardElevation = 2.0;

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 768.0;
  static const double tabletBreakpoint = 1024.0;

  // Network Configuration
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 30; // seconds
  static const int maxRetries = 3;

  // Date/Time Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String displayTimeFormat = 'h:mm a';
  static const String displayDateTimeFormat = 'MMM dd, yyyy h:mm a';

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];

  // Notification Channels
  static const String generalChannelId = 'general';
  static const String appointmentChannelId = 'appointments';
  static const String treatmentChannelId = 'treatments';
  static const String paymentChannelId = 'payments';
  static const String emergencyChannelId = 'emergency';

  // Regular Expressions
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^[\+]?[1-9][\d]{0,15}$';
  static const String nameRegex = r'^[a-zA-Z\s\-.]+$';

  // Local Storage Database
  static const String localDbName = 'alafiya_local.db';
  static const int localDbVersion = 1;

  // Feature Flags
  static const bool enableOfflineMode = true;
  static const bool enableBiometricAuth = true;
  static const bool enablePushNotifications = true;
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;

  // Error Messages
  static const String genericErrorMessage =
      'An unexpected error occurred. Please try again.';
  static const String networkErrorMessage =
      'No internet connection. Please check your network and try again.';
  static const String serverErrorMessage =
      'Server error. Please try again later.';
  static const String authenticationErrorMessage =
      'Authentication failed. Please login again.';
  static const String validationErrorMessage =
      'Please check your input and try again.';

  // Success Messages
  static const String saveSuccessMessage = 'Data saved successfully.';
  static const String deleteSuccessMessage = 'Data deleted successfully.';
  static const String updateSuccessMessage = 'Data updated successfully.';
  static const String loginSuccessMessage = 'Logged in successfully.';
  static const String logoutSuccessMessage = 'Logged out successfully.';

  // User Roles
  static const String adminRole = 'admin';
  static const String doctorRole = 'doctor';
  static const String nurseRole = 'nurse';
  static const String receptionistRole = 'receptionist';
  static const String managerRole = 'manager';

  // Patient Status
  static const String patientActive = 'active';
  static const String patientInactive = 'inactive';
  static const String patientDischarged = 'discharged';
  static const String patientAdmitted = 'admitted';

  // Treatment Status
  static const String treatmentPending = 'pending';
  static const String treatmentInProgress = 'in_progress';
  static const String treatmentCompleted = 'completed';
  static const String treatmentCancelled = 'cancelled';

  // Payment Status
  static const String paymentPending = 'pending';
  static const String paymentCompleted = 'completed';
  static const String paymentFailed = 'failed';
  static const String paymentRefunded = 'refunded';

  // Currency
  static const String defaultCurrency = 'ETB';
  static const String currencySymbol = r'Br';
}
