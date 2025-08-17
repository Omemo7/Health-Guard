import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';


import '../../models/health_models/VitalLogEntry.dart';

class AddEditVitalLogScreen extends StatefulWidget {
  final VitalLogEntry? initialLogEntry;

  const AddEditVitalLogScreen({super.key, this.initialLogEntry});

  @override
  State<AddEditVitalLogScreen> createState() => _AddEditVitalLogScreenState();
}

class _AddEditVitalLogScreenState extends State<AddEditVitalLogScreen> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedTimestamp;
  late TimeOfDay _selectedTime;

  final Map<VitalType, TextEditingController> _vitalControllers = {};
  late TextEditingController _notesController;

  bool get _isEditing => widget.initialLogEntry != null;

  @override
  void initState() {
    super.initState();

    final now = DateTime.now();
    _selectedTimestamp = widget.initialLogEntry?.timestamp ?? now;
    _selectedTime = TimeOfDay.fromDateTime(_selectedTimestamp);

    for (var type in VitalType.values) {
      final initialValue = widget.initialLogEntry?.readings[type]
          ?.toStringAsFixed(
        type == VitalType.temperature ? 1 : 0,
      ) ??
          '';
      _vitalControllers[type] = TextEditingController(text: initialValue);
    }
    _notesController =
        TextEditingController(text: widget.initialLogEntry?.notes ?? '');
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedTimestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      helpText: 'SELECT DATE OF READING',
    );

    if (pickedDate != null && mounted) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
        helpText: 'SELECT TIME OF READING',
      );
      if (pickedTime != null && mounted) {
        setState(() {
          _selectedTimestamp = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          _selectedTime = pickedTime;
        });
      }
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final Map<VitalType, double> readings = {};
      _vitalControllers.forEach((type, controller) {
        if (controller.text
            .trim()
            .isNotEmpty) {
          final value = double.tryParse(controller.text.trim());
          if (value != null) {
            readings[type] = value;
          }
        }
      });

      if (readings.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter at least one vital reading.'),
            backgroundColor: Colors.orangeAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
        return;
      }

      final newLogEntry = VitalLogEntry(
        id: widget.initialLogEntry?.id ?? const Uuid().v4(),
        timestamp: _selectedTimestamp,
        readings: readings,
        notes: _notesController.text
            .trim()
            .isNotEmpty ? _notesController.text.trim() : null,
      );

      Navigator.of(context).pop(newLogEntry);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please correct the errors in the form.'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _vitalControllers.values) {
      controller.dispose();
    }
    _notesController.dispose();
    super.dispose();
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
        title: Text(_isEditing ? 'Edit Vital Log' : 'Add New Vital Log'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt_outlined),
            onPressed: _submitForm,
            tooltip: 'Save Vitals',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: InkWell(
                  onTap: () => _pickDateTime(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Date & Time of Reading",
                                style: textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant)),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('E, MMM d, yyyy  h:mm a').format(
                                  _selectedTimestamp),
                              style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary),
                            ),
                          ],
                        ),
                        Icon(Icons.edit_calendar_outlined,
                            color: colorScheme.primary, size: 28),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Text("Vital Readings", style: textTheme.titleLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant)),
              const SizedBox(height: 8.0),

              ...VitalType.values.map((vitalType) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextFormField(
                    controller: _vitalControllers[vitalType],
                    decoration: InputDecoration(
                      labelText: '${vitalTypeToString(
                          vitalType)} (${getVitalUnit(vitalType)})',
                      hintText: 'Enter ${vitalTypeToString(
                          vitalType, short: true)} value',
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(_getIconForVital(vitalType),
                          color: colorScheme.primary),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                        decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
                    ],
                    validator: (value) {
                      if (value != null && value
                          .trim()
                          .isNotEmpty) {
                        final numVal = double.tryParse(value.trim());
                        if (numVal == null) {
                          return 'Invalid number';
                        }
                        if (vitalType == VitalType.heartRate &&
                            (numVal < 20 || numVal > 300)) {
                          return 'Value out of typical range';
                        }
                        if (vitalType == VitalType.temperature &&
                            (numVal < 30 || numVal > 45)) {
                          return 'Value out of typical range (°C)';
                        }
                      }
                      return null;
                    },
                  ),
                );
              }).toList(),

              const SizedBox(height: 16.0),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  hintText: 'Any observations, activity, or context...',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(
                      Icons.notes_outlined, color: colorScheme.primary),
                ),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitForm,
        icon: const Icon(Icons.check_circle_outline),
        label: Text(_isEditing ? 'Save Changes' : 'Log Vitals'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}