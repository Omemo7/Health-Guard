import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/MedicationRemainder.dart';

class AddEditMedicationReminderScreen extends StatefulWidget {
  final MedicationReminder? initialReminder;

  const AddEditMedicationReminderScreen({super.key, this.initialReminder});

  @override
  State<AddEditMedicationReminderScreen> createState() =>
      _AddEditMedicationReminderScreenState();
}

class _AddEditMedicationReminderScreenState
    extends State<AddEditMedicationReminderScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _medicationName;
  late String _dosage;
  late TimeOfDay _selectedTime;
  final Set<DayOfWeek> _selectedDays = {};
  late bool _isEnabled;
  String? _notes;

  @override
  void initState() {
    super.initState();
    if (widget.initialReminder != null) {
      _medicationName = widget.initialReminder!.medicationName;
      _dosage = widget.initialReminder!.dosage;
      _selectedTime = widget.initialReminder!.time;
      _selectedDays.addAll(widget.initialReminder!.days);
      _isEnabled = widget.initialReminder!.isEnabled;
      _notes = widget.initialReminder!.notes;
    } else {
      _medicationName = '';
      _dosage = '';
      _selectedTime = TimeOfDay.now();
      _selectedDays.add(DayOfWeek.values[DateTime
          .now().weekday - 1]);
      _isEnabled = true;
      _notes = null;
    }
  }

  Future<void> _pickTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _onSave() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_selectedDays.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one day.')),
        );
        return;
      }

      final reminder = MedicationReminder(
        id: widget.initialReminder?.id ?? const Uuid().v4(),
        medicationName: _medicationName,
        dosage: _dosage,
        time: _selectedTime,
        days: _selectedDays.toList()
          ..sort((a, b) => a.index.compareTo(b.index)),
        isEnabled: _isEnabled,
        notes: _notes,
      );
      Navigator.of(context).pop(reminder);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.initialReminder == null ? 'Add Reminder' : 'Edit Reminder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_outlined),
            onPressed: _onSave,
            tooltip: "Save Reminder",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: _medicationName,
                decoration: const InputDecoration(labelText: 'Medication Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.medication_outlined)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter medication name';
                  }
                  return null;
                },
                onSaved: (value) => _medicationName = value!,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _dosage,
                decoration: const InputDecoration(
                    labelText: 'Dosage (e.g., 1 tablet, 10mg)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.scale_outlined)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter dosage';
                  }
                  return null;
                },
                onSaved: (value) => _dosage = value!,
              ),
              const SizedBox(height: 20),
              Text('Reminder Time', style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
              const SizedBox(height: 8),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.alarm_outlined, size: 30),
                title: Text(_selectedTime.format(context), style: Theme
                    .of(context)
                    .textTheme
                    .headlineSmall),
                trailing: const Icon(Icons.arrow_drop_down_circle_outlined),
                onTap: _pickTime,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Theme
                      .of(context)
                      .dividerColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                tileColor: Theme
                    .of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.3),
              ),
              const SizedBox(height: 20),
              Text('Repeat On', style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: DayOfWeek.values.map((day) {
                  final isSelected = _selectedDays.contains(day);
                  return FilterChip(
                    label: Text(dayOfWeekToString(day).substring(0, 3)),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedDays.add(day);
                        } else {
                          _selectedDays.remove(day);
                        }
                      });
                    },
                    selectedColor: Theme
                        .of(context)
                        .colorScheme
                        .primaryContainer,
                    checkmarkColor: Theme
                        .of(context)
                        .colorScheme
                        .onPrimaryContainer,
                  );
                }).toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(onPressed: () {
                    setState(() {
                      _selectedDays.clear();
                      _selectedDays.addAll(DayOfWeek.values);
                    });
                  }, child: const Text("Select All")),
                  TextButton(onPressed: () {
                    setState(() {
                      _selectedDays.clear();
                    });
                  }, child: const Text("Clear All"))
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _notes,
                decoration: const InputDecoration(labelText: 'Notes (Optional)',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.notes_outlined)),
                maxLines: 2,
                onSaved: (value) => _notes = value,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Enable Reminder'),
                value: _isEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isEnabled = value;
                  });
                },
                secondary: Icon(
                    _isEnabled ? Icons.notifications_active_outlined : Icons
                        .notifications_off_outlined),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save_alt_outlined),
                  label: Text(widget.initialReminder == null
                      ? 'Add Reminder'
                      : 'Update Reminder',
                      style: const TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  onPressed: _onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}