import 'package:health_guard_flutter/models/profile_models/BaseProfile.dart'; 

class AuthService {
  
  AuthService._internal();

  
  static final AuthService _instance = AuthService._internal();

  
  factory AuthService() {
    return _instance;
  }

  BaseProfile? _currentUserProfile;

  BaseProfile? get userProfile => _currentUserProfile;

  void loginUser(BaseProfile profile) {
    _currentUserProfile = profile;
  }

  void logoutUser() {
    _currentUserProfile = null;

  }
}
