import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import 'dashboard_screen.dart';
import 'transport_lines_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _currentRoute = '/dashboard';

  void _handleNavigation(String route) {
    setState(() {
      _currentRoute = route;
    });
  }

  Widget _buildCurrentScreen() {
    switch (_currentRoute) {
      case '/dashboard':
        return const DashboardScreen();
      case '/lines':
        return const TransportLinesScreen();
      default:
        return const DashboardScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Sidebar(
            currentRoute: _currentRoute,
            onNavigate: _handleNavigation,
          ),
          Expanded(
            child: _buildCurrentScreen(),
          ),
        ],
      ),
    );
  }
}
