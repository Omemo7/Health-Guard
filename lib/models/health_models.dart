import 'package:flutter/foundation.dart';


@immutable
class VitalDataPoint {
  final DateTime date;
  final double value;

  const VitalDataPoint(this.date, this.value);
}

@immutable
class MonthlyHealthSummary {
  final String month;
  final double overallScore;

  const MonthlyHealthSummary(this.month, this.overallScore);
}

enum VitalType {
  heartRate,
  bloodPressureSystolic,
  bloodPressureDiastolic,
  bloodOxygen,
  temperature
}

// Centralized string and unit functions
String vitalTypeToString(VitalType type,
    {bool short = false, bool includeUnit = false}) {
  String baseName;
  String unit = getVitalUnit(type);

  switch (type) {
    case VitalType.heartRate:
      baseName = short ? "HR" : "Heart Rate";
      break;
    case VitalType.bloodPressureSystolic:
      baseName = short ? "Systolic" : "Systolic BP";
      break;
    case VitalType.bloodPressureDiastolic:
      baseName = short ? "Diastolic" : "Diastolic BP";
      break;
    case VitalType.bloodOxygen:
      baseName = short ? "SpO2" : "Blood Oxygen";
      break;
    case VitalType.temperature:
      baseName = short ? "Temp" : "Temperature";
      break;
  }
  return includeUnit && unit.isNotEmpty ? "$baseName ($unit)" : baseName;
}

String getVitalUnit(VitalType type) {
  switch (type) {
    case VitalType.heartRate:
      return "bpm";
    case VitalType.bloodPressureSystolic:
    case VitalType.bloodPressureDiastolic:
      return "mmHg";
    case VitalType.bloodOxygen:
      return "%";
    case VitalType.temperature:
      return "°C";
    default:
      return "";
  }
}

@immutable
class VitalLogEntry {
  final String id;
  final DateTime timestamp;
  final Map<VitalType, double> readings;
  final String? notes;

  const VitalLogEntry({
    required this.id,
    required this.timestamp,
    required this.readings,
    this.notes,
  });

  VitalLogEntry copyWith({
    String? id,
    DateTime? timestamp,
    Map<VitalType, double>? readings,
    String? notes,
    bool clearNotes = false, // To allow explicitly clearing notes
  }) {
    return VitalLogEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      readings: readings ?? this.readings,
      notes: clearNotes ? null : (notes ?? this.notes),
    );
  }
}

// ... (keep existing models: VitalType, VitalDataPoint, MonthlyHealthSummary, VitalLogEntry)
 // Ensure this is imported

// ...

@immutable
class MedicalReport {
  final String id;
  final String patientId; // To associate the report with a specific patient
  final String doctorId; // ID of the doctor who created/edited the report
  final String title;
  final DateTime date;
  final String content; // Could be a summary, detailed notes, or markdown
  final String? reportType; // e.g., "Consultation Note", "Lab Result Analysis", "Discharge Summary"
  final String? attachmentUrl; // Optional: URL to a PDF or image file

  const MedicalReport({
    required this.id,
    required this.patientId,
    required this.doctorId,
    required this.title,
    required this.date,
    required this.content,
    this.reportType,
    this.attachmentUrl,
  });

  MedicalReport copyWith({
    String? id,
    String? patientId,
    String? doctorId,
    String? title,
    DateTime? date,
    String? content,
    String? reportType,
    String? attachmentUrl,
    bool clearAttachmentUrl = false,
  }) {
    return MedicalReport(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      doctorId: doctorId ?? this.doctorId,
      title: title ?? this.title,
      date: date ?? this.date,
      content: content ?? this.content,
      reportType: reportType ?? this.reportType,
      attachmentUrl: clearAttachmentUrl ? null : (attachmentUrl ??
          this.attachmentUrl),
    );
  }
}

