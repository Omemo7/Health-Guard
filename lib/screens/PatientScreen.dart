// lib/screens/patient_screen.dart

import 'package:flutter/material.dart';
import 'dart:math'; // For random data generation

// Import centralized models and widgets
import '../models/health_models.dart';
import '../widgets/charts/overall_health_chart_widget.dart';
import '../widgets/charts/vital_chart_widget.dart';
import '../screens/medication_reminder_screen.dart';
import '../screens/link_doctor_screen.dart';
import '../screens/manage_family_members_screen.dart';
import '../screens/manage_vitals_screen.dart';

// --- (Keep your placeholder screens like PatientProfileScreen, AppSettingsScreen, AddFamilyMemberScreen etc. and their imports) ---
// Example: (Ensure these are correctly imported or defined)
// import 'patient_profile_screen.dart';
// import 'app_settings_screen.dart';
// import 'add_family_member_screen.dart';

// import 'set_vitals_screen.dart';

// Dummy placeholder screens (if not imported from separate files)
class PatientProfileScreen extends StatelessWidget { const PatientProfileScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('My Profile')), body: const Center(child: Text('Patient Profile Screen - TODO'))); }
class AppSettingsScreen extends StatelessWidget { const AppSettingsScreen({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text('Settings')), body: const Center(child: Text('App Settings Screen - TODO'))); }


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

  @override
  void initState() {
    super.initState();
    _fetchPatientDashboardData();
  }

  Future<void> _fetchPatientDashboardData() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    // --- TODO: Replace with ACTUAL asynchronous data fetching logic ---
    // This would involve API calls to get data for the currently logged-in patient.
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    // --- Start of Dummy Data Generation (for demonstration) ---
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
    // --- End of Dummy Data Generation ---

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

  // --- Navigation methods ---
  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.pop(context); // Close drawer if open
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }
  void _navigateWithoutClosingDrawer(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }


  void _logout(BuildContext context) {
    Navigator.pop(context); // Close the drawer
    // TODO: Implement actual logout logic (clear session, tokens, etc.)

    print("Logout tapped via drawer");
    // Navigate back to login screen, ensuring the patient screen is removed from stack
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
    // Assumes you have a '/login' route defined in your MaterialApp
  }


  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color secondaryColor = Theme.of(context).colorScheme.secondary;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        backgroundColor: primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
              child: Text('Health Guard', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontSize: 24)),
            ),
            ListTile(leading: const Icon(Icons.dashboard_outlined), title: const Text('Dashboard'), onTap: () => Navigator.pop(context)),
            ListTile(leading: const Icon(Icons.person_outline), title: const Text('My Profile'), onTap: () => _navigateTo(context, const PatientProfileScreen())),
            ListTile(leading: const Icon(Icons.settings_outlined), title: const Text('Settings'), onTap: () => _navigateTo(context, const AppSettingsScreen())),
            const Divider(),
            ListTile(leading: const Icon(Icons.logout), title: const Text('Logout'), onTap: () => _logout(context)),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: _fetchPatientDashboardData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // --- Welcome Card ---
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome, Patient!', style: textTheme.headlineSmall?.copyWith(color: primaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Here is your health overview and tools.', style: textTheme.bodyMedium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24.0),

            // --- Overall Health Summary Chart ---
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Overall Health Trend", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
            OverallHealthChartWidget(
              healthData: _monthlyHealthData,
              barColor: primaryColor.withOpacity(0.8),
            ),
            const SizedBox(height: 24.0),

            // --- Individual Vital Charts ---
            Padding(
              padding: const EdgeInsets.only(bottom: 0.0), // Reduced bottom padding
              child: Text("Recent Vitals", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
            // Using the reusable VitalChartWidget
            ...VitalType.values.map((vital) {
              return VitalChartWidget(
                dataPoints: _vitalData[vital] ?? [],
                vitalName: vitalTypeToString(vital),
                vitalType: vital,
                lineColor: secondaryColor.withOpacity(0.9),
              );
            }).toList(),
            const SizedBox(height: 16.0), // Space before action buttons

            // --- Action Buttons ---
            Padding(
              padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
              child: Text("Quick Actions", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
            _buildActionButton(
              context,
              icon: Icons.group_add_outlined,
              label: 'Manage Family Members',
              onTap: () => _navigateWithoutClosingDrawer(context, const ManageFamilyMembersScreen()),
            ),
            const SizedBox(height: 12.0),
            _buildActionButton(
              context,
              icon: Icons.medical_services_outlined,
              label: 'Link to Doctor',
              onTap: () => _navigateWithoutClosingDrawer(context, const LinkDoctorScreen()),
            ),
            const SizedBox(height: 12.0),
            _buildActionButton(
              context,
              icon: Icons.monitor_heart_outlined,
              label: 'Manage Vitals',
              onTap: () => _navigateWithoutClosingDrawer(context, const ManageVitalsScreen()),
            ),

            const SizedBox(height: 12.0),
            _buildActionButton(
              context,
              icon: Icons.alarm_add_outlined, // Or Icons.medication_outlined
              label: 'Medication Reminders',
              onTap: () => _navigateWithoutClosingDrawer(context, const MedicationReminderScreen()),
            ),


            const SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  // Helper widget for action buttons
  Widget _buildActionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24), // Slightly smaller icon
      label: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)), // Adjusted style
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Adjusted padding
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // Slightly smaller radius
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
