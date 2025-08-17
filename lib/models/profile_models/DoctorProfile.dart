import 'BaseProfile.dart';

class DoctorProfile extends BaseProfile {
  String? specialization;
  String? clinicAddress;
  int? yearsOfExperience;
  List<String>? qualifications;

  DoctorProfile({
    required String id,
    required String name,
    required String email,
    String? username,
    String? phoneNumber,
    String? profileImageUrl,
    this.specialization,
    this.clinicAddress,
    this.yearsOfExperience,
    this.qualifications,
  }) : super(
      id: id,
      name: name,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      userType: UserType.doctor);
}
