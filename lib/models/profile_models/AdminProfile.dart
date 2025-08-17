
import 'BaseProfile.dart';

class AdminProfile extends BaseProfile {
  AdminProfile({
    required String id,
    required String name,
    required String email,
    String? username,
    String? phoneNumber,
    String? profileImageUrl,
  }) : super(
      id: id,
      name: name,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      userType: UserType.admin);
}
