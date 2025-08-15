import 'package:flutter/material.dart'; // For TimeOfDay

class MedicationReminder {
  String id; // Unique ID, can be generated (e.g., UUID) or from backend
  String medicationName;
  String dosage; // e.g., "1 tablet", "10mg", "5ml"
  TimeOfDay time; // Time for the reminder
  List<DayOfWeek> days; // Which days of the week
  bool isEnabled;
  String? notes; // Optional notes

  MedicationReminder({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.time,
    required this.days,
    this.isEnabled = true,
    this.notes,
  });

  // Helper to get a string representation of days
  String get daysFormatted {
    if (days.isEmpty) return "No days selected";
    if (days.length == 7) return "Every Day";
    if (days.length == 2 && days.contains(DayOfWeek.saturday) &&
        days.contains(DayOfWeek.sunday)) return "Weekends";
    if (days.length == 5 && !days.contains(DayOfWeek.saturday) &&
        !days.contains(DayOfWeek.sunday)) return "Weekdays";
    return days.map((d) => dayOfWeekToString(d).substring(0, 3)).join(', ');
  }

  // Helper to get a string for time
  String timeFormatted(BuildContext context) {
    return time.format(context);
  }

  // For copying and updating (immutability pattern if preferred)
  MedicationReminder copyWith({
    String? id,
    String? medicationName,
    String? dosage,
    TimeOfDay? time,
    List<DayOfWeek>? days,
    bool? isEnabled,
    String? notes,
    bool clearNotes = false, // Special flag to explicitly clear notes
  }) {
    return MedicationReminder(
      id: id ?? this.id,
      medicationName: medicationName ?? this.medicationName,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      days: days ?? this.days,
      isEnabled: isEnabled ?? this.isEnabled,
      notes: clearNotes ? null : (notes ?? this.notes),
    );
  }
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

String dayOfWeekToString(DayOfWeek day) {
  switch (day) {
    case DayOfWeek.monday:
      return "Monday";
    case DayOfWeek.tuesday:
      return "Tuesday";
    case DayOfWeek.wednesday:
      return "Wednesday";
    case DayOfWeek.thursday:
      return "Thursday";
    case DayOfWeek.friday:
      return "Friday";
    case DayOfWeek.saturday:
      return "Saturday";
    case DayOfWeek.sunday:
      return "Sunday";
  }
}