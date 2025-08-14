import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import for date formatting

// Enum to represent user roles - Admin is still here for internal logic if needed
// but won't be offered as a direct choice in this screen.
enum UserRole { admin, doctor, patient, familyMember, none }

// Enum for Gender
enum Gender { none, male, female }

// Helper function to convert enum to a displayable string
String roleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'Admin'; // Still useful for internal logic/display if an admin is viewing users
    case UserRole.doctor:
      return 'Doctor';
    case UserRole.patient:
      return 'Patient';
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
      return Icons.medical_services; // Example icon
    case UserRole.patient:
      return Icons.person_outline; // Example icon
    case UserRole.familyMember:
      return Icons.group_outlined; // Example icon
    default:
      return Icons.help_outline;
  }
}

// Helper to get an icon for the gender card
IconData getIconForGender(Gender gender) {
  switch (gender) {
    case Gender.male:
      return Icons.male;
    case Gender.female:
      return Icons.female;
    default:
      return Icons.help_outline; // Should not happen if one is selected
  }
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController(); // For displaying the selected date
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // Add more controllers if needed for specific roles (e.g., doctor's license, patient's DOB)

  UserRole _selectedRole = UserRole.none; // Default to no role selected
  Gender _selectedGender = Gender.none; // Default to no gender selected
  DateTime? _selectedDate; // To store the selected date from the picker
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
      if (_selectedGender == Gender.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your gender.')),
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

      String name = _nameController.text;
      String email = _emailController.text;
      String phone = _phoneController.text;
      String dob = _dobController.text; // Or format _selectedDate as needed for backend
      String gender = _selectedGender == Gender.male ? 'Male' : 'Female';
      String username = _usernameController.text;
      String password = _passwordController.text;
      String role = roleToString(_selectedRole);

      // --- TODO: Implement your actual registration logic here ---
      // This will likely involve an API call to your backend.
      // Send 'name', 'email', 'phone', 'dob', 'gender', 'username', 'password', and 'role'.
      //
      // Example:
      // try {
      //   final response = await http.post(
      //     Uri.parse('YOUR_REGISTER_API_ENDPOINT'),
      //     body: {
      //       'name': name,
      //       'email': email,
      //       'phone': phone,
      //       'dateOfBirth': _selectedDate != null ? DateFormat('yyyy-MM-dd').format(_selectedDate!) : '', // Send formatted date
      //       'gender': gender,
      //       'username': username,
      //       'password': password,
      //       'role': role,
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
      //         SnackBar(content: Text('Registration failed: Check details or try again.')), // More generic error
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
      print(
          'Simulated Registration: Name: $name, Email: $email, Phone: $phone, DOB: $dob, Gender: $gender, User: $username, Role: $role');

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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please correct the errors in the form.')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    // Dispose other controllers if added
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900), // Adjust as needed
      lastDate: DateTime.now(), // User cannot select a future date
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked); // Using intl for formatting
      });
    }
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
                roleToString(role),
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

  Widget _buildGenderCard(Gender gender) {
    bool isSelected = _selectedGender == gender;
    String genderText = gender == Gender.male ? 'Male' : 'Female';

    return Expanded( // Use Expanded so cards take available space in a Row
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedGender = gender;
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
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0), // Adjusted padding for smaller cards
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  getIconForGender(gender),
                  size: 30.0,
                  color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade600,
                ),
                const SizedBox(height: 8.0),
                Text(
                  genderText,
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
      ),
    );
  }


  // --- TODO: Conditionally display additional fields based on _selectedRole ---
  Widget _buildRoleSpecificFields() {
    if (_selectedRole == UserRole.doctor) {
      // Example: Add a field for Medical License
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: TextFormField(
          // controller: _medicalLicenseController, // You would need to define this controller
          decoration: const InputDecoration(
            labelText: 'Medical License Number',
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
    return const SizedBox.shrink();
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
                crossAxisCount: _availableRoles.length > 2 ? 3 : _availableRoles.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 1.0,
                children: _availableRoles.map((role) => _buildRoleCard(role)).toList(),
              ),
              const SizedBox(height: 24.0),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  if (value.length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Email Field
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

              // Phone Field
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  // Basic phone number validation (adapt as needed)
                  if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) { // Loosened a bit for more general use
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Date of Birth Field
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth', // Removed YYYY-MM-DD as format is now handled by picker
                  hintText: 'Select your date of birth',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
                  suffixIcon: _dobController.text.isNotEmpty ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _selectedDate = null;
                        _dobController.clear();
                      });
                    },
                  ) : null,
                ),
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select your date of birth';
                  }
                  // Optional: Age validation (e.g., must be 18+)
                  // if (_selectedDate != null) {
                  //   final today = DateTime.now();
                  //   final age = today.year - _selectedDate!.year -
                  //       ((today.month > _selectedDate!.month || (today.month == _selectedDate!.month && today.day >= _selectedDate!.day)) ? 0 : 1);
                  //   if (age < 18) {
                  //     return 'You must be at least 18 years old';
                  //   }
                  // }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Gender Selection
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Select Your Gender:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black54), // Subtler title
                ),
              ),
              Row(
                children: <Widget>[
                  _buildGenderCard(Gender.male),
                  const SizedBox(width: 10),
                  _buildGenderCard(Gender.female),
                ],
              ),
              const SizedBox(height: 24.0),


              // Username Field
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_pin_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  if (value.length < 4) {
                    return 'Username must be at least 4 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Password Field
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Min. 6 characters',
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

              // Confirm Password Field
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

              _buildRoleSpecificFields(), // Conditionally display role-specific fields

              const SizedBox(height: 24.0), // Space before button

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  minimumSize: const Size(double.infinity, 50), // Make button wider
                ),
                child: const Text('Register'),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Already have an account? Login'),
              ),
              const SizedBox(height: 20.0), // Padding at the bottom for better scrollability
            ],
          ),
        ),
      ),
    );
  }
}
