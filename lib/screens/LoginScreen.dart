import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; 
import 'package:health_guard_flutter/services/AuthService.dart';
import 'package:health_guard_flutter/models/profile_models/BaseProfile.dart';
import 'package:health_guard_flutter/models/profile_models/DoctorProfile.dart';
import 'package:health_guard_flutter/models/profile_models/PatientProfile.dart';
import 'package:health_guard_flutter/models/profile_models/FamilyMemberProfile.dart';
import 'package:health_guard_flutter/models/profile_models/AdminProfile.dart';


import 'Doctor/DoctorScreen.dart';
import 'Family member/FamilyMemberScreen.dart';
import 'Admin/AdminScreen.dart';
import 'Patient/PatientScreen.dart';
import 'RegisterScreen.dart'; 

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final String inputUsername = _usernameController.text.trim();
    final String password = _passwordController.text.trim();
    
    final String email = "${inputUsername.toLowerCase()}@example.com"; 

    
    final Set<String> validRoles = {"patient", "doctor", "family", "admin"};
    
    bool loginSuccessful = password == "x" && validRoles.contains(inputUsername.toLowerCase());

    await Future.delayed(const Duration(seconds: 1)); 

    if (!mounted) {
      setState(() => _isLoading = false);
      return;
    }

    if (loginSuccessful) {
      UserType currentUserType;
      String currentRole = inputUsername.toLowerCase();
      BaseProfile userProfileToSave; 

      
      
      String profileId = UniqueKey().toString(); 

      switch (currentRole) {
        case "patient":
          currentUserType = UserType.patient;
          userProfileToSave = PatientProfile(
            id: profileId,
            name: inputUsername, 
            email: email,       
            username: inputUsername, 

          );
          break;
        case "doctor":
          currentUserType = UserType.doctor;
          userProfileToSave = DoctorProfile(
            id: profileId,
            name: "Dr. $inputUsername", 
            email: email,
            username: inputUsername,
            specialization: "General Medicine", 
            yearsOfExperience: 5,             
            
          );
          break;
        case "family":
          currentUserType = UserType.familyMember;
          userProfileToSave = FamilyMemberProfile(
            id: profileId,
            name: inputUsername, 
            email: email,
            username: inputUsername,
            
            
            
          );
          break;
        case "admin":
          currentUserType = UserType.admin;
          userProfileToSave = AdminProfile(
            id: profileId,
            name: "Admin $inputUsername", 
            email: email,
            username: inputUsername,
            
            
            
          );
          break;
        default:
          setState(() => _isLoading = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid role for UserType mapping')),
            );
          }
          return;
      }

      AuthService().loginUser(userProfileToSave);

      Widget targetScreen;
      switch (userProfileToSave.userType) {
        case UserType.patient:
          targetScreen = const PatientScreen();
          break;
        case UserType.doctor:
          targetScreen = const DoctorScreen();
          break;
        case UserType.familyMember:
          targetScreen = const FamilyMemberScreen();
          break;
        case UserType.admin:
          targetScreen = const AdminScreen();
          break;
        
      }
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => targetScreen),
        );
      }
    } else {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid username or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Center( 
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                
                SvgPicture.asset(
                  'assets/icons/health-insurance.svg',
                  height: 100, 
                  
                  colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.primary, BlendMode.srcIn), 
                ),
                const SizedBox(height: 24.0),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username/Role (patient, doctor, family, admin)',
                    hintText: 'Enter your username or role',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your username or role';
                    }
                    
                    final Set<String> validRoles = {"patient", "doctor", "family", "admin"};
                    if (!validRoles.contains(value.trim().toLowerCase())) {
                       
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password (use "x")',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value != "x") { 
                       
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          textStyle: const TextStyle(fontSize: 16.0),
                        ),
                        onPressed: _login,
                        child: const Text('Login'),
                      ),
                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: const Text('Don\'t have an account? Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
