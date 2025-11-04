import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(icon: Icons.dashboard, label: 'Dashboard', route: '/dashboard'),
    NavigationItem(icon: Icons.people, label: 'Patients', route: '/patients'),
    NavigationItem(icon: Icons.medical_services, label: 'Treatments', route: '/treatments'),
    NavigationItem(icon: Icons.payment, label: 'Payments', route: '/payments'),
    NavigationItem(icon: Icons.notifications, label: 'Notifications', route: '/notifications'),
    NavigationItem(icon: Icons.logout, label: 'Logout', route: '/logout'),
  ];

  List<NavigationItem> get navigationItems => _navigationItems;

  void setIndex(int index) {
    if (index >= 0 && index < _navigationItems.length) {
      _currentIndex = index;
      notifyListeners();
    }
  }

  void navigateToRoute(BuildContext context, String route) {
    final itemIndex = _navigationItems.indexWhere((item) => item.route == route);
    if (itemIndex != -1) {
      setIndex(itemIndex);
    }
    
    Navigator.of(context).pushNamed(route);
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}