import 'package:flutter/material.dart';

// Enum to represent user roles - Admin is still here for internal logic if needed
// but won't be offered as a direct choice in this screen.
enum UserRole { admin, doctor, patient, familyMember, none }

// Helper function to convert enum to a displayable string
String roleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'Admin'; // Still useful for internal logic/display if an admin is viewing users
    case UserRole.doctor:
      return 'Doctor';
    case UserRole.patient:
      return 'screens';
    case UserRole.familyMember:
      return 'Family';
    case UserRole.none:
    default:
      return 'None'; // Or throw an error if a role should always be selected
  }
}

// Helper to get an icon for the role card
IconData getIconForRole(UserRole role) {
  switch (role) {
    case UserRole.doctor:
      return Icons.medical_services_outlined; // Example icon
    case UserRole.patient:
      return Icons.person_outline; // Example icon
    case UserRole.familyMember:
      return Icons.group_outlined; // Example icon
    default:
      return Icons.help_outline;
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Add more controllers if needed for specific roles (e.g., doctor's license, patient's DOB)

  UserRole _selectedRole = UserRole.none; // Default to no role selected
  bool _isLoading = false;

  // List of roles available for registration on this screen
  final List<UserRole> _availableRoles = [
    UserRole.doctor,
    UserRole.patient,
    UserRole.familyMember,
  ];

  void _register() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedRole == UserRole.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a user role by tapping a card.')),
        );
        return;
      }
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match.')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      String username = _usernameController.text;
      String email = _emailController.text;
      String password = _passwordController.text;
      String role = roleToString(_selectedRole); // Using the top-level function

      // --- TODO: Implement your actual registration logic here ---
      // This will likely involve an API call to your backend.
      // Send 'username', 'email', 'password', and 'role'.
      // Add other role-specific fields to the API call if necessary.
      //
      // Example:
      // try {
      //   final response = await http.post(
      //     Uri.parse('YOUR_REGISTER_API_ENDPOINT'),
      //     body: {
      //       'username': username,
      //       'email': email,
      //       'password': password,
      //       'role': role, // e.g., "Doctor", "screens"
      //       // if (_selectedRole == UserRole.doctor) 'licenseNumber': _licenseController.text,
      //     },
      //   );
      //
      //   if (response.statusCode == 201) {
      //     print('Registration successful: ${response.body}');
      //     if (mounted) {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text('Registration successful! Please login.')),
      //       );
      //       Navigator.pop(context); // Go back to login screen
      //     }
      //   } else {
      //     print('Registration failed: ${response.statusCode} - ${response.body}');
      //      if (mounted) {
      //       ScaffoldMessenger.of(context).showSnackBar(
      //         SnackBar(content: Text('Registration failed: ${response.body}')),
      //       );
      //     }
      //   }
      // } catch (e) {
      //   print('Error during registration: $e');
      //   if (mounted) {
      //     ScaffoldMessenger.of(context).showSnackBar(
      //       SnackBar(content: Text('An error occurred. Please try again.')),
      //     );
      //   }
      // }
      // --- End of placeholder registration logic ---

      // Simulate a network request for now
      await Future.delayed(const Duration(seconds: 2));
      print('Simulated Registration: User: $username, Email: $email, Role: $role');

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration attempt for $username as $role')),
        );
        // Optionally navigate back to login or to a success page
        Navigator.pop(context); // Go back to the previous screen (likely login)
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // Dispose other controllers if added
    super.dispose();
  }

  Widget _buildRoleCard(UserRole role) {
    bool isSelected = _selectedRole == role;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Card(
        elevation: isSelected ? 8.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                getIconForRole(role),
                size: 40.0,
                color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
              ),
              const SizedBox(height: 8.0),
              Text(
                roleToString(role), // Using the top-level function
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- TODO: Conditionally display additional fields based on _selectedRole ---
  Widget _buildRoleSpecificFields() {
    if (_selectedRole == UserRole.doctor) {
      // Example: Add a field for Medical License
      return Padding(
        padding: const EdgeInsets.only(top: 16.0), // Keep top padding for separation
        child: TextFormField(
          // controller: _medicalLicenseController, // You would need to define this controller
          decoration: const InputDecoration(
            labelText: 'Medical License Number (Optional)',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          // validator: (value) { // Add validation if required
          //   if (value == null || value.isEmpty) {
          //     return 'Please enter medical license number';
          //   }
          //   return null;
          // },
        ),
      );
    }
    // Add more conditions for other roles if they need specific fields
    // else if (_selectedRole == UserRole.patient) { ... }
    return const SizedBox.shrink(); // Return empty space if no specific fields
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text(
                'Create Your Account',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              Text(
                'Please select your role:',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16.0),
              GridView.count(
                crossAxisCount: _availableRoles.length > 2 ? 3 : _availableRoles.length, // Adjust for 2 or 3 cards
                shrinkWrap: true, // Important for GridView inside ListView
                physics: const NeverScrollableScrollPhysics(), // Disable GridView's own scrolling
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0, // Make cards somewhat square, adjust as needed
                children: _availableRoles.map((role) => _buildRoleCard(role)).toList(),
              ),
              const SizedBox(height: 24.0),

              // Common registration fields
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password (min. 6 characters)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock_reset_outlined),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              // No SizedBox here if _buildRoleSpecificFields adds its own top padding
              // const SizedBox(height: 16.0), // Original position

              // Conditionally display role-specific fields
              _buildRoleSpecificFields(), // This widget might add its own top padding

              // *** MODIFICATION FOR OVERFLOW FIX ***
              // Reduced SizedBox height before the ElevatedButton
              // Original was const SizedBox(height: 24.0) if _buildRoleSpecificFields was empty
              // If _buildRoleSpecificFields adds content, this SizedBox might be after it.
              // Let's assume _buildRoleSpecificFields could be empty and ensure space.
              const SizedBox(height: 16.0), // Adjusted from a potential 24.0 or from being absent

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('Register'),
              ),
              const SizedBox(height: 10.0), // Slightly reduced from 12.0
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the Login screen
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
