import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/health_models/VitalLogEntry.dart';
import 'AddEditVitalLogScreen.dart';
import 'package:uuid/uuid.dart';

final List<VitalLogEntry> _dummyVitalLogEntries = [
  VitalLogEntry(
    id: const Uuid().v4(),
    timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
    readings: {
      VitalType.heartRate: 72.0,
      VitalType.bloodPressureSystolic: 122.0,
      VitalType.bloodPressureDiastolic: 78.0,
      VitalType.temperature: 36.7,
    },
    notes: "Feeling a bit tired post-lunch.",
  ),
  VitalLogEntry(
    id: const Uuid().v4(),
    timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    readings: {
      VitalType.heartRate: 68.0,
      VitalType.bloodOxygen: 98.0,
    },
  ),
  VitalLogEntry(
    id: const Uuid().v4(),
    timestamp: DateTime.now().subtract(
        const Duration(days: 2, hours: 14, minutes: 30)),
    readings: {
      VitalType.heartRate: 80.0,
      VitalType.bloodPressureSystolic: 128.0,
      VitalType.bloodPressureDiastolic: 82.0,
      VitalType.temperature: 37.1,
      VitalType.bloodOxygen: 97.0,
    },
    notes: "Checked after morning walk. Felt good.",
  ),
  VitalLogEntry(
    id: const Uuid().v4(),
    timestamp: DateTime.now().subtract(const Duration(days: 3, hours: 10)),
    readings: {
      VitalType.temperature: 36.5,
    },
    notes: "Morning temperature check.",
  ),
];

class ManageVitalsScreen extends StatefulWidget {
  const ManageVitalsScreen({super.key});

  @override
  State<ManageVitalsScreen> createState() => _ManageVitalsScreenState();
}

class _ManageVitalsScreenState extends State<ManageVitalsScreen> {
  List<VitalLogEntry> _vitalLogs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVitalLogs();
  }

  Future<void> _loadVitalLogs() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    _dummyVitalLogEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    _vitalLogs = List.from(_dummyVitalLogEntries);

    setState(() => _isLoading = false);
  }

  void _navigateToAddEditLogScreen({VitalLogEntry? logEntry}) async {
    final result = await Navigator.push<VitalLogEntry>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditVitalLogScreen(initialLogEntry: logEntry),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        final existingIndex = _vitalLogs.indexWhere((log) =>
        log.id == result.id);
        if (existingIndex != -1) {
          _vitalLogs[existingIndex] = result;
          final dummyIndex = _dummyVitalLogEntries.indexWhere((log) =>
          log.id == result.id);
          if (dummyIndex != -1) {
            _dummyVitalLogEntries[dummyIndex] = result;
          }
        } else {
          _vitalLogs.add(result);
          _dummyVitalLogEntries.add(result);
        }
        _vitalLogs.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Vital log ${logEntry != null
              ? "updated"
              : "added"} successfully.'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _confirmDeleteLog(VitalLogEntry log) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Delete Vital Log?'),
          content: Text(
              'Are you sure you want to delete the vital readings recorded on ${DateFormat
                  .yMMMd().add_jm().format(
                  log.timestamp)}? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteLog(log);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteLog(VitalLogEntry logToDelete) {
    if (mounted) {
      setState(() {
        _vitalLogs.removeWhere((item) => item.id == logToDelete.id);
        _dummyVitalLogEntries.removeWhere((item) => item.id == logToDelete.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Vital log from ${DateFormat.yMMMd().format(
                logToDelete.timestamp)} removed.'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating),
      );
    }
  }

  IconData _getIconForVital(VitalType type) {
    switch (type) {
      case VitalType.heartRate:
        return Icons.favorite_border_outlined;
      case VitalType.bloodPressureSystolic:
      case VitalType.bloodPressureDiastolic:
        return Icons.monitor_heart_outlined;
      case VitalType.bloodOxygen:
        return Icons.opacity_outlined;
      case VitalType.temperature:
        return Icons.thermostat_outlined;
      default:
        return Icons.help_outline;
    }
  }

  Widget _buildVitalChip(VitalType type, double value, ColorScheme colorScheme,
      TextTheme textTheme) {
    return Chip(
      avatar: Icon(
          _getIconForVital(type), color: colorScheme.primary, size: 18),
      label: Text(
        '${vitalTypeToString(type, short: true)}: ${value.toStringAsFixed(
            type == VitalType.temperature ? 1 : 0)} ${getVitalUnit(type)}',
        style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSecondaryContainer),
      ),
      backgroundColor: colorScheme.secondaryContainer.withOpacity(0.8),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
    );
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
        title: const Text('My Vital Logs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _loadVitalLogs,
            tooltip: "Refresh Vitals",
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _vitalLogs.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.monitor_heart_outlined, size: 80,
                  color: Colors.grey[400]),
              const SizedBox(height: 20),
              Text('No vital logs recorded yet.',
                  style: textTheme.headlineSmall?.copyWith(
                      color: Colors.grey[700])),
              const SizedBox(height: 12),
              Text(
                'Tap the "+" button below to add your first set of vitals and start tracking your health.',
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.add_circle_outline),
                label: const Text('Add First Vital Log'),
                onPressed: () => _navigateToAddEditLogScreen(),
              ),
            ],
          ),
        ),
      )
          : ListView.separated(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
        itemCount: _vitalLogs.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final log = _vitalLogs[index];
          return Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _navigateToAddEditLogScreen(logEntry: log),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            DateFormat('EEEE, MMMM d, yyyy  h:mm a').format(
                                log.timestamp),
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert_outlined,
                              color: colorScheme.onSurfaceVariant),
                          onSelected: (value) {
                            if (value == 'edit') {
                              _navigateToAddEditLogScreen(logEntry: log);
                            } else if (value == 'delete') {
                              _confirmDeleteLog(log);
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: ListTile(
                                  leading: Icon(Icons.edit_outlined),
                                  title: Text('Edit')),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: ListTile(leading: Icon(
                                  Icons.delete_outline, color: Colors.red),
                                  title: Text('Delete',
                                      style: TextStyle(color: Colors.red))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 16, thickness: 0.5),
                    if (log.readings.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                            "No specific readings recorded for this entry.",
                            style: textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: colorScheme.onSurfaceVariant)),
                      )
                    else
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: log.readings.entries.map((entry) {
                          return _buildVitalChip(
                              entry.key, entry.value, colorScheme, textTheme);
                        }).toList(),
                      ),
                    if (log.notes != null && log.notes!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.speaker_notes_outlined, size: 18,
                                color: colorScheme.onSurfaceVariant),
                            const SizedBox(width: 8),
                            Expanded(child: Text(log.notes!,
                                style: textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant))),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEditLogScreen(),
        label: const Text('New Vital Log'),
        icon: const Icon(Icons.add_outlined),
      ),
    );
  }
}