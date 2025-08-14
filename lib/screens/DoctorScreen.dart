import 'package:flutter/material.dart';
import 'package:health_guard_flutter/models/user_roles.dart';
import 'dart:math'; // For dummy data
import '../widgets/app_drawer.dart'; // For the drawer
import '../models/user_models.dart'; // For PatientBasicInfo
import 'doctor_patient_detail_screen.dart'; // The detail screen we just created

class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key});

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  List<PatientBasicInfo> _doctorPatients = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchDoctorPatients();
  }

  Future<void> _fetchDoctorPatients() async {
    if (mounted) setState(() => _isLoading = true);

    // --- TODO: ACTUAL API call to get the list of patients for this doctor ---
    // This will involve authentication to identify the doctor.
    print("Fetching list of patients for the doctor...");
    await Future.delayed(
        const Duration(milliseconds: 1500)); // Simulate API call

    // --- Dummy Data Generation (replace with actual fetched data) ---
    final Random random = Random();
    const firstNames = [
      "Alice",
      "Bob",
      "Charlie",
      "Diana",
      "Edward",
      "Fiona",
      "George",
      "Hannah"
    ];
    const lastNames = [
      "Smith",
      "Jones",
      "Williams",
      "Brown",
      "Davis",
      "Miller",
      "Wilson",
      "Moore"
    ];
    _doctorPatients = List.generate(15, (index) {
      final name = '${firstNames[random.nextInt(
          firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}';
      return PatientBasicInfo(
        id: 'PID${1000 + index}',
        name: name,
        profileImageUrl: random.nextBool()
            ? 'https://i.pravatar.cc/150?u=$name'
            : null, // Random avatar
        lastActivity: "Last vital: ${random.nextInt(7) + 1} days ago",
      );
    });
    _doctorPatients.sort((a, b) => a.name.compareTo(b.name)); // Sort by name
    // --- End Dummy Data Generation ---

    if (mounted) setState(() => _isLoading = false);
  }

  List<PatientBasicInfo> get _filteredPatients {
    if (_searchQuery.isEmpty) {
      return _doctorPatients;
    }
    return _doctorPatients
        .where((patient) =>
        patient.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _navigateToPatientDetail(PatientBasicInfo patient) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorPatientDetailScreen(patientInfo: patient),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    final String _adminName = "Super Admin";
    final String _adminEmail = "admin@healthguard.com";
    final String? _adminProfilePic = null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Patients"),
        // backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        // foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDoctorPatients,
            tooltip: "Refresh List",
          )
        ],
        bottom: PreferredSize( // Search Bar
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search patients...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme
                    .of(context)
                    .colorScheme
                    .surface,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 20),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      drawer: AppDrawer(
        currentUserRole: UserRole.doctor, // <-- Set the role to admin
        userName: _adminName,
        userEmail: _adminEmail,
        userProfileImageUrl: _adminProfilePic,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredPatients.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            _searchQuery.isNotEmpty
                ? "No patients found matching '$_searchQuery'."
                : "You have no patients assigned yet.",
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchDoctorPatients,
        child: ListView.builder(
          itemCount: _filteredPatients.length,
          itemBuilder: (context, index) {
            final patient = _filteredPatients[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 6.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .secondaryContainer,
                  foregroundColor: Theme
                      .of(context)
                      .colorScheme
                      .onSecondaryContainer,
                  backgroundImage: patient.profileImageUrl != null
                      ? NetworkImage(patient.profileImageUrl!)
                      : null,
                  child: patient.profileImageUrl == null
                      ? Text(patient.name.isNotEmpty
                      ? patient.name[0].toUpperCase()
                      : 'P')
                      : null,
                ),
                title: Text(patient.name,
                    style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500)),
                subtitle: Text(
                    patient.lastActivity, style: textTheme.bodySmall),
                trailing: Icon(Icons.chevron_right, color: Theme
                    .of(context)
                    .colorScheme
                    .outline),
                onTap: () => _navigateToPatientDetail(patient),
              ),
            );
          },
        ),
      ),
      // Optional: Floating Action Button to add a new patient (if applicable for doctors)
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // TODO: Implement add new patient flow for doctor
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       const SnackBar(content: Text('Add new patient action (TODO)')),
      //     );
      //   },
      //   child: const Icon(Icons.person_add_alt_1_outlined),
      // ),
    );
  }
}