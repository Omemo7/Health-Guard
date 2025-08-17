import 'package:flutter/material.dart';

class MedicationReminder {
  String id;
  String medicationName;
  String dosage;
  TimeOfDay time;
  List<DayOfWeek> days;
  bool isEnabled;
  String? notes;

  MedicationReminder({
    required this.id,
    required this.medicationName,
    required this.dosage,
    required this.time,
    required this.days,
    this.isEnabled = true,
    this.notes,
  });

  String get daysFormatted {
    if (days.isEmpty) return "No days selected";
    if (days.length == 7) return "Every Day";
    if (days.length == 2 && days.contains(DayOfWeek.saturday) &&
        days.contains(DayOfWeek.sunday)) return "Weekends";
    if (days.length == 5 && !days.contains(DayOfWeek.saturday) &&
        !days.contains(DayOfWeek.sunday)) return "Weekdays";
    return days.map((d) => dayOfWeekToString(d).substring(0, 3)).join(', ');
  }

  String timeFormatted(BuildContext context) {
    return time.format(context);
  }

  MedicationReminder copyWith({
    String? id,
    String? medicationName,
    String? dosage,
    TimeOfDay? time,
    List<DayOfWeek>? days,
    bool? isEnabled,
    String? notes,
    bool clearNotes = false,
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