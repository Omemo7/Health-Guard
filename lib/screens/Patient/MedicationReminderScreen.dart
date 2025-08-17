import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/MedicationRemainder.dart';
import 'AddEditMedicationReminderScreen.dart';

List<MedicationReminder> _globalReminders = [];
bool _globalRemindersInitialized = false;

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({super.key, MedicationReminder? initialReminder});

  @override
  State<MedicationReminderScreen> createState() =>
      _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }
  Future<void> _loadReminders() async {
    setState(() => _isLoading = true);



    if (!_globalRemindersInitialized && mounted) {
      _globalReminders = [
        MedicationReminder(id: const Uuid().v4(),
            medicationName: "Metformin",
            dosage: "500mg tablet",
            time: const TimeOfDay(hour: 8, minute: 0),
            days: [
              DayOfWeek.monday,
              DayOfWeek.tuesday,
              DayOfWeek.wednesday,
              DayOfWeek.thursday,
              DayOfWeek.friday,
              DayOfWeek.saturday,
              DayOfWeek.sunday
            ],
            notes: "Take with breakfast"),
        MedicationReminder(id: const Uuid().v4(),
            medicationName: "Lisinopril",
            dosage: "10mg tablet",
            time: const TimeOfDay(hour: 9, minute: 30),
            days: [DayOfWeek.monday, DayOfWeek.wednesday, DayOfWeek.friday],
            isEnabled: true),
        MedicationReminder(id: const Uuid().v4(),
            medicationName: "Amoxicillin",
            dosage: "250mg capsule",
            time: const TimeOfDay(hour: 20, minute: 0),
            days: [DayOfWeek.tuesday, DayOfWeek.thursday],
            isEnabled: false,
            notes: "Finish the course"),
      ];
      _globalRemindersInitialized = true;
    }
    _sortGlobalReminders();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _sortGlobalReminders() {
    _globalReminders.sort((a, b) {
      final timeA = a.time.hour * 60 + a.time.minute;
      final timeB = b.time.hour * 60 + b.time.minute;
      return timeA.compareTo(timeB);
    });
  }

  void _addOrUpdateReminder(MedicationReminder reminder) {
    final index = _globalReminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _globalReminders[index] = reminder;
    } else {
      _globalReminders.add(reminder);
    }
    _sortGlobalReminders();
  }

  void _deleteReminder(String reminderId) {
    MedicationReminder? deletedReminder;
    int? deletedReminderIndex;
    final index = _globalReminders.indexWhere((r) => r.id == reminderId);

    if (index != -1) {
      deletedReminder = _globalReminders[index];
      deletedReminderIndex = index;
      _globalReminders.removeAt(index);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Reminder deleted.'),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              if (deletedReminder != null && deletedReminderIndex != null) {
                _globalReminders.insert(deletedReminderIndex, deletedReminder!);
                _sortGlobalReminders();
                if (mounted) {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Deletion undone.'))
                  );
                }
              }
            },          ),
        ),
      );
    }
  }

  void _toggleReminderStatus(MedicationReminder reminder, bool isEnabled) {

    final index = _globalReminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _globalReminders[index] = reminder.copyWith(isEnabled: isEnabled);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Reminder ${isEnabled ? "enabled" : "disabled"}'))
        );
      }
    }
  }

  void _navigateToForm({MedicationReminder? reminder}) async {
    final result = await Navigator.push<MedicationReminder>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditMedicationReminderScreen(initialReminder: reminder),
      ),
    );

    if (result != null && mounted) {
      setState(() {
        _addOrUpdateReminder(result);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medication Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () async {
              _globalRemindersInitialized = false;
              await _loadReminders();
            },
            tooltip: "Refresh Reminders",
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _globalReminders.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
                Icons.medication_liquid_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'No medication reminders set yet.',
              style: Theme
                  .of(context)
                  .textTheme
                  .titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Tap the "+" button to add your first reminder.'),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_alarm_outlined),
              label: const Text('Add First Reminder'),
              onPressed: () => _navigateToForm(),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        itemCount: _globalReminders.length,
        itemBuilder: (context, index) {
          final reminder = _globalReminders[index];
          return _buildReminderCard(reminder);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(),
        label: const Text('Add Reminder'),
        icon: const Icon(Icons.add_alarm_outlined),
      ),
    );
  }

  Widget _buildReminderCard(MedicationReminder reminder) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    Color cardBackgroundColor;
    Color contentColor; 
    Color secondaryContentColor; 
    Color alarmStatusIconColor;
    Color moreVertIconColor;

    if (reminder.isEnabled) {
      cardBackgroundColor = colorScheme.surfaceContainerHigh;
      contentColor = colorScheme.onSurfaceVariant; 
      secondaryContentColor = colorScheme.onSurfaceVariant.withOpacity(0.75);
      alarmStatusIconColor = colorScheme.primary;
      moreVertIconColor = colorScheme.onSurfaceVariant;
    } else {
      cardBackgroundColor = colorScheme.surfaceVariant.withOpacity(0.6); 
      contentColor = colorScheme.onSurfaceVariant.withOpacity(0.5); 
      secondaryContentColor = colorScheme.onSurfaceVariant.withOpacity(0.4);
      alarmStatusIconColor = colorScheme.onSurface.withOpacity(0.38); 
      moreVertIconColor = colorScheme.onSurfaceVariant.withOpacity(0.5);
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.only(
            top: 8.0, bottom: 8.0, left: 16.0, right: 8.0),
        child: Row(
          children: [
            Icon(
              reminder.isEnabled ? Icons.alarm_on_outlined : Icons
                  .alarm_off_outlined,
              size: 36,
              color: alarmStatusIconColor,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.medicationName,
                    style: theme
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                        fontWeight: FontWeight.bold, color: contentColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reminder.dosage,
                    style: theme
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: contentColor),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time_filled_rounded, size: 16,
                          color: secondaryContentColor),
                      const SizedBox(width: 4),
                      Text(
                        reminder.timeFormatted(context),
                        style: theme
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: contentColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Days: ${reminder.daysFormatted}",
                    style: theme
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: secondaryContentColor),
                  ),
                  if (reminder.notes != null && reminder.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      "Notes: ${reminder.notes}",
                      style: theme
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                          fontStyle: FontStyle.italic, color: secondaryContentColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: reminder.isEnabled,
                  onChanged: (bool value) {
                    setState(() {
                      _toggleReminderStatus(reminder, value);
                    });
                  },
                  activeColor: colorScheme.primary,
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: moreVertIconColor),
                  onSelected: (value) {
                    if (value == 'edit') {
                      _navigateToForm(reminder: reminder);
                    } else if (value == 'delete') {
                      _showDeleteConfirmation(reminder);
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
                      child: ListTile(leading: Icon(
                          Icons.delete_outline, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors
                              .red))),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmation(MedicationReminder reminder) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Reminder?'),
          content: Text(
              'Are you sure you want to delete the reminder for "${reminder.medicationName}"?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() {
        _deleteReminder(reminder.id);
      });
    }
  }
}
