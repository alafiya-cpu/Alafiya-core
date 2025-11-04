# Al Afiya Rehabilitation Center - Enhanced Design System

## "Healing with Compassion and Dignity"

**Location:** Jigjiga, Ethiopia  
**Powered by:** BitBirr  
**Version:** 1.0.0

---

## 📋 Table of Contents

1. [Overview](#overview)
2. [Brand Identity](#brand-identity)
3. [Color System](#color-system)
4. [Typography](#typography)
5. [Component Design Tokens](#component-design-tokens)
6. [Usage Examples](#usage-examples)
7. [Implementation Guide](#implementation-guide)

---

## 🎯 Overview

The Al Afiya Enhanced Design System provides a comprehensive foundation for building consistent, accessible, and brand-aligned user interfaces for the Al Afiya Rehabilitation Center mobile application.

### Brand Values
- **Trust & Care:** Compassion, community, and confidentiality
- **Professionalism:** Clinical precision with warmth
- **Faith & Healing:** Integrates wellness with moral and cultural care

---

## 🎨 Brand Identity

### Core Brand Colors

| Role | Color Name | Hex | Usage |
|------|------------|-----|--------|
| Primary | Trust Blue | `#0C2D57` | Main brand color, CTAs, headers |
| Secondary | Gold Harmony | `#D4AF37` | Accent color, highlights, success states |
| Accent 1 | Medical Green | `#2E7D32` | Growth, renewal, health indicators |
| Accent 2 | Sky White | `#F5F9FF` | Background, clean spaces |
| Text | Deep Navy | `#0A192F` | Primary text, professional tone |

### Semantic Colors

| State | Color | Hex | Purpose |
|-------|--------|-----|---------|
| Success | Success Green | `#388E3C` | Healing/recovery states, completed actions |
| Warning | Warning Amber | `#F9A825` | Alerts, pending actions, caution |
| Error | Error Red | `#D32F2F` | Clinical errors, validation failures |
| Info | Info Blue | `#1976D2` | Informational content, notifications |

---

## 🎭 Color System

### Complete Color Palette

#### Trust Blue Variations
```dart
static const Color trustBlue = Color(0xFF0C2D57);        // Primary
static const Color trustBlueLight = Color(0xFF4A6FA5);   // Light variant
static const Color trustBlueLighter = Color(0xFF7C9BC8); // Very light
static const Color trustBlueDark = Color(0xFF081E3F);    // Dark variant
static const Color trustBlueDarker = Color(0xFF041427);  // Very dark
```

#### Gold Harmony Variations
```dart
static const Color goldHarmony = Color(0xFFD4AF37);      // Primary
static const Color goldHarmonyLight = Color(0xFFDEC47A); // Light variant
static const Color goldHarmonyLighter = Color(0xFFE8DDA8); // Very light
static const Color goldHarmonyDark = Color(0xFFB8962E);  // Dark variant
static const Color goldHarmonyDarker = Color(0xFF8A7321); // Very dark
```

#### Medical Green Variations
```dart
static const Color medicalGreen = Color(0xFF2E7D32);      // Primary
static const Color medicalGreenLight = Color(0xFF5FA667); // Light variant
static const Color medicalGreenLighter = Color(0xFF8BCB8F); // Very light
static const Color medicalGreenDark = Color(0xFF1E5A22);  // Dark variant
static const Color medicalGreenDarker = Color(0xFF153C17); // Very dark
```

#### Neutral Palette
```dart
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
```

---

## 📝 Typography

### Font Family
- **Primary:** AlAfiya (Custom brand font)
- **Fallback:** System fonts for accessibility

### Typography Scale

#### Display Styles
```dart
// Display Large (57px) - Hero titles, landing page headers
Text('Welcome to Al Afiya', 
     style: AlAfiyaDesignSystem.displayLarge)

// Display Medium (45px) - Page titles, major headers
Text('Patient Dashboard', 
     style: AlAfiyaDesignSystem.displayMedium)

// Display Small (36px) - Section headers
Text('Treatment Plans', 
     style: AlAfiyaDesignSystem.displaySmall)
```

#### Headline Styles
```dart
// Headline Large (32px) - Major section headers
Text('Recent Activity', 
     style: AlAfiyaDesignSystem.headlineLarge)

// Headline Medium (28px) - Subsection headers
Text('Patient Information', 
     style: AlAfiyaDesignSystem.headlineMedium)

// Headline Small (24px) - Card titles, widget headers
Text('Upcoming Appointments', 
     style: AlAfiyaDesignSystem.headlineSmall)
```

#### Title Styles
```dart
// Title Large (22px) - Card titles, major UI elements
Text('Treatment History', 
     style: AlAfiyaDesignSystem.titleLarge)

// Title Medium (16px) - Button text, form labels
Text('Save Changes', 
     style: AlAfiyaDesignSystem.titleMedium)

// Title Small (14px) - Secondary labels, metadata
Text('Last updated 2 hours ago', 
     style: AlAfiyaDesignSystem.titleSmall)
```

#### Body Styles
```dart
// Body Large (16px) - Primary body text, paragraphs
Text('Patient condition has improved significantly...', 
     style: AlAfiyaDesignSystem.bodyLarge)

// Body Medium (14px) - Secondary body text
Text('Next appointment scheduled for tomorrow', 
     style: AlAfiyaDesignSystem.bodyMedium)

// Body Small (12px) - Helper text, captions
Text('Required field', 
     style: AlAfiyaDesignSystem.bodySmall)
```

#### Label Styles
```dart
// Label Large (14px) - Form labels, button text
Text('Full Name', 
     style: AlAfiyaDesignSystem.labelLarge)

// Label Medium (12px) - Chip text, small buttons
Text('ACTIVE', 
     style: AlAfiyaDesignSystem.labelMedium)

// Label Small (11px) - Very small labels
Text('Optional', 
     style: AlAfiyaDesignSystem.labelSmall)
```

---

## 🧩 Component Design Tokens

### Spacing System (8pt Grid)
```dart
static const double spaceXS = 4.0;     // 0.5 * 8
static const double spaceS = 8.0;      // 1 * 8
static const double spaceM = 16.0;     // 2 * 8
static const double spaceL = 24.0;     // 3 * 8
static const double spaceXL = 32.0;    // 4 * 8
static const double spaceXXL = 40.0;   // 5 * 8
static const double spaceXXXL = 48.0;  // 6 * 8
static const double spaceXXXXL = 64.0; // 8 * 8
```

### Border Radius
```dart
static const double radiusXS = 4.0;    // Small elements
static const double radiusS = 8.0;     // Buttons, chips
static const double radiusM = 12.0;    // Cards
static const double radiusL = 16.0;    // Large cards
static const double radiusXL = 20.0;   // Modals
static const double radiusXXL = 24.0;  // Large containers
static const double radiusFull = 9999.0; // Circular elements
```

### Elevation Shadows
```dart
static const double elevationNone = 0.0;
static const double elevationXS = 1.0;  // Subtle shadows
static const double elevationS = 2.0;   // Cards, small elements
static const double elevationM = 4.0;   // Standard elevation
static const double elevationL = 8.0;   // Floating elements
static const double elevationXL = 16.0; // Modals, dropdowns
static const double elevationXXL = 24.0; // Highest elevation
```

---

## 💻 Usage Examples

### 1. Basic Button Implementation

```dart
// Primary Button
ElevatedButton(
  onPressed: () {},
  style: ElevatedButton.styleFrom(
    backgroundColor: AppTheme.primaryColor,
    foregroundColor: AppTheme.textWhiteColor,
    padding: EdgeInsets.symmetric(
      horizontal: AppTheme.spacingL,
      vertical: AppTheme.spacingM,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
    ),
  ),
  child: Text('Schedule Appointment', 
              style: AppTheme.buttonLarge),
)

// Secondary Button
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    foregroundColor: AppTheme.primaryColor,
    side: BorderSide(color: AppTheme.primaryColor, width: 1.5),
    padding: EdgeInsets.symmetric(
      horizontal: AppTheme.spacingL,
      vertical: AppTheme.spacingM,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
    ),
  ),
  child: Text('View Details', 
              style: AppTheme.buttonLarge),
)
```

### 2. Card Component

```dart
Card(
  elevation: AlAfiyaDesignSystem.elevationM.toDouble(),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusL),
  ),
  child: Padding(
    padding: AppTheme.getCardPadding(context),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Patient Status Report', 
             style: AppTheme.titleLarge),
        SizedBox(height: AppTheme.spaceS),
        Text('Patient shows significant improvement in mobility and cognitive function.', 
             style: AppTheme.bodyMedium),
        SizedBox(height: AppTheme.spaceM),
        Row(
          children: [
            Chip(
              label: Text('Active Treatment', 
                          style: AppTheme.labelMedium),
              backgroundColor: AppTheme.successColor.withOpacity(0.1),
              labelStyle: AppTheme.labelMedium.copyWith(
                color: AppTheme.successColor,
              ),
            ),
            SizedBox(width: AppTheme.spaceS),
            Text('Updated 2 hours ago', 
                 style: AppTheme.bodySmall),
          ],
        ),
      ],
    ),
  ),
)
```

### 3. Input Field

```dart
TextFormField(
  decoration: InputDecoration(
    labelText: 'Patient Name',
    hintText: 'Enter full patient name',
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
      borderSide: BorderSide(color: AppTheme.dividerColor, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
      borderSide: BorderSide(color: AppTheme.dividerColor, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusM),
      borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
    ),
    filled: true,
    fillColor: AppTheme.surfaceVariantColor,
    contentPadding: EdgeInsets.symmetric(
      horizontal: AppTheme.spacingM,
      vertical: AppTheme.spacingM,
    ),
    labelStyle: AppTheme.bodyMedium.copyWith(
      color: AppTheme.textSecondaryColor,
    ),
  ),
  style: AppTheme.bodyLarge,
)
```

### 4. Status Indicators

```dart
// Success Status
Container(
  padding: EdgeInsets.symmetric(
    horizontal: AppTheme.spaceM,
    vertical: AppTheme.spaceXS,
  ),
  decoration: BoxDecoration(
    color: AppTheme.successColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusFull),
  ),
  child: Text('Recovered', 
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.successColor,
              )),
)

// Warning Status
Container(
  padding: EdgeInsets.symmetric(
    horizontal: AppTheme.spaceM,
    vertical: AppTheme.spaceXS,
  ),
  decoration: BoxDecoration(
    color: AppTheme.warningColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusFull),
  ),
  child: Text('Pending Approval', 
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.warningColor,
              )),
)

// Error Status
Container(
  padding: EdgeInsets.symmetric(
    horizontal: AppTheme.spaceM,
    vertical: AppTheme.spaceXS,
  ),
  decoration: BoxDecoration(
    color: AppTheme.errorColor.withOpacity(0.1),
    borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusFull),
  ),
  child: Text('Critical', 
              style: AppTheme.labelMedium.copyWith(
                color: AppTheme.errorColor,
              )),
)
```

### 5. App Bar Implementation

```dart
AppBar(
  elevation: 0,
  centerTitle: true,
  backgroundColor: AppTheme.primaryColor,
  foregroundColor: AppTheme.textWhiteColor,
  title: Column(
    children: [
      Text('Al Afiya Rehabilitation Center', 
           style: AppTheme.titleMedium.copyWith(
             color: AppTheme.textWhiteColor,
             fontSize: 20,
           )),
      Text('Healing with Compassion and Dignity', 
           style: AppTheme.bodySmall.copyWith(
             color: AppTheme.textWhiteColor.withOpacity(0.8),
           )),
    ],
  ),
  iconTheme: IconThemeData(color: AppTheme.textWhiteColor),
)
```

### 6. Patient Card Component

```dart
Card(
  elevation: AlAfiyaDesignSystem.elevationM.toDouble(),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusL),
  ),
  child: Padding(
    padding: EdgeInsets.all(AppTheme.spacingL),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              child: Icon(Icons.person, 
                          color: AppTheme.primaryColor),
            ),
            SizedBox(width: AppTheme.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ahmed Hassan', 
                       style: AppTheme.titleMedium),
                  Text('Patient ID: RC-2024-001', 
                       style: AppTheme.bodySmall),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppTheme.spaceS,
                vertical: AppTheme.spaceXS,
              ),
              decoration: BoxDecoration(
                color: AppTheme.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AlAfiyaDesignSystem.radiusS),
              ),
              child: Text('Stable', 
                          style: AppTheme.labelSmall.copyWith(
                            color: AppTheme.successColor,
                          )),
            ),
          ],
        ),
        SizedBox(height: AppTheme.spaceM),
        Text('Treatment Progress', 
             style: AppTheme.titleSmall),
        SizedBox(height: AppTheme.spaceS),
        LinearProgressIndicator(
          value: 0.75,
          backgroundColor: AppTheme.neutral200,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppTheme.primaryColor,
          ),
        ),
        SizedBox(height: AppTheme.spaceS),
        Text('75% Complete', 
             style: AppTheme.bodySmall),
      ],
    ),
  ),
)
```

---

## 🚀 Implementation Guide

### 1. Installation

The design system is automatically included in the Al Afiya mobile app. Access it through:

```dart
import 'package:alafiya_mobile/core/theme/al_afiya_design_system.dart';
import 'package:alafiya_mobile/core/theme/app_theme.dart';
```

### 2. Setting Up Themes

In your main app file:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al Afiya',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      // ... other configurations
    );
  }
}
```

### 3. Using Design Tokens

```dart
// Spacing
Container(
  margin: EdgeInsets.all(AppTheme.spacingM),
  padding: EdgeInsets.symmetric(
    horizontal: AppTheme.spacingL,
    vertical: AppTheme.spacingS,
  ),
)

// Colors
Container(
  color: AppTheme.primaryColor,
  child: Text('Primary Content', 
              style: AppTheme.bodyLarge),
)

// Typography
Text('Welcome', 
     style: AlAfiyaDesignSystem.headlineLarge)

// Elevation
Container(
  decoration: BoxDecoration(
    boxShadow: AppTheme.getCardShadow(),
  ),
)
```

### 4. Responsive Design

```dart
// Check device type
bool isTablet = AlAfiyaDesignSystem.isTablet(context);
bool isMobile = AlAfiyaDesignSystem.isMobile(context);

// Responsive text
TextStyle titleStyle = AlAfiyaDesignSystem.getResponsiveTextStyle(
  AlAfiyaDesignSystem.titleLarge,  // Mobile
  AlAfiyaDesignSystem.headlineLarge, // Tablet
  context,
);

// Responsive padding
EdgeInsetsGeometry padding = AlAfiyaDesignSystem.getScreenPadding(context);
```

### 5. Brand Consistency Checks

When implementing new components, ensure:

- ✅ Use Al Afiya brand colors
- ✅ Follow typography scale
- ✅ Use proper spacing tokens
- ✅ Apply appropriate elevation
- ✅ Maintain accessibility standards
- ✅ Support both light and dark themes

---

## 📱 Design System Benefits

1. **Brand Consistency:** Unified visual language across all interfaces
2. **Accessibility:** WCAG 2.1 AA compliant color contrasts
3. **Scalability:** Modular design tokens for easy expansion
4. **Efficiency:** Reusable components and utilities
5. **Cultural Sensitivity:** Respect for Ethiopian cultural context
6. **Professional Healthcare:** Clinical precision with compassionate design

---

## 🔧 Maintenance

### Adding New Colors
```dart
// Add to AlAfiyaDesignSystem
static const Color newBrandColor = Color(0xFF123456);

// Update theme if needed
static const Color primaryColor = AlAfiyaDesignSystem.newBrandColor;
```

### Adding New Typography Styles
```dart
// Add to AlAfiyaDesignSystem
static TextStyle get customStyle => TextStyle(
  fontFamily: 'AlAfiya',
  fontSize: 18.0,
  fontWeight: FontWeight.w600,
  color: deepNavy,
);
```

### Testing
- Run `flutter test` to ensure design system integrity
- Test accessibility with `flutter run --enable-checked-mode`
- Verify responsive behavior across device sizes

---

**Developed with ❤️ for Al Afiya Rehabilitation Center**  
*"Healing with Compassion and Dignity"*