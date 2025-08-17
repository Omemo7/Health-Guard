import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Import screens
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
  bool _obscurePassword = true;

  // Centralized role -> screen mapping
  final Map<String, Widget> _roleScreens = {
    // TODO: Update these to pass username and email
    "patient": const PatientScreen(), // Placeholder
    "doctor": const DoctorScreen(), // Needs update
    "family": const FamilyMemberScreen(), // Needs update
    "admin": const AdminScreen(), // Needs update
  };

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final username = _usernameController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();

    // TODO: Replace this with API/authentication service
    // For now, assume email is derivable or use a placeholder
    final email = "$username@example.com"; // Placeholder email

    bool loginSuccessful = password == "x" && _roleScreens.containsKey(username);

    await Future.delayed(const Duration(seconds: 1)); // simulate network

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (loginSuccessful) {
      // Update the roleScreens map or create the screen instance here with username and email
      Widget targetScreen;
      switch (username) {
        case "patient":
          targetScreen = PatientScreen();
          break;
        case "doctor":
          // Assuming DoctorScreen takes username and email
          // targetScreen = DoctorScreen(userName: username, userEmail: email);
          targetScreen = const DoctorScreen(); // Placeholder, update as needed
          break;
        case "family":
          // Assuming FamilyMemberScreen takes username and email
          // targetScreen = FamilyMemberScreen(userName: username, userEmail: email);
          targetScreen = const FamilyMemberScreen(); // Placeholder, update as needed
          break;
        case "admin":
          // Assuming AdminScreen takes username and email
          // targetScreen = AdminScreen(userName: username, userEmail: email);
          targetScreen = const AdminScreen(); // Placeholder, update as needed
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid user role for navigation')),
          );
          return;
      }
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => targetScreen),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid username or password')),
      );
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: theme.colorScheme.inversePrimary,
      ),
      body: Center( // Wrap Padding with Center
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 24),
                _buildUsernameField(),
                const SizedBox(height: 16),
                _buildPasswordField(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _navigateToRegister,
                    child: const Text("New user? Register"),
                  ),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("Login"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/health-insurance.svg',
          width: 40,
          height: 40,
          colorFilter: ColorFilter.mode(
            theme.colorScheme.primary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "Welcome!!",
          style: theme.textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username],
      decoration: const InputDecoration(
        labelText: "Username",
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) =>
      value == null || value.isEmpty ? "Please enter your username" : null,
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        labelText: "Password",
        border: const OutlineInputBorder(),
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(() => _obscurePassword = !_obscurePassword);
          },
        ),
      ),
      validator: (value) =>
      value == null || value.isEmpty ? "Please enter your password" : null,
    );
  }
}
