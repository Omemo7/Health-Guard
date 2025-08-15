import 'package:flutter/material.dart';
import 'dart:math'; // For dummy data generation


import '../../models/health_models/MonthlyHealthSummary.dart';
import '../../models/health_models/VitalDataPoint.dart';
import '../../models/health_models/VitalLogEntry.dart';
import '../../models/user_models/PatientBasicInfo.dart';
import '../../widgets/charts/overall_health_chart_widget.dart';
import '../../widgets/charts/vital_chart_widget.dart';
import 'ManagePatientReportsScreen.dart';

class PatientDetailScreen extends StatefulWidget {
  final PatientBasicInfo patientInfo;

  const PatientDetailScreen({super.key, required this.patientInfo});

  @override
  State<PatientDetailScreen> createState() =>
      _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late List<MonthlyHealthSummary> _patientMonthlyHealthData;
  late Map<VitalType, List<VitalDataPoint>> _patientVitalData;
  bool _isLoading = true;
  final Random _random = Random(); // For dummy data

  @override
  void initState() {
    super.initState();
    _fetchDataForPatient(widget.patientInfo.id);
  }

  Future<void> _fetchDataForPatient(String patientId) async {
    if (mounted) setState(() => _isLoading = true);

    // --- TODO: ACTUAL API call to get data for the specific patientId ---
    // The backend should ensure the doctor is authorized to see this patient's data.
    print("Fetching health data for patient ID: $patientId (${widget.patientInfo
        .name})");
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call

    // --- Dummy Data Generation (replace with actual fetched data) ---
    _patientMonthlyHealthData = List.generate(6, (index) {
      final monthDate = DateTime.now().subtract(Duration(days: index * 30));
      final monthName = _getMonthName(monthDate.month);
      return MonthlyHealthSummary(monthName, 50 +
          _random.nextDouble() * 40); // Slightly different range for variety
    }).reversed.toList();

    _patientVitalData = {};
    for (var type in VitalType.values) {
      _patientVitalData[type] = List.generate(30, (index) {
        final date = DateTime.now().subtract(Duration(days: 29 - index));
        double value = 0;
        switch (type) {
          case VitalType.heartRate:
            value = 55 + _random.nextDouble() * 50;
            break;
          case VitalType.bloodPressureSystolic:
            value = 90 + _random.nextDouble() * 60;
            break;
          case VitalType.bloodPressureDiastolic:
            value = 50 + _random.nextDouble() * 40;
            break;
          case VitalType.bloodOxygen:
            value = 93 + _random.nextDouble() * 6;
            break;
          case VitalType.temperature:
            value = 36.0 + _random.nextDouble() * 2.5;
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
        title: Text(widget.patientInfo.name),
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .surfaceVariant, // Slightly different AppBar color
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => _fetchDataForPatient(widget.patientInfo.id),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Patient Info Header (Optional)
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
                    Text(widget.patientInfo.name,
                        style: textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("Patient ID: ${widget.patientInfo.id}",
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
              healthData: _patientMonthlyHealthData,
              barColor: primaryColor.withOpacity(
                  0.8), // Doctor might have consistent color scheme
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
                dataPoints: _patientVitalData[vital] ?? [],
                vitalName: vitalTypeToString(vital),
                vitalType: vital,
                lineColor: secondaryColor.withOpacity(0.9),
              );
            }).toList(),
            const SizedBox(height: 24.0),
            Card(
              elevation: 1,
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                leading: Icon(Icons.assignment_outlined, color: Theme.of(context).colorScheme.primary),
                title: Text("Medical Reports", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600)),
                subtitle: Text("View, add, or edit reports for ${widget.patientInfo.name}"),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                onTap: () {
                  // --- TODO: Get the current doctor's ID ---
                  // For now, let's assume a placeholder doctorId.
                  // In a real app, this would come from your authentication state.
                  const String currentDoctorId = "doctor_logged_in_123"; // <<-- REPLACE THIS

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagePatientReportsScreen(
                        patientInfo: widget.patientInfo,
                        doctorId: currentDoctorId,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 24.0),
            // TODO: Add any doctor-specific actions here
            // e.g., Button to add notes, prescribe medication, schedule follow-up
          ],
        ),
      ),
    );
  }
}