/// Application Configuration
/// Handles environment-specific settings and configuration
class AppConfig {
  // Environment URLs
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://vospbecazkmruxngevts.supabase.co',
  );

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZvc3BiZWNhemttcnV4bmdldnRzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIxNzU5MzQsImV4cCI6MjA3Nzc1MTkzNH0.0iGst4gRGI-FW1Hn0hPNvJIcn1G8yDj8l_gXDG_lY1k',
  );

  // App Information
  static const String appName = 'Al-Afiya Mobile';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Environment flags
  static const bool enableOfflineMode = bool.fromEnvironment(
    'ENABLE_OFFLINE_MODE',
    defaultValue: true,
  );

  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: true,
  );

  static const bool enableCrashReporting = bool.fromEnvironment(
    'ENABLE_CRASH_REPORTING',
    defaultValue: true,
  );

  // API Configuration
  static const String baseApiUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.yourdomain.com',
  );

  static const int apiTimeoutSeconds = 30;
  static const int maxRetries = 3;

  // Cache Configuration
  static const int maxCacheSize = 50 * 1024 * 1024; // 50MB
  static const int cacheExpiryDays = 7;

  // Database Configuration
  static const String localDatabaseName = 'alafiya_mobile.db';
  static const int localDatabaseVersion = 1;

  // Security Configuration
  static const int sessionTimeoutMinutes = 30;
  static const int maxLoginAttempts = 5;
  static const bool enableBiometricAuth = true;

  // Feature Flags
  static const bool enableTreatmentTracking = true;
  static const bool enablePaymentManagement = true;
  static const bool enableDischargeManagement = true;
  static const bool enableNotificationCenter = true;
  static const bool enableRealTimeUpdates = true;

  // Development Configuration
  static const bool isDebugMode = bool.fromEnvironment(
    'DEBUG_MODE',
    defaultValue: false,
  );

  static const bool enableNetworkLogging = bool.fromEnvironment(
    'ENABLE_NETWORK_LOGGING',
    defaultValue: false,
  );

  // Validation
  static bool get isValidEnvironment =>
      supabaseUrl.isNotEmpty &&
      supabaseAnonKey.isNotEmpty &&
      baseApiUrl.isNotEmpty;

  static String get debugInfo {
    return '''
    App: $appName
    Version: $appVersion ($appBuildNumber)
    Environment: ${isDebugMode ? 'Debug' : 'Production'}
    Offline Mode: $enableOfflineMode
    Analytics: $enableAnalytics
    Crash Reporting: $enableCrashReporting
    ''';
  }
}
