import 'package:flutter/material.dart';

import '../../models/user_models/DoctorSearchResultInfo.dart';

// Dummy model for a doctor's report
class DoctorReport {
  final String reportId;
  final String title;
  final DateTime date;
  final String summary;
  final String? downloadUrl; // Optional

  DoctorReport({
    required this.reportId,
    required this.title,
    required this.date,
    required this.summary,
    this.downloadUrl,
  });
}

class DoctorDetailsScreen extends StatefulWidget {
  final DoctorSearchResultInfo doctorInfo;

  const DoctorDetailsScreen({super.key, required this.doctorInfo});

  @override
  State<DoctorDetailsScreen> createState() =>
      _DoctorDetailsScreenState();
}

class _DoctorDetailsScreenState extends State<DoctorDetailsScreen> {
  List<DoctorReport> _doctorReports = [];
  bool _isLoadingReports = false;

  @override
  void initState() {
    super.initState();
    _fetchDoctorReports();
  }

  Future<void> _fetchDoctorReports() async {
    if (mounted) setState(() => _isLoadingReports = true);
    // Simulate API call to fetch reports for this doctor
    await Future.delayed(const Duration(seconds: 1));

    // Dummy reports data
    // In a real app, you would fetch reports related to the current patient
    // AND this specific doctor widget.doctorInfo.doctorId
    _doctorReports = [
      DoctorReport(
        reportId: 'REP001',
        title: 'Annual Check-up Summary',
        date: DateTime.now().subtract(const Duration(days: 30)),
        summary: 'Patient is in good health. Minor cholesterol elevation, advised dietary changes.',
        downloadUrl: 'https://example.com/report1.pdf', // Dummy URL
      ),
      DoctorReport(
        reportId: 'REP002',
        title: 'Blood Test Results',
        date: DateTime.now().subtract(const Duration(days: 90)),
        summary: 'All parameters within normal range.',
      ),
      DoctorReport(
        reportId: 'REP003',
        title: 'Follow-up Consultation Notes',
        date: DateTime.now().subtract(const Duration(days: 15)),
        summary: 'Discussed medication adherence. Patient reports feeling well.',
      ),
    ];

    if (mounted) {
      setState(() {
        _isLoadingReports = false;
      });
    }
  }

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
        title: Text(widget.doctorInfo.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Doctor Info Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: widget.doctorInfo.profileImageUrl != null
                          ? NetworkImage(widget.doctorInfo.profileImageUrl!)
                          : null,
                      child: widget.doctorInfo.profileImageUrl == null
                          ? Text(
                          widget.doctorInfo.name.isNotEmpty ? widget.doctorInfo
                              .name[0] : 'D', style: textTheme.headlineSmall)
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.doctorInfo.name,
                            style: textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Doctor ID: ${widget.doctorInfo.doctorId}",
                            // You might want to display specialty or other info here
                            style: textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[700]),
                          ),
                          if (widget.doctorInfo.isCurrentlyLinkedToThisDoctor)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Chip(
                                avatar: Icon(Icons.check_circle,
                                    color: colorScheme.primary),
                                label: Text('Linked', style: TextStyle(
                                    color: colorScheme.primary)),
                                backgroundColor: colorScheme.primaryContainer
                                    .withOpacity(0.5),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Doctor Reports Section
            Text(
              "Doctor Reports",
              style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _isLoadingReports
                ? const Center(child: CircularProgressIndicator())
                : _doctorReports.isEmpty
                ? Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    "No reports available from this doctor yet.",
                    style: textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600]),
                  ),
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _doctorReports.length,
              itemBuilder: (context, index) {
                final report = _doctorReports[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6.0),
                  child: ListTile(
                    leading: Icon(
                        Icons.description_outlined, color: colorScheme.primary),
                    title: Text(report.title, style: textTheme.titleMedium),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date: ${report.date.toLocal().toString().split(
                            ' ')[0]}"),
                        Text(report.summary, maxLines: 2, overflow: TextOverflow
                            .ellipsis),
                      ],
                    ),
                    trailing: report.downloadUrl != null
                        ? IconButton(
                      icon: Icon(Icons.download_for_offline_outlined,
                          color: colorScheme.secondary),
                      onPressed: () {
                        // TODO: Implement report download functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              'Download started for ${report.title}')),
                        );
                      },
                    )
                        : null,
                    onTap: () {
                      // TODO: Implement navigation to a full report view screen if needed
                      showDialog(
                          context: context,
                          builder: (_) =>
                              AlertDialog(
                                title: Text(report.title),
                                content: SingleChildScrollView(child: Text(
                                    "Date: ${report.date
                                        .toLocal()
                                        .toString()
                                        .split(' ')[0]}\n\n${report.summary}")),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text("Close"))
                                ],
                              ));
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}