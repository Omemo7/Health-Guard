// In your new.dart (or login_screen.dart) file:
import 'package:flutter/material.dart';
import 'package:health_guard_flutter/screens/Doctor/DoctorScreen.dart';
import 'package:health_guard_flutter/screens/Family%20member/FamilyMemberScreen.dart';
// Import the PatientScreen
import 'Patient/PatientScreen.dart'; // Make sure this path is correct
// If you have a RegisterScreen, keep that import as well
import 'RegisterScreen.dart';
import 'package:flutter_svg/flutter_svg.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;


  void _patientLogin(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const PatientScreen(
          // If your PatientScreen expects patient data, pass it here:
          // patientData: authenticatedPatientDataObject,
        ),
      ),
    );
  }

  void _doctorLogin(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const DoctorScreen(

        ),
      ),
    );
  }

  void _familyMemberLogin(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const FamilyMemberScreen(

        ),
      ),
    );
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String username = _usernameController.text;
      String password = _passwordController.text;
      String LoginType= "Patient";

      // --- TODO: Implement your ACTUAL authentication logic here ---
      // This will involve checking credentials against a backend, database, etc.
      // For now, we'll simulate a successful login for a "patient" user type.
      // In a real app, you'd also determine the user's role (patient, doctor, etc.)
      // from the authentication response.

      bool loginSuccessful = false;
      // Example: Simulate successful login if username is "patient"
      if (username.toLowerCase() == "patient" && password == "x") { // Replace with actual logic
        loginSuccessful = true;
        LoginType = "Patient";

      }else if (username.toLowerCase() == "doctor" && password == "x") { // Replace with actual logic
        loginSuccessful = true;
        LoginType = "Doctor";

      }else if (username.toLowerCase() == "family" && password == "x") { // Replace with actual logic
        loginSuccessful = true;
        LoginType = "Family";
      }
      else {
        print("Simulated Login Failed for: $username");
      }
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      // --- End of TODO section ---

      setState(() {
        _isLoading = false;
      });

      if (loginSuccessful) {
        // Navigate to PatientScreen on successful login
        // Use pushReplacement so the user can't press "back" to return to the login screen
        switch(LoginType){
          case "Patient":_patientLogin();break;
          case "Doctor":_doctorLogin();break;
          case "Family":_familyMemberLogin();break;

        }

      } else {
        // Show an error message if login failed
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Login failed. Please check your credentials.')),
          );
        }
      }
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/health-insurance.svg',
                    width: 40.0,
                    height: 40.0,
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn,
                    ),
                  ),
                  const SizedBox(width: 8.0), // Spacing between icon and text
                  Text(
                    'Welcome!!',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _navigateToRegister,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'New user? Register',
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
