import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/dashboard_service.dart';
import '../models/dashboard_model.dart';
import '../widgets/sidebar.dart';
import '../widgets/metric_card_enhanced.dart';
import '../widgets/ticket_sales_chart.dart';
import '../widgets/ticket_type_chart.dart';
import '../widgets/popular_lines_table.dart';
import 'login_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _dashboardService = DashboardService();
  final _authService = AuthService();
  DashboardMetrics? _metrics;
  bool _isLoading = true;
  String? _errorMessage;
  String _currentRoute = '/dashboard';

  @override
  void initState() {
    super.initState();
    _loadMetrics();
  }

  Future<void> _loadMetrics() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final metrics = await _dashboardService.getMetrics();
      setState(() {
        _metrics = metrics;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load dashboard metrics';
        _isLoading = false;
      });
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(symbol: 'KM', decimalDigits: 0).format(amount);
  }

  void _handleNavigation(String route) {
    setState(() {
      _currentRoute = route;
    });
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                            const SizedBox(height: 16),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadMetrics,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : _metrics == null
                        ? const Center(child: Text('No data available'))
                        : Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Dashboard - Pregled aktivnosti',
                                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Row(
                                      children: [
                                        FutureBuilder<String?>(
                                          future: _authService.getUsername(),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              return Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: Text('Welcome, ${snapshot.data}'),
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.refresh),
                                          onPressed: _loadMetrics,
                                          tooltip: 'Refresh',
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.logout),
                                          onPressed: () async {
                                            await _authService.logout();
                                            if (context.mounted) {
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder: (_) => const LoginScreen()),
                                              );
                                            }
                                          },
                                          tooltip: 'Logout',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: MetricCardEnhanced(
                                              title: 'UKUPNO KORISNIKA',
                                              value: _formatNumber(_metrics!.totalUsers),
                                              changeText: '+${_metrics!.totalUsersChange.toStringAsFixed(1)}% od prošlog mjeseca',
                                              isPositiveChange: true,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: MetricCardEnhanced(
                                              title: 'PRODANE KARTE (DANAS)',
                                              value: _formatNumber(_metrics!.soldTicketsToday),
                                              changeText: '+${_metrics!.soldTicketsChange.toStringAsFixed(1)}% od juče',
                                              isPositiveChange: true,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: MetricCardEnhanced(
                                              title: 'MJESEČNI PRIHODI',
                                              value: _formatCurrency(_metrics!.monthlyRevenue),
                                              changeText: '+${_metrics!.monthlyRevenueChange.toStringAsFixed(1)}% od prošlog mjeseca',
                                              isPositiveChange: true,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: MetricCardEnhanced(
                                              title: 'AKTIVNE LINIJE',
                                              value: _metrics!.activeLines.toString(),
                                              subtitle: 'Sve aktivne',
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: TicketSalesChart(data: _metrics!.ticketSalesData),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            flex: 2,
                                            child: TicketTypeChart(data: _metrics!.ticketTypeDistribution),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 24),
                                      PopularLinesTable(lines: _metrics!.popularLines),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return NumberFormat('#,###').format(number);
  }
}
