// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// Al Afiya Rehabilitation Center - Enhanced Design System
/// "Healing with Compassion and Dignity"
/// Location: Jigjiga, Ethiopia | Powered by BitBirr
///
/// Brand Values:
/// - Trust & Care: Compassion, community, and confidentiality
/// - Professionalism: Clinical precision with warmth  
/// - Faith & Healing: Integrates wellness with moral and cultural care
class AlAfiyaDesignSystem {
  // ===========================================
  // CORE BRAND COLORS
  // ===========================================
  
  // Primary Brand Colors
  static const Color trustBlue = Color(0xFF0C2D57);        // Primary - calm, reliability, clinical trust
  static const Color goldHarmony = Color(0xFFD4AF37);      // Secondary - hope, recovery, optimism
  static const Color medicalGreen = Color(0xFF2E7D32);     // Accent 1 - growth and renewal
  static const Color skyWhite = Color(0xFFF5F9FF);         // Accent 2 - clean background, accessibility
  static const Color deepNavy = Color(0xFF0A192F);         // Neutral/Text - professional typography
  
  // Semantic Colors
  static const Color successGreen = Color(0xFF388E3C);     // Healing/recovery states
  static const Color warningAmber = Color(0xFFF9A825);     // Alerts and important actions
  static const Color errorRed = Color(0xFFD32F2F);         // Clinical errors/missed entries
  static const Color infoBlue = Color(0xFF1976D2);         // Informational and calm states
  
  // ===========================================
  // BRAND COLOR VARIATIONS
  // ===========================================
  
  // Trust Blue Variations
  static const Color trustBlueLight = Color(0xFF4A6FA5);
  static const Color trustBlueLighter = Color(0xFF7C9BC8);
  static const Color trustBlueDark = Color(0xFF081E3F);
  static const Color trustBlueDarker = Color(0xFF041427);
  
  // Gold Harmony Variations
  static const Color goldHarmonyLight = Color(0xFFDEC47A);
  static const Color goldHarmonyLighter = Color(0xFFE8DDA8);
  static const Color goldHarmonyDark = Color(0xFFB8962E);
  static const Color goldHarmonyDarker = Color(0xFF8A7321);
  
  // Medical Green Variations
  static const Color medicalGreenLight = Color(0xFF5FA667);
  static const Color medicalGreenLighter = Color(0xFF8BCB8F);
  static const Color medicalGreenDark = Color(0xFF1E5A22);
  static const Color medicalGreenDarker = Color(0xFF153C17);
  
  // ===========================================
  // NEUTRAL PALETTE
  // ===========================================
  
