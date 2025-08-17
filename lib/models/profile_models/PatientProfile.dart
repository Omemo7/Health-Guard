
import 'BaseProfile.dart';

class PatientProfile extends BaseProfile {
  DateTime? dateOfBirth;
  String? address;
  String? emergencyContactName;
  String? emergencyContactPhone;

  PatientProfile({
    required String id,
    required String name,
    required String email,
    String? username,
    String? phoneNumber,
    String? profileImageUrl,
    this.dateOfBirth,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
  }) : super(
      id: id,
      name: name,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      userType: UserType.patient);
}
