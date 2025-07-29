import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart'; // For dummy data ID generation
import '../models/medication_models.dart';
import 'medication_reminder_form_screen.dart'; // The form screen

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({super.key});

  @override
  State<MedicationReminderScreen> createState() =>
      _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  // --- TODO: Replace this with data from a service/database ---
  List<MedicationReminder> _reminders = [];
  bool _isLoading = true; // Simulate initial loading

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() => _isLoading = true);
    // --- TODO: Actual data loading logic from persistence (e.g., SharedPreferences, SQLite, Firebase) ---
    await Future.delayed(const Duration(milliseconds: 700)); // Simulate loading

    // Dummy Data (Replace with actual data)
    // For consistent dummy IDs, only generate if _reminders is empty.
    if (_reminders.isEmpty && mounted) {
      _reminders = [
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
    }
    _sortReminders();
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _sortReminders() {
    _reminders.sort((a, b) {
      final timeA = a.time.hour * 60 + a.time.minute;
      final timeB = b.time.hour * 60 + b.time.minute;
      return timeA.compareTo(timeB);
    });
  }

  void _addOrUpdateReminder(MedicationReminder reminder) {
    // --- TODO: Persist change to backend/local storage ---
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder; // Update
    } else {
      _reminders.add(reminder); // Add
    }
    _sortReminders();
    // --- TODO: Schedule/update actual device notification ---
  }



  void _deleteReminder(String reminderId) {
    // --- TODO: Persist change to backend/local storage ---

    // --- OPTIONAL: Temporarily store the deleted item for a true Undo ---
    MedicationReminder? deletedReminder;
    int? deletedReminderIndex;
    final index = _reminders.indexWhere((r) => r.id == reminderId);
    if (index != -1) {
      deletedReminder = _reminders[index];
      deletedReminderIndex = index;
      _reminders.removeAt(
          index); // Remove from current list immediately for UI update
      setState(() {}); // Update UI to show item is gone
    }
    // --- End Optional Undo preparation ---


    // --- TODO: Cancel actual device notification ---
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reminder deleted.'),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () async { // Make the onPressed async
            if (deletedReminder != null && deletedReminderIndex != null) {
              // --- If using temporary storage for Undo ---
              _reminders.insert(deletedReminderIndex, deletedReminder!);
              _sortReminders(); // Re-sort if needed
              // --- TODO: Re-schedule notification for the undone reminder ---
              setState(() {}); // Update UI with the restored item
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Deletion undone.'))
              );
              // --- End Undo from temporary storage ---
            } else {
              // --- Fallback to reloading if not using temporary undo ---
              // This is your original approach, but now awaited
              // It assumes _loadReminders will correctly repopulate the list
              // including the "deleted" item (if it was from dummy data)
              await _loadReminders(); // Await the loading process
              // _loadReminders should call setState internally when it's done
              // If _loadReminders doesn't call setState, you might need it here,
              // but it's better if the data loading function handles its own UI update.
              // If _loadReminders already calls setState, an extra one here is redundant.
              // For now, let's assume _loadReminders will call setState:
            }
          },
        ),
      ),
    );
    // No setState here if you are using the temporary undo, as it was called before the SnackBar
  }

  void _toggleReminderStatus(MedicationReminder reminder, bool isEnabled) {
    // --- TODO: Persist change to backend/local storage ---
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder.copyWith(isEnabled: isEnabled);
      // --- TODO: Schedule/cancel actual device notification based on new status ---
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Reminder ${isEnabled ? "enabled" : "disabled"}'))
      );
    }
  }

  void _navigateToForm({MedicationReminder? reminder}) async {
    final result = await Navigator.push<MedicationReminder>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MedicationReminderFormScreen(initialReminder: reminder),
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
            onPressed: _loadReminders, // For manual refresh
            tooltip: "Refresh Reminders",
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reminders.isEmpty
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
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          return _buildReminderCard(reminder);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToForm(),
        label: const Text('Add Reminder'),
        icon: const Icon(Icons.add_alarm_outlined),
        // backgroundColor: Theme.of(context).colorScheme.primary,
        // foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildReminderCard(MedicationReminder reminder) {
    final cardColor = reminder.isEnabled
        ? Theme
        .of(context)
        .colorScheme
        .surfaceVariant
        : Theme
        .of(context)
        .colorScheme
        .surfaceVariant
        .withAlpha(100);
    final onCardColor = reminder.isEnabled
        ? Theme
        .of(context)
        .colorScheme
        .onSurfaceVariant
        : Theme
        .of(context)
        .colorScheme
        .onSurfaceVariant
        .withAlpha(150);


    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      color: cardColor,
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
              color: reminder.isEnabled ? Theme
                  .of(context)
                  .colorScheme
                  .primary : Colors.grey,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reminder.medicationName,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                        fontWeight: FontWeight.bold, color: onCardColor),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reminder.dosage,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: onCardColor),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time_filled_rounded, size: 16,
                          color: onCardColor.withOpacity(0.8)),
                      const SizedBox(width: 4),
                      Text(
                        reminder.timeFormatted(context),
                        style: Theme
                            .of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: onCardColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Days: ${reminder.daysFormatted}",
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: onCardColor),
                  ),
                  if (reminder.notes != null && reminder.notes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      "Notes: ${reminder.notes}",
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(
                          fontStyle: FontStyle.italic, color: onCardColor),
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
                  activeColor: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: onCardColor),
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
              'Are you sure you want to delete the reminder for "${reminder
                  .medicationName}"? This action cannot be undone immediately here.'),
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