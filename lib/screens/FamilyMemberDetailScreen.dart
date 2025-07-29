import 'package:flutter/material.dart';
import 'dart:math'; // For dummy data generation

import '../models/health_models.dart';
import '../models/user_models.dart'; // For PatientBasicInfo (or your specific model)
import '../widgets/charts/overall_health_chart_widget.dart';
import '../widgets/charts/vital_chart_widget.dart';

class FamilyMemberDetailScreen extends StatefulWidget {
  final PatientBasicInfo memberInfo; // The family member whose data is being viewed

  const FamilyMemberDetailScreen({super.key, required this.memberInfo});

  @override
  State<FamilyMemberDetailScreen> createState() =>
      _FamilyMemberDetailScreenState();
}

class _FamilyMemberDetailScreenState extends State<FamilyMemberDetailScreen> {
  late List<MonthlyHealthSummary> _memberMonthlyHealthData;
  late Map<VitalType, List<VitalDataPoint>> _memberVitalData;
  bool _isLoading = true;
  final Random _random = Random(); // For dummy data

  @override
  void initState() {
    super.initState();
    _fetchDataForFamilyMember(widget.memberInfo.id);
  }

  Future<void> _fetchDataForFamilyMember(String memberId) async {
    if (mounted) setState(() => _isLoading = true);

    // --- TODO: ACTUAL API call to get data for the specific memberId ---
    // The backend MUST ensure the logged-in family member is authorized
    // to view this specific member's data.
    print("Fetching health data for family member ID: $memberId (${widget
        .memberInfo.name})");
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // --- Dummy Data Generation (replace with actual fetched data) ---
    // You might want slightly different dummy data patterns or ranges
    // if family members see slightly different views or data points.
    _memberMonthlyHealthData = List.generate(6, (index) {
      final monthDate = DateTime.now().subtract(Duration(days: index * 30));
      final monthName = _getMonthName(monthDate.month);
      return MonthlyHealthSummary(monthName, 55 + _random.nextDouble() * 35);
    }).reversed.toList();

    _memberVitalData = {};
    for (var type in VitalType.values) {
      _memberVitalData[type] = List.generate(30, (index) {
        final date = DateTime.now().subtract(Duration(days: 29 - index));
        double value = 0;
        switch (type) {
          case VitalType.heartRate:
            value = 60 + _random.nextDouble() * 45;
            break;
          case VitalType.bloodPressureSystolic:
            value = 95 + _random.nextDouble() * 50;
            break;
          case VitalType.bloodPressureDiastolic:
            value = 55 + _random.nextDouble() * 35;
            break;
          case VitalType.bloodOxygen:
            value = 94 + _random.nextDouble() * 5;
            break;
          case VitalType.temperature:
            value = 36.2 + _random.nextDouble() * 2.0;
            break;
        }
        return VitalDataPoint(date, value);
      });
    }
    // --- End Dummy Data Generation ---

    if (mounted) setState(() => _isLoading = false);
  }

  String _getMonthName(int month) {
    const monthNames = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return monthNames[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    final Color primaryColor = Theme
        .of(context)
        .colorScheme
        .primary;
    final Color secondaryColor = Theme
        .of(context)
        .colorScheme
        .secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.memberInfo.name}'s Health"),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surfaceTint, // Example theming
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => _fetchDataForFamilyMember(widget.memberInfo.id),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Viewing Health Data For:",
                        style: textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(widget.memberInfo.name,
                        style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text("Relationship: ${widget.memberInfo.relationship}",
                        style: textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text("Member ID: ${widget.memberInfo.id}",
                        style: textTheme.bodySmall),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
              child: Text("Overall Health Trend",
                  style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold)),
            ),
            OverallHealthChartWidget(
              healthData: _memberMonthlyHealthData,
              barColor: primaryColor.withOpacity(
                  0.7), // Slightly different color potentially
            ),
            const SizedBox(height: 24.0),

            Padding(
              padding: const EdgeInsets.only(bottom: 0.0),
              child: Text("Recent Vitals",
                  style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold)),
            ),
            ...VitalType.values.map((vital) {
              return VitalChartWidget(
                dataPoints: _memberVitalData[vital] ?? [],
                vitalName: vitalTypeToString(vital),
                vitalType: vital,
                lineColor: secondaryColor.withOpacity(0.8),
              );
            }).toList(),
            const SizedBox(height: 24.0),
            // TODO: Add any family-member-specific actions
            // e.g., "Send a supportive message" (requires more features)
            // or "View upcoming appointments for [Member Name]"
          ],
        ),
      ),
    );
  }
}