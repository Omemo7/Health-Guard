import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 


enum UserRole { admin, doctor, patient, familyMember, none }


enum Gender { none, male, female }


String roleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'Admin'; 
    case UserRole.doctor:
      return 'Doctor';
    case UserRole.patient:
      return 'Patient';
    case UserRole.familyMember:
      return 'Family';
    case UserRole.none:
    default:
      return 'None'; 
  }
}


IconData getIconForRole(UserRole role) {
  switch (role) {
    case UserRole.doctor:
      return Icons.medical_services; 
    case UserRole.patient:
      return Icons.person_outline; 
    case UserRole.familyMember:
      return Icons.group_outlined; 
    default:
      return Icons.help_outline;
  }
}


IconData getIconForGender(Gender gender) {
  switch (gender) {
    case Gender.male:
      return Icons.male;
    case Gender.female:
      return Icons.female;
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController(); 
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  

  UserRole _selectedRole = UserRole.none; 
  Gender _selectedGender = Gender.none; 
  DateTime? _selectedDate; 
  bool _isLoading = false;

  
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
      String dob = _dobController.text; 
      String gender = _selectedGender == Gender.male ? 'Male' : 'Female';
      String username = _usernameController.text;
      String password = _passwordController.text;
      String role = roleToString(_selectedRole);

      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      

      
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
        
        Navigator.pop(context); 
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
    
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900), 
      lastDate: DateTime.now(), 
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked); 
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

    return Expanded( 
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
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 12.0), 
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


  
  Widget _buildRoleSpecificFields() {
    if (_selectedRole == UserRole.doctor) {
      
      return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: TextFormField(
          
          decoration: const InputDecoration(
            labelText: 'Medical License Number',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.badge_outlined),
          ),
          
          
          
          
          
          
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
                  
                  if (!RegExp(r'^\+?[0-9]{7,15}$').hasMatch(value)) { 
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth', 
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
                  
                  
                  
                  
                  
                  
                  
                  
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Select Your Gender:',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.black54), 
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

              _buildRoleSpecificFields(), 

              const SizedBox(height: 24.0), 

              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  minimumSize: const Size(double.infinity, 50), 
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
              const SizedBox(height: 20.0), 
            ],
          ),
        ),
      ),
    );
  }
}