  static const Color neutralWhite = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF8FAFC);
  static const Color neutral100 = Color(0xFFF1F5F9);
  static const Color neutral200 = Color(0xFFE2E8F0);
  static const Color neutral300 = Color(0xFFCBD5E1);
  static const Color neutral400 = Color(0xFF94A3B8);
  static const Color neutral500 = Color(0xFF64748B);
  static const Color neutral600 = Color(0xFF475569);
  static const Color neutral700 = Color(0xFF334155);
  static const Color neutral800 = Color(0xFF1E293B);
  static const Color neutral900 = Color(0xFF0F172A);
  static const Color neutral950 = Color(0xFF020617);
  
  // ===========================================
  // SEMANTIC STATE COLORS
  // ===========================================
  
  // Success States
  static const Color success50 = Color(0xFFF0FDF4);
  static const Color success100 = Color(0xFFDCFCE7);
  static const Color success200 = Color(0xFFBBF7D0);
  static const Color success300 = Color(0xFF86EFAC);
  static const Color success400 = Color(0xFF4ADE80);
  static const Color success500 = successGreen;
  static const Color success600 = Color(0xFF16A34A);
  static const Color success700 = Color(0xFF15803D);
  static const Color success800 = Color(0xFF166534);
  static const Color success900 = Color(0xFF14532D);
  
  // Warning States
  static const Color warning50 = Color(0xFFFFFBEB);
  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning200 = Color(0xFFFDE68A);
  static const Color warning300 = Color(0xFFFCD34D);
  static const Color warning400 = Color(0xFFFBBF24);
  static const Color warning500 = warningAmber;
  static const Color warning600 = Color(0xFFD97706);
  static const Color warning700 = Color(0xFFB45309);
  static const Color warning800 = Color(0xFF92400E);
  static const Color warning900 = Color(0xFF78350F);
  
  // Error States
  static const Color error50 = Color(0xFFFEF2F2);
  static const Color error100 = Color(0xFFFEE2E2);
  static const Color error200 = Color(0xFFFECACA);
  static const Color error300 = Color(0xFFFCA5A5);
  static const Color error400 = Color(0xFFF87171);
  static const Color error500 = errorRed;
  static const Color error600 = Color(0xFFDC2626);
  static const Color error700 = Color(0xFFB91C1C);
  static const Color error800 = Color(0xFF991B1B);
  static const Color error900 = Color(0xFF7F1D1D);
  
  // Info States
  static const Color info50 = Color(0xFFEFF6FF);
  static const Color info100 = Color(0xFFDBEAFE);
  static const Color info200 = Color(0xFFBFDBFE);
  static const Color info300 = Color(0xFF93C5FD);
  static const Color info400 = Color(0xFF60A5FA);
  static const Color info500 = infoBlue;
  static const Color info600 = Color(0xFF2563EB);
  static const Color info700 = Color(0xFF1D4ED8);
  static const Color info800 = Color(0xFF1E40AF);
  static const Color info900 = Color(0xFF1E3A8A);
  
  // ===========================================
  // SPACING SYSTEM (8pt Grid)
  // ===========================================
  
  static const double spaceXS = 4.0;    // 0.5 * 8
  static const double spaceS = 8.0;     // 1 * 8
  static const double spaceM = 16.0;    // 2 * 8
  static const double spaceL = 24.0;    // 3 * 8
  static const double spaceXL = 32.0;   // 4 * 8
  static const double spaceXXL = 40.0;  // 5 * 8
  static const double spaceXXXL = 48.0; // 6 * 8
  static const double spaceXXXXL = 64.0; // 8 * 8
  
  // ===========================================
  // TYPOGRAPHY SYSTEM
  // ===========================================
  
  // Base font configuration
  static const double baseFontSize = 16.0;
  static const double typeScale = 1.25; // Major third scale
  
  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight normal = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semibold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  // Brand Typography Scale using AlAfiya Font
  static TextStyle get displayLarge => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 57.0,        // baseFontSize * typeScale³
    fontWeight: bold,
    color: deepNavy,
    height: 1.12,
    letterSpacing: -0.25,
  );
  
  static TextStyle get displayMedium => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 45.0,        // baseFontSize * typeScale²
    fontWeight: semibold,
    color: deepNavy,
    height: 1.16,
    letterSpacing: 0.0,
  );
  
  static TextStyle get displaySmall => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 36.0,        // baseFontSize * typeScale
    fontWeight: semibold,
    color: deepNavy,
    height: 1.22,
    letterSpacing: 0.0,
  );
  
  static TextStyle get headlineLarge => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 32.0,
    fontWeight: bold,
    color: deepNavy,
    height: 1.25,
    letterSpacing: 0.0,
  );
  
  static TextStyle get headlineMedium => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 28.0,
    fontWeight: semibold,
    color: deepNavy,
    height: 1.29,
    letterSpacing: 0.0,
  );
  
  static TextStyle get headlineSmall => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 24.0,
    fontWeight: semibold,
    color: deepNavy,
    height: 1.33,
    letterSpacing: 0.0,
  );
  
  static TextStyle get titleLarge => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 22.0,
    fontWeight: semibold,
    color: deepNavy,
    height: 1.27,
    letterSpacing: 0.0,
  );
  
  static TextStyle get titleMedium => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 16.0,        // baseFontSize
    fontWeight: medium,
    color: deepNavy,
    height: 1.5,
    letterSpacing: 0.15,
  );
  
  static TextStyle get titleSmall => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 14.0,
    fontWeight: medium,
    color: neutral600,
    height: 1.43,
    letterSpacing: 0.1,
  );
  
  static TextStyle get bodyLarge => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 16.0,
    fontWeight: normal,
    color: deepNavy,
    height: 1.5,
    letterSpacing: 0.5,
  );
  
  static TextStyle get bodyMedium => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 14.0,
    fontWeight: normal,
    color: deepNavy,
    height: 1.43,
    letterSpacing: 0.25,
  );
  
  static TextStyle get bodySmall => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 12.0,
    fontWeight: normal,
    color: neutral600,
    height: 1.33,
    letterSpacing: 0.4,
  );
  
  static TextStyle get labelLarge => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 14.0,
    fontWeight: medium,
    color: deepNavy,
    height: 1.43,
    letterSpacing: 0.1,
  );
  
  static TextStyle get labelMedium => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 12.0,
    fontWeight: medium,
    color: deepNavy,
    height: 1.33,
    letterSpacing: 0.5,
  );
  
  static TextStyle get labelSmall => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 11.0,
    fontWeight: medium,
    color: neutral600,
    height: 1.45,
    letterSpacing: 0.5,
  );
  
  // Button Text Styles
  static TextStyle get buttonLarge => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 15.0,
    fontWeight: medium,
    color: neutralWhite,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  static TextStyle get buttonMedium => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 14.0,
    fontWeight: medium,
    color: neutralWhite,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  static TextStyle get buttonSmall => const TextStyle(
    fontFamily: 'AlAfiya',
    fontSize: 13.0,
    fontWeight: medium,
    color: neutralWhite,
    height: 1.2,
    letterSpacing: 0.1,
  );
  
  // ===========================================
  // COMPONENT DESIGN TOKENS
  // ===========================================
  
  // Border Radius
  static const double radiusXS = 4.0;
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 20.0;
  static const double radiusXXL = 24.0;
  static const double radiusFull = 9999.0;
  
  // Elevation Shadows
  static const double elevationNone = 0.0;
  static const double elevationXS = 1.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 16.0;
  static const double elevationXXL = 24.0;
  
  // Opacity Levels
  static const double opacityNone = 0.0;
  static const double opacityXS = 0.04;
  static const double opacityS = 0.08;
  static const double opacityM = 0.12;
  static const double opacityL = 0.16;
  static const double opacityXL = 0.24;
  static const double opacityXXL = 0.32;
  
  // ===========================================
  // UTILITY METHODS
  // ===========================================
  
  /// Get color by semantic role
  static Color getColorByRole(ColorRole role) {
    switch (role) {
      case ColorRole.primary:
        return trustBlue;
      case ColorRole.secondary:
        return goldHarmony;
      case ColorRole.accent:
        return medicalGreen;
      case ColorRole.background:
        return skyWhite;
      case ColorRole.surface:
        return neutralWhite;
      case ColorRole.success:
        return successGreen;
      case ColorRole.warning:
        return warningAmber;
      case ColorRole.error:
        return errorRed;
      case ColorRole.info:
        return infoBlue;
      case ColorRole.textPrimary:
        return deepNavy;
      case ColorRole.textSecondary:
        return neutral600;
      case ColorRole.textDisabled:
        return neutral400;
      case ColorRole.divider:
        return neutral200;
      case ColorRole.overlay:
        return neutral900.withOpacity(opacityL);
    }
  }
  
  /// Get appropriate text color for given background
  static Color getTextColorForBackground(Color backgroundColor) {
    // Calculate luminance to determine if text should be light or dark
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? deepNavy : neutralWhite;
  }
  
  /// Get status color based on status string
  static Color getStatusColor(String status) {
    final normalizedStatus = status.toLowerCase();
    
    switch (normalizedStatus) {
      case 'active':
      case 'completed':
      case 'success':
      case 'approved':
      case 'confirmed':
      case 'healed':
      case 'recovered':
        return successGreen;
        
      case 'pending':
      case 'scheduled':
      case 'in_progress':
      case 'processing':
      case 'waiting':
        return warningAmber;
        
      case 'error':
      case 'failed':
      case 'cancelled':
      case 'rejected':
      case 'critical':
        return errorRed;
        
      case 'info':
      case 'notice':
      case 'informational':
        return infoBlue;
        
      case 'draft':
      case 'disabled':
      case 'inactive':
      case 'paused':
        return neutral400;
        
      default:
        return neutral600;
    }
  }
  
  /// Generate card shadow based on elevation
  static List<BoxShadow> getCardShadow({
    Color? color,
    double elevation = elevationM,
  }) {
    final shadowColor = color ?? neutral900;
    final shadows = <BoxShadow>[];
    
    switch (elevation) {
      case elevationXS:
        shadows.addAll([
          BoxShadow(
            color: shadowColor.withOpacity(opacityXS),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ]);
        break;
        
      case elevationS:
        shadows.addAll([
          BoxShadow(
            color: shadowColor.withOpacity(opacityS),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(opacityXS),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ]);
        break;
        
      case elevationM:
        shadows.addAll([
          BoxShadow(
            color: shadowColor.withOpacity(opacityM),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(opacityS),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ]);
        break;
        
      case elevationL:
        shadows.addAll([
          BoxShadow(
            color: shadowColor.withOpacity(opacityL),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(opacityM),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ]);
        break;
        
      case elevationXL:
        shadows.addAll([
          BoxShadow(
            color: shadowColor.withOpacity(opacityXL),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(opacityL),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]);
        break;
        
      case elevationXXL:
        shadows.addAll([
          BoxShadow(
            color: shadowColor.withOpacity(opacityXXL),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(opacityXL),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: shadowColor.withOpacity(opacityL),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ]);
        break;
    }
    
    return shadows;
  }
  
  /// Generate button shadow
  static List<BoxShadow> getButtonShadow({
    Color? color,
    bool pressed = false,
  }) {
    final shadowColor = color ?? trustBlue;
    return [
      BoxShadow(
        color: shadowColor.withOpacity(pressed ? opacityXS : opacityL),
        blurRadius: pressed ? 2 : 8,
        offset: Offset(0, pressed ? 1 : 4),
      ),
    ];
  }
  
  // ===========================================
  // RESPONSIVE HELPERS
  // ===========================================
  
  /// Check if device is tablet size
  static bool isTablet(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth >= 768;
  }
  
  /// Check if device is mobile size
  static bool isMobile(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth < 768;
  }
  
  /// Get screen padding based on device type
  static EdgeInsetsGeometry getScreenPadding(BuildContext context) {
    return isMobile(context)
        ? const EdgeInsets.all(spaceM)
        : EdgeInsets.symmetric(
            horizontal: spaceXXL,
            vertical: spaceL,
          );
  }
  
  /// Get card padding based on device type
  static EdgeInsetsGeometry getCardPadding(BuildContext context) {
    return isMobile(context)
        ? const EdgeInsets.all(spaceM)
        : const EdgeInsets.all(spaceL);
  }
  
  /// Get responsive text style based on device type
  static TextStyle getResponsiveTextStyle(
    TextStyle mobileStyle,
    TextStyle tabletStyle,
    BuildContext context,
  ) {
    return isMobile(context) ? mobileStyle : tabletStyle;
  }
}

// ===========================================
// COLOR ROLE ENUM
// ===========================================

enum ColorRole {
  primary,
  secondary,
  accent,
  background,
  surface,
  success,
  warning,
  error,
  info,
  textPrimary,
  textSecondary,
  textDisabled,
  divider,
  overlay,
}

// ===========================================
// BRAND EXTENSIONS
// ===========================================

extension ColorExtensions on Color {
  /// Get lighter version of this color
  Color lighter([double factor = 0.1]) {
    assert(factor >= 0 && factor <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = hsl.lightness + (1 - hsl.lightness) * factor;
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Get darker version of this color
  Color darker([double factor = 0.1]) {
    assert(factor >= 0 && factor <= 1);
    final hsl = HSLColor.fromColor(this);
    final lightness = hsl.lightness * (1 - factor);
    return hsl.withLightness(lightness).toColor();
  }
  
  /// Check if this color is considered light
  bool get isLight => computeLuminance() > 0.5;
  
  /// Check if this color is considered dark
  bool get isDark => computeLuminance() <= 0.5;
}