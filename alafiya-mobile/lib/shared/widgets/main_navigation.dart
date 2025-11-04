import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/app_router.dart';

/// Navigation Item Model
class NavigationItem {
  final String label;
  final IconData icon;
  final String route;
  final List<NavigationItem>? children;

  const NavigationItem({
    required this.label,
    required this.icon,
    required this.route,
    this.children,
  });
}

/// Enhanced Main Navigation Framework
/// Provides comprehensive navigation with breadcrumbs and sticky elements
class MainNavigation extends ConsumerWidget {
  final Widget child;
  final String currentRoute;
  final String? pageTitle;
  final List<Widget>? additionalActions;

  const MainNavigation({
    super.key,
    required this.child,
    required this.currentRoute,
    this.pageTitle,
    this.additionalActions,
  });

  // Main navigation items
  static const List<NavigationItem> navigationItems = [
    NavigationItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      route: '/dashboard',
    ),
    NavigationItem(
      label: 'Patients',
      icon: Icons.people_outline,
      route: '/patients',
    ),
    NavigationItem(
      label: 'Treatments',
      icon: Icons.medical_services_outlined,
      route: '/treatments',
    ),
    NavigationItem(
      label: 'Payments',
      icon: Icons.payment_outlined,
      route: '/payments',
    ),
    NavigationItem(
      label: 'Discharge',
      icon: Icons.exit_to_app_outlined,
      route: '/discharge',
    ),
    NavigationItem(
      label: 'Notifications',
      icon: Icons.notifications_outlined,
      route: '/notifications',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = AppTheme.isTablet(context);
    final isMobile = AppTheme.isMobile(context);

    return Scaffold(
      body: Row(
        children: [
          // Enhanced Sidebar Navigation (Desktop/Tablet)
          if (!isMobile) _buildSidebarNavigation(context, isTablet),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Enhanced App Bar with Breadcrumbs
                _buildEnhancedAppBar(context, isTablet),

                // Breadcrumb Navigation
                _buildBreadcrumbNavigation(context),

                // Main Content
                Expanded(
                  child: Container(
                    color: AppTheme.backgroundColor,
                    child: child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Navigation (Mobile)
      bottomNavigationBar: isMobile ? _buildBottomNavigationBar(context) : null,

      // Floating Action Button for Mobile Quick Actions
      floatingActionButton:
          isMobile ? _buildFloatingActionButton(context) : null,
    );
  }

  /// Build sidebar navigation for larger screens
  Widget _buildSidebarNavigation(BuildContext context, bool isTablet) {
    return Container(
      width: isTablet ? 280 : 240,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with Logo
          _buildSidebarHeader(context, isTablet),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                vertical: AppTheme.spacingM,
              ),
              children: navigationItems.map((item) {
                final isSelected = currentRoute == item.route;
                return _buildNavigationItem(
                    context, item, isSelected, isTablet);
              }).toList(),
            ),
          ),

          // Footer Actions
          _buildSidebarFooter(context, isTablet),
        ],
      ),
    );
  }

  /// Build sidebar header with logo
  Widget _buildSidebarHeader(BuildContext context, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Row(
        children: [
          // Company Logo
          Container(
            width: isTablet ? 48 : 40,
            height: isTablet ? 48 : 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.medical_services,
                    color: AppTheme.primaryColor,
                    size: isTablet ? 24 : 20,
                  );
                },
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spacingM),

          // App Name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Al-Afiya',
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                Text(
                  'Healthcare',
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 12 : 11,
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build individual navigation item
  Widget _buildNavigationItem(BuildContext context, NavigationItem item,
      bool isSelected, bool isTablet) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingXS,
      ),
      child: Material(
        color: isSelected
            ? AppTheme.primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToRoute(context, item.route),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingM,
              vertical: AppTheme.spacingM,
            ),
            child: Row(
              children: [
                // Icon
                Icon(
                  item.icon,
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondaryColor,
                  size: isTablet ? 24 : 20,
                ),

                const SizedBox(width: AppTheme.spacingM),

                // Label
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 14 : 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppTheme.primaryColor
                          : AppTheme.textPrimaryColor,
                    ),
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Container(
                    width: 3,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build sidebar footer
  Widget _buildSidebarFooter(BuildContext context, bool isTablet) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      child: Column(
        children: [
          // User Profile Section
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: AppTheme.surfaceVariantColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isTablet ? 20 : 18,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Icon(
                    Icons.person_outline,
                    color: AppTheme.primaryColor,
                    size: isTablet ? 20 : 18,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Healthcare Professional',
                        style: GoogleFonts.inter(
                          fontSize: isTablet ? 13 : 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimaryColor,
                        ),
                      ),
                      Text(
                        'Online',
                        style: GoogleFonts.inter(
                          fontSize: isTablet ? 11 : 10,
                          color: AppTheme.successColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingM),

          // Settings Button
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {
                // TODO: Implement settings
              },
              icon: Icon(
                Icons.settings_outlined,
                size: isTablet ? 18 : 16,
              ),
              label: Text(
                'Settings',
                style: GoogleFonts.inter(
                  fontSize: isTablet ? 13 : 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.textSecondaryColor,
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.spacingS,
                ),
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build enhanced app bar
  Widget _buildEnhancedAppBar(BuildContext context, bool isTablet) {
    return Container(
      height: isTablet ? 72 : 64,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.getScreenPadding(context).horizontal / 2,
        ),
        child: Row(
          children: [
            // Page Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    pageTitle ?? _getPageTitle(currentRoute),
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimaryColor,
                    ),
                  ),
                  Text(
                    'Rehabilitation Center',
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 13 : 12,
                      color: AppTheme.textSecondaryColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Additional Actions
            if (additionalActions != null) ...?additionalActions,

            // User Menu
            _buildUserMenu(context, isTablet),
          ],
        ),
      ),
    );
  }

  /// Build breadcrumb navigation
  Widget _buildBreadcrumbNavigation(BuildContext context) {
    final breadcrumbs = _generateBreadcrumbs(currentRoute);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.dividerColor.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Home Icon
          Icon(
            Icons.home_outlined,
            size: 16,
            color: AppTheme.textSecondaryColor,
          ),

          const SizedBox(width: AppTheme.spacingS),

          // Breadcrumb Items
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: breadcrumbs.length,
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingS,
                ),
                child: Icon(
                  Icons.chevron_right,
                  size: 14,
                  color: AppTheme.textSecondaryColor,
                ),
              ),
              itemBuilder: (context, index) {
                final item = breadcrumbs[index];
                final isLast = index == breadcrumbs.length - 1;

                return GestureDetector(
                  onTap: isLast
                      ? null
                      : () => _navigateToRoute(context, item.route),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingXS,
                      horizontal: AppTheme.spacingS,
                    ),
                    child: Text(
                      item.label,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: isLast ? FontWeight.w600 : FontWeight.w500,
                        color: isLast
                            ? AppTheme.primaryColor
                            : AppTheme.textSecondaryColor,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build bottom navigation bar for mobile
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowColor.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _getSelectedIndex(currentRoute),
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondaryColor,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        items: navigationItems.take(5).map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item.icon),
            label: item.label,
            activeIcon: Icon(item.icon),
          );
        }).toList(),
        onTap: (index) =>
            _navigateToRoute(context, navigationItems[index].route),
      ),
    );
  }

  /// Build floating action button
  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        // Quick action based on current page
        _showQuickActionMenu(context);
      },
      backgroundColor: AppTheme.primaryColor,
      foregroundColor: Colors.white,
      elevation: 4,
      child: const Icon(Icons.add),
    );
  }

  /// Build user menu
  Widget _buildUserMenu(BuildContext context, bool isTablet) {
    return PopupMenuButton<String>(
      icon: CircleAvatar(
        radius: isTablet ? 20 : 18,
        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
        child: Icon(
          Icons.person_outline,
          color: AppTheme.primaryColor,
          size: isTablet ? 20 : 18,
        ),
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('Profile'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'settings',
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const PopupMenuItem(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'logout':
            // TODO: Implement logout
            break;
          case 'settings':
            // TODO: Implement settings
            break;
          case 'profile':
            // TODO: Implement profile
            break;
        }
      },
    );
  }

  // Helper methods
  String _getPageTitle(String route) {
    switch (route) {
      case '/dashboard':
        return 'Dashboard';
      case '/patients':
        return 'Patients';
      case '/treatments':
        return 'Treatments';
      case '/payments':
        return 'Payments';
      case '/discharge':
        return 'Discharge';
      case '/notifications':
        return 'Notifications';
      default:
        return 'Al-Afiya';
    }
  }

  List<NavigationItem> _generateBreadcrumbs(String route) {
    final breadcrumbs = <NavigationItem>[
      const NavigationItem(
          label: 'Home', icon: Icons.home, route: '/dashboard'),
    ];

    switch (route) {
      case '/patients':
        breadcrumbs.add(const NavigationItem(
            label: 'Patients', icon: Icons.people, route: '/patients'));
        break;
      case '/treatments':
        breadcrumbs.add(const NavigationItem(
            label: 'Treatments',
            icon: Icons.medical_services,
            route: '/treatments'));
        break;
      case '/payments':
        breadcrumbs.add(const NavigationItem(
            label: 'Payments', icon: Icons.payment, route: '/payments'));
        break;
      case '/discharge':
        breadcrumbs.add(const NavigationItem(
            label: 'Discharge', icon: Icons.exit_to_app, route: '/discharge'));
        break;
      case '/notifications':
        breadcrumbs.add(const NavigationItem(
            label: 'Notifications',
            icon: Icons.notifications,
            route: '/notifications'));
        break;
    }

    return breadcrumbs;
  }

  int _getSelectedIndex(String route) {
    switch (route) {
      case '/dashboard':
        return 0;
      case '/patients':
        return 1;
      case '/treatments':
        return 2;
      case '/payments':
        return 3;
      case '/discharge':
        return 4;
      default:
        return 0;
    }
  }

  void _showQuickActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Quick Actions',
              style: AppTheme.titleMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),
            // Add quick action buttons here
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add Patient'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to add patient
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('New Treatment'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Navigate to new treatment
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Navigate to route using the existing NavigationHelper
  void _navigateToRoute(BuildContext context, String route) {
    switch (route) {
      case '/dashboard':
        NavigationHelper.goToDashboard(context);
        break;
      case '/patients':
        NavigationHelper.goToPatients(context);
        break;
      case '/treatments':
        NavigationHelper.goToTreatments(context);
        break;
      case '/payments':
        NavigationHelper.goToPayments(context);
        break;
      case '/discharge':
        NavigationHelper.goToDischarge(context);
        break;
      case '/notifications':
        NavigationHelper.goToNotifications(context);
        break;
      default:
        context.go(route);
        break;
    }
  }
}
