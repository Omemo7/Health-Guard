import 'package:flutter/material.dart';
import 'dart:math';

import 'package:health_guard_flutter/models/profile_models/BaseProfile.dart';

import '../../models/health_models/MonthlyHealthSummary.dart';
import '../../models/health_models/VitalDataPoint.dart';
import '../../models/health_models/VitalLogEntry.dart';
import '../../services/AuthService.dart';
import '../../widgets/AppDrawer.dart';

import '../../widgets/charts/overall_health_chart_widget.dart';
import '../../widgets/charts/vital_chart_widget.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}
class _PatientScreenState extends State<PatientScreen> {
  late List<MonthlyHealthSummary> _monthlyHealthData;
  late Map<VitalType, List<VitalDataPoint>> _vitalData;
  final Random _random = Random();
  bool _isLoading = true;

  BaseProfile? _userProfile;
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }
  Future<void> _loadInitialData() async {
    await _fetchPatientDashboardData(); 
  }
  Future<void> _fetchPatientDashboardData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }
    
    await Future.delayed(const Duration(seconds: 1));

    _monthlyHealthData = List.generate(6, (index) {
      final monthDate = DateTime.now().subtract(Duration(days: index * 30));
      final monthName = _getMonthName(monthDate.month);
      return MonthlyHealthSummary(monthName, 60 + _random.nextDouble() * 30);
    }).reversed.toList();

    _vitalData = {};
    for (var type in VitalType.values) {
      _vitalData[type] = List.generate(30, (index) {
        final date = DateTime.now().subtract(Duration(days: 29 - index));
        double value = 0;
        switch (type) {
          case VitalType.heartRate: value = 60 + _random.nextDouble() * 40; break;
          case VitalType.bloodPressureSystolic: value = 100 + _random.nextDouble() * 40; break;
          case VitalType.bloodPressureDiastolic: value = 60 + _random.nextDouble() * 30; break;
          case VitalType.bloodOxygen: value = 95 + _random.nextDouble() * 4; break;
          case VitalType.temperature: value = 36.5 + _random.nextDouble() * 1.5; break;
        }
        return VitalDataPoint(date, value);
      });
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  String _getMonthName(int month) {
    const monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return monthNames[month - 1];
  }
  @override
  Widget build(BuildContext context) {
    final BaseProfile? userProfile = AuthService().userProfile;

    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        backgroundColor: primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchPatientDashboardData,
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: <Widget>[
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, ${userProfile?.name ?? 'User'}!',
                            style: textTheme.headlineSmall?.copyWith(color: primaryColor, fontWeight: FontWeight.bold)
                          ),
                          const SizedBox(height: 8),
                          Text('Here is your health overview and tools.', style: textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text("Overall Health Trend", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  OverallHealthChartWidget(
                    healthData: _monthlyHealthData,
                    barColor: primaryColor.withOpacity(0.8),
                  ),
                  const SizedBox(height: 24.0),

                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Text("Recent Vitals", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                  ...VitalType.values.map((vital) {
                    return VitalChartWidget(
                      dataPoints: _vitalData[vital] ?? [],
                      vitalName: vitalTypeToString(vital),
                      vitalType: vital,
                      lineColor: secondaryColor.withOpacity(0.9),
                    );
                  }).toList(),
                  const SizedBox(height: 16.0),
                  const SizedBox(height: 24.0),
                ],
              ),
            ),
    );
  }
}
