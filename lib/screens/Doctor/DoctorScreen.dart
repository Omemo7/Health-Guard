import 'package:flutter/material.dart';
import 'package:health_guard_flutter/models/UserRoles.dart';
import 'dart:math'; // For dummy data
import '../../models/user_models/PatientBasicInfo.dart';
import '../../widgets/AppDrawer.dart'; // For the drawer

import 'PatientDetailScreen.dart'; // The detail screen we just created

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

    print("Fetching list of patients for the doctor...");
    

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
      final age = random.nextInt(60) + 18;
      final gender = random.nextBool() ? "Male" : "Female";
      return PatientBasicInfo(
        id: 'PID${1000 + index}',
        name: name,
        age: age,
        gender: gender,
        profileImageUrl: random.nextBool()
            ? 'https://i.pravatar.cc/150?u=$name'
            : null,
        lastActivity: "Last vital: ${random.nextInt(7) + 1} days ago",
      );
    });
    _doctorPatients.sort((a, b) => a.name.compareTo(b.name));

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
        builder: (context) => PatientDetailScreen(patientInfo: patient),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;

    final String _name = "Doctor";
    final String _email = "doctor@healthguard.com";
    final String? _profilePic = null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Patients"),

        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDoctorPatients,
            tooltip: "Refresh List",
          )
        ],
        bottom: PreferredSize(
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
      drawer: AppDrawer(),
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

    );
  }
}