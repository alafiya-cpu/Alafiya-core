name: alafiya_mobile
description: Al-Afiya Mobile - Cross-platform healthcare management application
version: 1.0.0+1

environment:
  sdk: '>=3.5.0 <4.0.0'
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter
  
  # Core dependencies
  supabase_flutter: ^2.5.0
  provider: ^6.1.1
  riverpod: ^2.4.9
  shared_preferences: ^2.2.2
  drift: ^2.15.0
  sqlite3_flutter_libs: ^0.5.20
  path_provider: ^2.1.3
  connectivity_plus: ^5.0.2
  cached_network_image: ^3.3.0
  intl: ^0.18.1
  
  # UI and Navigation
  cupertino_icons: ^1.0.6
  flutter_svg: ^2.0.9
  google_fonts: ^6.1.0
  go_router: ^14.0.0
  
  # HTTP and Network
  dio: ^5.4.0
  http: ^1.1.2
  
  # UI Enhancement
  flutter_staggered_animations: ^1.1.1
  lottie: ^2.7.0
  
  # Local Storage and Database
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  
  # Device Features
  biometric_storage: ^5.0.0
  permission_handler: ^11.1.0
  
  # File Operations
  file_picker: ^6.1.1
  
  # Date and Time
  timeago: ^3.6.0
  
  # QR Code
  qr_flutter: ^4.1.0
  qr_code_scanner: ^1.0.1
  
  # Charts and Data Visualization
  fl_chart: ^0.66.2
  
  # Forms and Validation
  reactive_forms: ^16.1.0
  
  # Platform-specific
  device_info_plus: ^10.1.0
  package_info_plus: ^9.0.0
  
  # Logging
  logger: ^2.0.2+1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  drift_dev: ^2.15.0
  build_runner: ^2.4.7
  mockito: ^5.4.4
  flutter_launcher_icons: ^0.13.1
  hive_generator: ^2.0.0
  
  # Code Generation
  json_serializable: ^6.7.1
  json_annotation: ^4.8.1

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/
    - assets/animations/
    - assets/data/
  
  fonts:
    - family: AlAfiyaFont
      fonts:
        - asset: assets/fonts/AlAfiya-Regular.ttf
        - asset: assets/fonts/AlAfiya-Bold.ttf
          weight: 700