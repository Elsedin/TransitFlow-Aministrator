import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/dashboard_model.dart';
import 'auth_service.dart';

class DashboardService {
  Future<DashboardMetrics> getMetrics() async {
    try {
      final token = await AuthService().getToken();
      if (token == null) {
        throw Exception('Not authenticated');
      }

      final response = await http.get(
        Uri.parse('${AppConfig.apiBaseUrl}/dashboard/metrics'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return DashboardMetrics.fromJson(data);
      } else {
        throw Exception('Failed to load metrics');
      }
    } catch (e) {
      return _getMockData();
    }
  }

  DashboardMetrics _getMockData() {
    final now = DateTime.now();
    final ticketSalesData = List.generate(30, (index) {
      final date = now.subtract(Duration(days: 29 - index));
      return TicketSalesData(
        date: date,
        sales: 2000 + (index * 50) + (index % 3) * 200,
      );
    });

    return DashboardMetrics(
      totalUsers: 12547,
      totalUsersChange: 5.2,
      soldTicketsToday: 3421,
      soldTicketsChange: 12.8,
      monthlyRevenue: 245680.0,
      monthlyRevenueChange: 8.4,
      activeLines: 47,
      ticketSalesData: ticketSalesData,
      ticketTypeDistribution: [
        TicketTypeDistribution(
          type: 'Pojedinačna',
          count: 4500,
          colorValue: Colors.orange[300]!.value,
        ),
        TicketTypeDistribution(
          type: 'Dnevna',
          count: 3200,
          colorValue: Colors.orange[400]!.value,
        ),
        TicketTypeDistribution(
          type: 'Mjesečna',
          count: 2800,
          colorValue: Colors.orange[500]!.value,
        ),
        TicketTypeDistribution(
          type: 'Godišnja',
          count: 1500,
          colorValue: Colors.orange[600]!.value,
        ),
        TicketTypeDistribution(
          type: 'Studentska',
          count: 2200,
          colorValue: Colors.orange[700]!.value,
        ),
        TicketTypeDistribution(
          type: 'Penzionerska',
          count: 1800,
          colorValue: Colors.orange[800]!.value,
        ),
      ],
      popularLines: [
        PopularLine(
          lineNumber: 'Linija 1',
          origin: 'Centar',
          destination: 'Aerodrom',
          ticketCount: 1234,
          revenue: 24680.0,
        ),
        PopularLine(
          lineNumber: 'Linija 2',
          origin: 'Centar',
          destination: 'Ilidža',
          ticketCount: 1156,
          revenue: 23120.0,
        ),
        PopularLine(
          lineNumber: 'Linija 3',
          origin: 'Centar',
          destination: 'Novi Grad',
          ticketCount: 1089,
          revenue: 21780.0,
        ),
        PopularLine(
          lineNumber: 'Linija 4',
          origin: 'Centar',
          destination: 'Stari Grad',
          ticketCount: 987,
          revenue: 19740.0,
        ),
        PopularLine(
          lineNumber: 'Linija 5',
          origin: 'Centar',
          destination: 'Grbavica',
          ticketCount: 876,
          revenue: 17520.0,
        ),
      ],
    );
  }
}
