

class MedicalReport {
  final String id;
  final String patientId;
  final String doctorId;
  final String title;
  final DateTime date;
  final String content;
  final String? reportType;
  final String? attachmentUrl;

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


}
