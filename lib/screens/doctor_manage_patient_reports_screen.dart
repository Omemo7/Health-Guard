import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:url_launcher/url_launcher.dart'; // If you want to open attachment URLs
import 'package:uuid/uuid.dart'; // Ensure this is imported

import '../models/health_models.dart';
import '../models/user_models.dart'; // For PatientBasicInfo
import 'doctor_add_edit_patient_report_screen.dart';

// --- Dummy Data for Medical Reports (for demonstration) ---
// In a real app, this would be fetched based on patientId.
// For now, we'll filter this global list in the screen.
final List<MedicalReport> _dummyMedicalReports = [
  MedicalReport(
    id: const Uuid().v4(),
    patientId: "patient_alice_123", // Matches one of the dummy patients
    doctorId: "doctor_smith_789",
    title: "Initial Consultation Summary",
    date: DateTime.now().subtract(const Duration(days: 30)),
    content: "Patient presented with symptoms of fatigue and occasional headaches. Recommended blood tests and a follow-up in 2 weeks. Discussed lifestyle modifications including diet and stress management.",
    reportType: "Consultation Note",
  ),
  MedicalReport(
    id: const Uuid().v4(),
    patientId: "patient_bob_456", // Different patient
    doctorId: "doctor_jones_101",
    title: "Quarterly Check-up",
    date: DateTime.now().subtract(const Duration(days: 10)),
    content: "Overall health stable. Blood pressure within normal limits. Reviewed medication adherence. Patient reports feeling well.",
    reportType: "Follow-up Note",
  ),
  MedicalReport(
    id: const Uuid().v4(),
    patientId: "patient_alice_123",
    doctorId: "doctor_smith_789",
    title: "Lab Results Review - Blood Panel",
    date: DateTime.now().subtract(const Duration(days: 15)),
    content: "Reviewed blood panel results. Mild vitamin D deficiency noted. Prescribed Vitamin D supplement. Other markers within normal range. Advised follow-up if symptoms persist or worsen.",
    reportType: "Lab Result Analysis",
    attachmentUrl: "https://example.com/reports/alice_blood_panel_01.pdf", // Placeholder
  ),
];

class ManagePatientReportsScreen extends StatefulWidget {
  final PatientBasicInfo patientInfo;
  final String doctorId; // ID of the currently logged-in doctor

  const ManagePatientReportsScreen({
    super.key,
    required this.patientInfo,
    required this.doctorId,
  });

  @override
  State<ManagePatientReportsScreen> createState() =>
      _ManagePatientReportsScreenState();
}

class _ManagePatientReportsScreenState
    extends State<ManagePatientReportsScreen> {
  List<MedicalReport> _patientReports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPatientReports();
  }

  Future<void> _loadPatientReports() async {
    if (mounted) setState(() => _isLoading = true);
    // --- TODO: ACTUAL API call to get reports for widget.patientInfo.id ---
    // The backend should filter reports by patientId
    await Future.delayed(
        const Duration(milliseconds: 500)); // Simulate API call

    // Filter dummy data for this patient
    _patientReports = _dummyMedicalReports
        .where((report) => report.patientId == widget.patientInfo.id)
        .toList();
    _patientReports.sort((a, b) => b.date.compareTo(a.date)); // Newest first

    if (mounted) setState(() => _isLoading = false);
  }

  void _navigateToAddEditReport({MedicalReport? report}) async {
    final result = await Navigator.push<MedicalReport>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddEditPatientReportScreen(
              initialReport: report,
              patientId: widget.patientInfo.id,
              doctorId: widget.doctorId, // Pass doctor's ID
            ),
      ),
    );

    if (result != null && mounted) {
      // --- TODO: Persist change to backend/local storage ---
      // For demo, update local list and global dummy list
      setState(() {
        final index = _patientReports.indexWhere((r) => r.id == result.id);
        if (index != -1) { // Editing
          _patientReports[index] = result;
          // Update dummy list
          final dummyIndex = _dummyMedicalReports.indexWhere((r) =>
          r.id == result.id);
          if (dummyIndex != -1) _dummyMedicalReports[dummyIndex] = result;
        } else { // Adding
          _patientReports.add(result);
          _dummyMedicalReports.add(result); // Add to global dummy list
        }
        _patientReports.sort((a, b) => b.date.compareTo(a.date)); // Re-sort
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Report ${report != null ? "updated" : "added"} successfully.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _confirmDeleteReport(MedicalReport report) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Report?'),
          content: Text(
              'Are you sure you want to delete the report titled "${report
                  .title}"? This cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteReport(report);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteReport(MedicalReport reportToDelete) {
    // --- TODO: Persist deletion to backend ---
    if (mounted) {
      setState(() {
        _patientReports.removeWhere((r) => r.id == reportToDelete.id);
        _dummyMedicalReports.removeWhere((r) => r.id == reportToDelete.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Report "${reportToDelete.title}" deleted.'),
            backgroundColor: Colors.orange),
      );
    }
  }

  // Future<void> _tryLaunchUrl(String? urlString) async {
  //   if (urlString == null || urlString.isEmpty) return;
  //   final Uri url = Uri.parse(urlString);
  //   if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Could not open the report link.')),
  //     );
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    final colorScheme = Theme
        .of(context)
        .colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.patientInfo.name}'s Reports"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _patientReports.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_off_outlined, size: 70, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No reports found for ${widget.patientInfo.name}.',
                style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Tap the "+" button to add the first report.',
                style: textTheme.bodyMedium),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _patientReports.length,
        itemBuilder: (context, index) {
          final report = _patientReports[index];
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 16),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(Icons.description_outlined,
                    color: colorScheme.onPrimaryContainer),
              ),
              title: Text(report.title, style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(DateFormat.yMMMd().format(report.date),
                      style: textTheme.bodySmall),
                  if(report.reportType != null) ...[
                    const SizedBox(height: 2),
                    Text("Type: ${report.reportType}",
                        style: textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic)),
                  ],
                  const SizedBox(height: 6),
                  Text(
                    report.content,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                  ),
                  // if (report.attachmentUrl != null && report.attachmentUrl!.isNotEmpty)
                  //   Padding(
                  //     padding: const EdgeInsets.only(top: 8.0),
                  //     child: ActionChip(
                  //       avatar: Icon(Icons.attachment_outlined, size: 16),
                  //       label: Text('View Attachment'),
                  //       onPressed: () => _tryLaunchUrl(report.attachmentUrl),
                  //     ),
                  //   ),
                ],
              ),
              isThreeLine: true,
              // Adjust if content makes it taller
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_outlined),
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToAddEditReport(report: report);
                  } else if (value == 'delete') {
                    _confirmDeleteReport(report);
                  }
                },
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(leading: Icon(Icons.edit_outlined),
                        title: Text('Edit')),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(leading: Icon(Icons.delete_outline,
                        color: Colors.red),
                        title: Text('Delete', style: TextStyle(
                            color: Colors.red))),
                  ),
                ],
              ),
              onTap: () {
                // Could navigate to a detailed view screen for the report,
                // or directly to edit for now.
                _navigateToAddEditReport(report: report);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEditReport(),
        icon: const Icon(Icons.add_outlined),
        label: const Text('New Report'),
      ),
    );
  }
}