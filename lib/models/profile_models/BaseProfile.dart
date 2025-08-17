class BaseProfile {
  String id;
  String name;
  String email;
  String? username;
  String? phoneNumber;
  String? profileImageUrl;
  UserType userType;

  BaseProfile({
    required this.id,
    required this.name,
    required this.email,
    this.username,
    this.phoneNumber,
    this.profileImageUrl,
    required this.userType,
  });
}
enum UserType { patient, doctor, familyMember,admin }