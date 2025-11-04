// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'al_afiya_design_system.dart';

/// Al Afiya Rehabilitation Center - App Theme Configuration
/// Enhanced theme using Al Afiya Design System
/// "Healing with Compassion and Dignity" | Jigjiga, Ethiopia | Powered by BitBirr
class AppTheme {
  // Use Al Afiya Design System constants
  static const double spacingXS = AlAfiyaDesignSystem.spaceXS;
  static const double spacingS = AlAfiyaDesignSystem.spaceS;
  static const double spacingM = AlAfiyaDesignSystem.spaceM;
  static const double spacingL = AlAfiyaDesignSystem.spaceL;
  static const double spacingXL = AlAfiyaDesignSystem.spaceXL;
  static const double spacingXXL = AlAfiyaDesignSystem.spaceXXL;
  static const double spacingXXXL = AlAfiyaDesignSystem.spaceXXXL;

  // Al Afiya Brand Colors
  static const Color primaryColor = AlAfiyaDesignSystem.trustBlue;
  static const Color primaryColorLight = AlAfiyaDesignSystem.trustBlueLight;
  static const Color primaryColorDark = AlAfiyaDesignSystem.trustBlueDark;
  static const Color secondaryColor = AlAfiyaDesignSystem.goldHarmony;
  static const Color accentColor = AlAfiyaDesignSystem.medicalGreen;
  static const Color backgroundColor = AlAfiyaDesignSystem.skyWhite;
  static const Color surfaceColor = AlAfiyaDesignSystem.neutralWhite;
  static const Color surfaceVariantColor = AlAfiyaDesignSystem.neutral50;
  static const Color errorColor = AlAfiyaDesignSystem.errorRed;
  static const Color warningColor = AlAfiyaDesignSystem.warningAmber;
  static const Color successColor = AlAfiyaDesignSystem.successGreen;
  static const Color infoColor = AlAfiyaDesignSystem.infoBlue;

  // Al Afiya Text Colors
  static const Color textPrimaryColor = AlAfiyaDesignSystem.deepNavy;
  static const Color textSecondaryColor = AlAfiyaDesignSystem.neutral600;
  static const Color textDisabledColor = AlAfiyaDesignSystem.neutral400;
  static const Color textWhiteColor = AlAfiyaDesignSystem.neutralWhite;

  // Al Afiya Neutral Colors
  static const Color dividerColor = AlAfiyaDesignSystem.neutral200;
  static const Color shadowColor = AlAfiyaDesignSystem.neutral900;
  static const Color transparentColor = Color(0x00000000);
  static Color overlayColor = AlAfiyaDesignSystem.neutral900.withOpacity(0.24);

  // Use Al Afiya Design System Typography
  static TextStyle get displayLarge => AlAfiyaDesignSystem.displayLarge;
  static TextStyle get displayMedium => AlAfiyaDesignSystem.displayMedium;
  static TextStyle get displaySmall => AlAfiyaDesignSystem.displaySmall;
  static TextStyle get headlineLarge => AlAfiyaDesignSystem.headlineLarge;
  static TextStyle get headlineMedium => AlAfiyaDesignSystem.headlineMedium;
  static TextStyle get headlineSmall => AlAfiyaDesignSystem.headlineSmall;
  static TextStyle get titleLarge => AlAfiyaDesignSystem.titleLarge;
  static TextStyle get titleMedium => AlAfiyaDesignSystem.titleMedium;
  static TextStyle get titleSmall => AlAfiyaDesignSystem.titleSmall;
  static TextStyle get bodyLarge => AlAfiyaDesignSystem.bodyLarge;
  static TextStyle get bodyMedium => AlAfiyaDesignSystem.bodyMedium;
  static TextStyle get bodySmall => AlAfiyaDesignSystem.bodySmall;
  static TextStyle get labelLarge => AlAfiyaDesignSystem.labelLarge;
  static TextStyle get labelMedium => AlAfiyaDesignSystem.labelMedium;
  static TextStyle get labelSmall => AlAfiyaDesignSystem.labelSmall;

  // Button Text Styles
  static TextStyle get buttonLarge => AlAfiyaDesignSystem.buttonLarge;
  static TextStyle get buttonMedium => AlAfiyaDesignSystem.buttonMedium;
  static TextStyle get buttonSmall => AlAfiyaDesignSystem.buttonSmall;

