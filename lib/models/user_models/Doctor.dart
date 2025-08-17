class Doctor {
  final String id;
  String name;
  String specialty;
  String phoneNumber;
  String gender;
  String medicalLicenseNumber;
  bool isVerified;
  String email;
  String? profileImageUrl;

  Doctor({
    required this.phoneNumber,
    required this.gender,
    required this.medicalLicenseNumber,
    required this.id,
    required this.name,
    required this.specialty,
    required this.isVerified,
    required this.email,
    this.profileImageUrl,
  });
}