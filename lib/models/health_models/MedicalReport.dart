import 'package:flutter/foundation.dart';

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