  // Enhanced Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      primaryColorLight: primaryColorLight,
      primaryColorDark: primaryColorDark,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        secondary: secondaryColor,
        surface: surfaceColor,
        background: backgroundColor,
        error: errorColor,
      ),
      
      // Enhanced App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: textWhiteColor,
        titleTextStyle: AlAfiyaDesignSystem.titleMedium.copyWith(
          color: textWhiteColor,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: textWhiteColor),
      ),

      // Enhanced Card Theme
      cardTheme: CardThemeData(
        elevation: AlAfiyaDesignSystem.elevationM.toDouble(),
        color: surfaceColor,
        shadowColor: shadowColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusL),
        ),
        margin: const EdgeInsets.all(spacingS),
      ),

      // Enhanced Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: textWhiteColor,
          elevation: AlAfiyaDesignSystem.elevationM.toDouble(),
          shadowColor: primaryColor.withOpacity(0.3),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          ),
          textStyle: buttonLarge,
        ),
      ),

      // Enhanced Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          ),
          textStyle: buttonLarge,
        ),
      ),

      // Enhanced Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
          textStyle: buttonLarge,
        ),
      ),

      // Enhanced Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          borderSide: const BorderSide(color: dividerColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        filled: true,
        fillColor: surfaceVariantColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        hintStyle: bodyMedium.copyWith(color: textSecondaryColor),
        labelStyle: bodyMedium.copyWith(color: textSecondaryColor),
        helperStyle: bodySmall.copyWith(color: textSecondaryColor),
      ),

      // Enhanced Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textSecondaryColor,
        type: BottomNavigationBarType.fixed,
        elevation: AlAfiyaDesignSystem.elevationM.toDouble(),
        selectedLabelStyle: labelSmall,
        unselectedLabelStyle: labelSmall,
      ),

      // Enhanced Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceVariantColor,
        selectedColor: primaryColorLight.withOpacity(0.2),
        labelStyle: bodyMedium.copyWith(color: textPrimaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusFull),
        ),
        side: const BorderSide(color: dividerColor),
      ),

      // Enhanced Divider Theme
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 1,
      ),

      // Enhanced List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingL,
          vertical: spacingS,
        ),
        titleTextStyle: bodyLarge,
        subtitleTextStyle: bodyMedium.copyWith(color: textSecondaryColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusS),
        ),
      ),

      // Enhanced Icon Theme
      iconTheme: const IconThemeData(
        color: textSecondaryColor,
        size: 24,
      ),
      
      // Enhanced Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: accentColor,
        foregroundColor: textWhiteColor,
        elevation: AlAfiyaDesignSystem.elevationL.toDouble(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusXL),
        ),
      ),
    );
  }

  // Enhanced Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColorLight,
      scaffoldBackgroundColor: AlAfiyaDesignSystem.neutral950,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        secondary: primaryColorLight,
        surface: AlAfiyaDesignSystem.neutral800,
        background: AlAfiyaDesignSystem.neutral950,
        error: errorColor,
      ),

      // Enhanced Text Theme for Dark Theme
      textTheme: TextTheme(
        displayLarge: AlAfiyaDesignSystem.displayLarge.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        displayMedium: AlAfiyaDesignSystem.displayMedium.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        displaySmall: AlAfiyaDesignSystem.displaySmall.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        headlineLarge: AlAfiyaDesignSystem.headlineLarge.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        headlineMedium: AlAfiyaDesignSystem.headlineMedium.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        headlineSmall: AlAfiyaDesignSystem.headlineSmall.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        titleLarge: AlAfiyaDesignSystem.titleLarge.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        titleMedium: AlAfiyaDesignSystem.titleMedium.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        titleSmall: AlAfiyaDesignSystem.titleSmall.copyWith(color: AlAfiyaDesignSystem.neutral300),
        bodyLarge: AlAfiyaDesignSystem.bodyLarge.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        bodyMedium: AlAfiyaDesignSystem.bodyMedium.copyWith(color: AlAfiyaDesignSystem.neutral300),
        bodySmall: AlAfiyaDesignSystem.bodySmall.copyWith(color: AlAfiyaDesignSystem.neutral400),
        labelLarge: AlAfiyaDesignSystem.labelLarge.copyWith(color: AlAfiyaDesignSystem.neutralWhite),
        labelMedium: AlAfiyaDesignSystem.labelMedium.copyWith(color: AlAfiyaDesignSystem.neutral300),
        labelSmall: AlAfiyaDesignSystem.labelSmall.copyWith(color: AlAfiyaDesignSystem.neutral400),
      ),

      // Enhanced App Bar Theme for Dark Theme
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: AlAfiyaDesignSystem.neutral800,
        foregroundColor: AlAfiyaDesignSystem.neutralWhite,
        titleTextStyle: AlAfiyaDesignSystem.titleMedium.copyWith(
          color: AlAfiyaDesignSystem.neutralWhite,
          fontSize: 20,
        ),
        iconTheme: const IconThemeData(color: AlAfiyaDesignSystem.neutralWhite),
      ),

      // Enhanced Card Theme for Dark Theme
      cardTheme: CardThemeData(
        elevation: AlAfiyaDesignSystem.elevationM.toDouble(),
        color: AlAfiyaDesignSystem.neutral800,
        shadowColor: shadowColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusL),
        ),
        margin: const EdgeInsets.all(spacingS),
      ),

      // Enhanced Input Decoration Theme for Dark Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          borderSide: const BorderSide(color: AlAfiyaDesignSystem.neutral600, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          borderSide: const BorderSide(color: AlAfiyaDesignSystem.neutral600, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
          borderSide: const BorderSide(color: primaryColorLight, width: 2),
        ),
        filled: true,
        fillColor: AlAfiyaDesignSystem.neutral700,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        hintStyle: AlAfiyaDesignSystem.bodyMedium.copyWith(color: AlAfiyaDesignSystem.neutral400),
        labelStyle: AlAfiyaDesignSystem.bodyMedium.copyWith(color: AlAfiyaDesignSystem.neutral400),
        helperStyle: AlAfiyaDesignSystem.bodySmall.copyWith(color: AlAfiyaDesignSystem.neutral400),
      ),

      // Enhanced Bottom Navigation Bar Theme for Dark Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AlAfiyaDesignSystem.neutral800,
        selectedItemColor: primaryColorLight,
        unselectedItemColor: AlAfiyaDesignSystem.neutral400,
        type: BottomNavigationBarType.fixed,
        elevation: AlAfiyaDesignSystem.elevationM.toDouble(),
        selectedLabelStyle: AlAfiyaDesignSystem.labelSmall,
        unselectedLabelStyle: AlAfiyaDesignSystem.labelSmall,
      ),
    );
  }

  // Enhanced Color Extensions using Al Afiya Design System
  static Color getStatusColor(String status) {
    return AlAfiyaDesignSystem.getStatusColor(status);
  }

  // Enhanced Box Shadows using Al Afiya Design System
  static List<BoxShadow> getCardShadow([Color? color]) {
    return AlAfiyaDesignSystem.getCardShadow(
      color: color,
      elevation: AlAfiyaDesignSystem.elevationM,
    );
  }

  static List<BoxShadow> getButtonShadow([Color? color]) {
    return AlAfiyaDesignSystem.getButtonShadow(
      color: color,
      pressed: false,
    );
  }

  static List<BoxShadow> getFloatingActionButtonShadow([Color? color]) {
    return AlAfiyaDesignSystem.getCardShadow(
      color: color ?? accentColor,
      elevation: AlAfiyaDesignSystem.elevationXL,
    );
  }

  // Responsive Breakpoints Helper using Al Afiya Design System
  static bool isTablet(BuildContext context) {
    return AlAfiyaDesignSystem.isTablet(context);
  }

  static bool isMobile(BuildContext context) {
    return AlAfiyaDesignSystem.isMobile(context);
  }

  // Spacing Utilities using Al Afiya Design System
  static EdgeInsetsGeometry getScreenPadding(BuildContext context) {
    return AlAfiyaDesignSystem.getScreenPadding(context);
  }

  static EdgeInsetsGeometry getCardPadding(BuildContext context) {
    return AlAfiyaDesignSystem.getCardPadding(context);
  }

  // Brand-specific utility methods
  static Color getBrandColor(ColorRole role) {
    return AlAfiyaDesignSystem.getColorByRole(role);
  }

  static TextStyle getResponsiveTextStyle(
    TextStyle mobileStyle,
    TextStyle tabletStyle,
    BuildContext context,
  ) {
    return AlAfiyaDesignSystem.getResponsiveTextStyle(mobileStyle, tabletStyle, context);
  }
}