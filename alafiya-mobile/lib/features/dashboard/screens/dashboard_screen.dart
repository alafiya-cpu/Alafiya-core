import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/main_navigation.dart';

/// Enhanced Dashboard Screen
/// Main dashboard with comprehensive navigation and modern design
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = AppTheme.isTablet(context);
    final screenSize = MediaQuery.of(context).size;

    return MainNavigation(
      currentRoute: '/dashboard',
      pageTitle: 'Dashboard',
      child: SingleChildScrollView(
        padding: AppTheme.getScreenPadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppTheme.spacingL),

            // Welcome Header
            _buildWelcomeSection(context, isTablet),

            SizedBox(height: AppTheme.spacingXL),

            // Quick Stats Cards
            _buildQuickStatsSection(context, isTablet),

            SizedBox(height: AppTheme.spacingXL),

            // Recent Activity
            _buildRecentActivitySection(context, isTablet),

            SizedBox(height: AppTheme.spacingXL),

            // Quick Actions
            _buildQuickActionsSection(context, isTablet),

            SizedBox(height: AppTheme.spacingXL),
          ],
        ),
      ),
    );
  }

  /// Build welcome section
  Widget _buildWelcomeSection(BuildContext context, bool isTablet) {
    return Container(
      padding: AppTheme.getCardPadding(context),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          // Welcome Avatar
          CircleAvatar(
            radius: isTablet ? 32 : 28,
            backgroundColor: AppTheme.primaryColor,
            child: Text(
              '👩‍⚕️',
              style: GoogleFonts.inter(
                fontSize: isTablet ? 24 : 20,
              ),
            ),
          ),

          const SizedBox(width: AppTheme.spacingL),

          // Welcome Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Good Morning!',
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 28 : 24,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimaryColor,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  'Welcome to Al-Afiya Rehabilitation Center',
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 16 : 14,
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingM,
                    vertical: AppTheme.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'System Status: Online',
                    style: GoogleFonts.inter(
                      fontSize: isTablet ? 12 : 11,
                      color: AppTheme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Date Display
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.getCardShadow(),
            ),
            child: Column(
              children: [
                Text(
                  DateTime.now().day.toString().padLeft(2, '0'),
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 24 : 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryColor,
                  ),
                ),
                Text(
                  _getMonthName(DateTime.now().month),
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 12 : 11,
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build quick stats section
  Widget _buildQuickStatsSection(BuildContext context, bool isTablet) {
    final stats = [
      {
        'label': 'Total Patients',
        'value': '1,248',
        'icon': Icons.people,
        'color': AppTheme.primaryColor
      },
      {
        'label': 'Active Treatments',
        'value': '89',
        'icon': Icons.medical_services,
        'color': AppTheme.secondaryColor
      },
      {
        'label': 'Today\'s Appointments',
        'value': '24',
        'icon': Icons.calendar_today,
        'color': AppTheme.accentColor
      },
      {
        'label': 'Pending Payments',
        'value': '12',
        'icon': Icons.payment,
        'color': AppTheme.warningColor
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Overview',
          style: GoogleFonts.inter(
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        Wrap(
          spacing: AppTheme.spacingM,
          runSpacing: AppTheme.spacingM,
          children: stats.map((stat) {
            return SizedBox(
              width: isTablet
                  ? (screenWidth(context) - AppTheme.spacingXL * 3) / 2
                  : (screenWidth(context) - AppTheme.spacingM * 3) / 2,
              child: Container(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.getCardShadow(),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppTheme.spacingS),
                          decoration: BoxDecoration(
                            color: (stat['color'] as Color).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            stat['icon'] as IconData,
                            color: stat['color'] as Color,
                            size: isTablet ? 20 : 18,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          stat['value'] as String,
                          style: GoogleFonts.inter(
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      stat['label'] as String,
                      style: GoogleFonts.inter(
                        fontSize: isTablet ? 13 : 12,
                        color: AppTheme.textSecondaryColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Build recent activity section
  Widget _buildRecentActivitySection(BuildContext context, bool isTablet) {
    final activities = [
      {
        'time': '10:30 AM',
        'activity': 'New patient registration',
        'icon': Icons.person_add
      },
      {
        'time': '9:15 AM',
        'activity': 'Treatment updated for Patient #1234',
        'icon': Icons.medical_services
      },
      {
        'time': '8:45 AM',
        'activity': 'Payment received from Patient #5678',
        'icon': Icons.payment
      },
      {
        'time': '8:00 AM',
        'activity': 'Daily briefing completed',
        'icon': Icons.check_circle
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: GoogleFonts.inter(
                fontSize: isTablet ? 20 : 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryColor,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to full activity log
              },
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: isTablet ? 14 : 13,
                  color: AppTheme.primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingL),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppTheme.getCardShadow(),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => Divider(
              color: AppTheme.dividerColor,
              height: 1,
              indent: AppTheme.spacingL,
              endIndent: AppTheme.spacingL,
            ),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Icon(
                    activity['icon'] as IconData,
                    color: AppTheme.primaryColor,
                    size: isTablet ? 20 : 18,
                  ),
                ),
                title: Text(
                  activity['activity'] as String,
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 14 : 13,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimaryColor,
                  ),
                ),
                trailing: Text(
                  activity['time'] as String,
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 12 : 11,
                    color: AppTheme.textSecondaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingL,
                  vertical: AppTheme.spacingS,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Build quick actions section
  Widget _buildQuickActionsSection(BuildContext context, bool isTablet) {
    final actions = [
      {'label': 'Add Patient', 'icon': Icons.person_add, 'route': '/patients'},
      {
        'label': 'New Treatment',
        'icon': Icons.medical_services,
        'route': '/treatments'
      },
      {'label': 'Record Payment', 'icon': Icons.payment, 'route': '/payments'},
      {
        'label': 'Discharge Patient',
        'icon': Icons.exit_to_app,
        'route': '/discharge'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.inter(
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryColor,
          ),
        ),
        const SizedBox(height: AppTheme.spacingL),
        Wrap(
          spacing: AppTheme.spacingM,
          runSpacing: AppTheme.spacingM,
          children: actions.map((action) {
            return SizedBox(
              width: isTablet
                  ? (screenWidth(context) - AppTheme.spacingXL * 3) / 2
                  : (screenWidth(context) - AppTheme.spacingM * 3) / 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Navigate to respective screens
                },
                icon: Icon(
                  action['icon'] as IconData,
                  size: isTablet ? 20 : 18,
                ),
                label: Text(
                  action['label'] as String,
                  style: GoogleFonts.inter(
                    fontSize: isTablet ? 14 : 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(AppTheme.spacingL),
                  backgroundColor: AppTheme.surfaceColor,
                  foregroundColor: AppTheme.primaryColor,
                  elevation: 2,
                  shadowColor: AppTheme.primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: AppTheme.dividerColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper methods
  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
