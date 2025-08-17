
import 'package:flutter/material.dart';
import '../../models/user_models/Doctor.dart';
import '../../models/user_roles.dart';
import '../../widgets/AppDrawer.dart';
import '../Admin/DoctorDetailsScreen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  List<Doctor> _allDoctors = [];
  List<Doctor> _verifiedDoctors = [];
  List<Doctor> _unverifiedDoctors = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  void _fetchDoctors() {
    _allDoctors = [
      Doctor(id: 'doc1',
          name: 'Dr. Alice Smith',
          medicalLicenseNumber: 'MD12345',
          phoneNumber: '555-0101',
          gender: 'Female',
          specialty: 'Cardiology',
          isVerified: true,
          email: 'alice@example.com'),
      Doctor(id: 'doc2',
          name: 'Dr. Bob Johnson',
          medicalLicenseNumber: 'MD67890',
          phoneNumber: '555-0102',
          gender: 'Male',
          specialty: 'Pediatrics',
          isVerified: false,
          email: 'bob@example.com'),
      Doctor(id: 'doc3',
          name: 'Dr. Carol White',
          medicalLicenseNumber: 'MD24680',
          phoneNumber: '555-0103',
          gender: 'Female',
          specialty: 'Neurology',
          isVerified: true,
          email: 'carol@example.com'),
      Doctor(id: 'doc4',
          name: 'Dr. David Brown',
          medicalLicenseNumber: 'MD13579',
          phoneNumber: '555-0104',
          gender: 'Male',
          specialty: 'Oncology',
          isVerified: false,
          email: 'david@example.com'),
      Doctor(id: 'doc5',
          name: 'Dr. Eve Davis',
          medicalLicenseNumber: 'MD11223',
          phoneNumber: '555-0105',
          gender: 'Female',
          specialty: 'Dermatology',
          isVerified: false,
          email: 'eve@example.com'),
    ];
    _isLoading = false;
    _categorizeDoctors();
  }

  void _categorizeDoctors() {
    if (mounted) {
      setState(() {
        _verifiedDoctors = _allDoctors.where((doc) => doc.isVerified).toList();
        _unverifiedDoctors = _allDoctors.where((doc) => !doc.isVerified).toList();
      });
    }
  }

  Future<bool?> _showConfirmationDialog(Doctor doctor) async {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Action'),
          content: Text(
              'Are you sure you want to ${doctor.isVerified ? 'unverify' : 'verify'} ${doctor.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }

  void _toggleDoctorVerification(Doctor doctor) async {
    final bool? confirm = await _showConfirmationDialog(doctor);
    if (confirm == true && mounted) {
      final bool wasVerified = doctor.isVerified;
      setState(() {
        doctor.isVerified = !doctor.isVerified;
        _categorizeDoctors();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${doctor.name} has been ${wasVerified ? 'unverified' : 'verified'} successfully.'),
          backgroundColor: wasVerified ? Colors.orange : Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(
        userName: 'Admin User',
        userEmail: 'admin@example.com',
        currentUserRole: UserRole.admin,
      ),
      appBar: AppBar(
        title: const Text('Doctors List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _isLoading ? null : _fetchDoctors,
            tooltip: 'Refresh Doctors List',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                            size: 50),
                        const SizedBox(height: 10),
                        Text(_error!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                        const SizedBox(height: 20),
                        ElevatedButton(
                            onPressed: _fetchDoctors,
                            child: const Text('Retry'))
                      ],
                    ),
                  ),
                )
              : _allDoctors.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.people_outline,
                              size: 60, color: Colors.grey),
                          const SizedBox(height: 16),
                          const Text('No doctors found.',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey)),
                          const SizedBox(height: 10),
                          ElevatedButton(
                              onPressed: _fetchDoctors,
                              child: const Text('Refresh'))
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(8.0),
                      children: [
                        _buildDoctorSection(
                          title:
                              'Unverified Doctors (${_unverifiedDoctors.length})',
                          doctors: _unverifiedDoctors,
                          isUnverifiedSection: true,
                        ),
                        const SizedBox(height: 20),
                        _buildDoctorSection(
                          title: 'Verified Doctors (${_verifiedDoctors.length})',
                          doctors: _verifiedDoctors,
                          isUnverifiedSection: false,
                        ),
                      ],
                    ),
    );
  }

  Widget _buildDoctorSection({
    required String title,
    required List<Doctor> doctors,
    required bool isUnverifiedSection,
  }) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Text(
            title,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (doctors.isEmpty)
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Center(
              child: Text(
                isUnverifiedSection
                    ? 'No doctors awaiting verification.'
                    : 'No doctors have been verified yet.',
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                elevation: 2,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: doctor.isVerified
                        ? colorScheme.primaryContainer
                        : colorScheme.tertiaryContainer,
                    child: Text(
                        doctor.name.isNotEmpty
                            ? doctor.name[0].toUpperCase()
                            : 'D',
                        style: TextStyle(
                            color: doctor.isVerified
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onTertiaryContainer)),
                  ),
                  title: Text(doctor.name,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500)),
                  subtitle: Text("${doctor.specialty}\n${doctor.email}",
                      style: textTheme.bodySmall),
                  trailing: ElevatedButton(
                    onPressed: () => _toggleDoctorVerification(doctor),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: doctor.isVerified
                          ? Colors.grey[400]
                          : colorScheme.primary,
                      foregroundColor: doctor.isVerified
                          ? Colors.black87
                          : colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                    ),
                    child: Text(doctor.isVerified ? 'Unverify' : 'Verify'),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorDetailsScreen(doctor: doctor),
                      ),
                    );
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
