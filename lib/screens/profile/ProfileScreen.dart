import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../../models/profile_models/BaseProfile.dart';
import '../../models/profile_models/DoctorProfile.dart';
import '../../models/profile_models/FamilyMemberProfile.dart';
import '../../models/profile_models/PatientProfile.dart';
import '../LoginScreen.dart';





class ProfileScreen extends StatefulWidget {
  final BaseProfile userProfile;

  const ProfileScreen({super.key, required this.userProfile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  

  late TextEditingController _addressController;
  late TextEditingController _emergencyContactNameController;
  late TextEditingController _emergencyContactPhoneController;
  DateTime? _selectedDateOfBirth;

  late TextEditingController _specializationController;
  late TextEditingController _clinicAddressController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _qualificationsController;

  

  
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;


  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.userProfile is PatientProfile) {
      _selectedDateOfBirth = (widget.userProfile as PatientProfile).dateOfBirth;
    }
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.userProfile.name);
    _emailController = TextEditingController(text: widget.userProfile.email);
    _phoneController = TextEditingController(text: widget.userProfile.phoneNumber ?? "");
    

    if (widget.userProfile is PatientProfile) {
      final patientProfile = widget.userProfile as PatientProfile;
      _addressController = TextEditingController(text: patientProfile.address ?? "");
      _emergencyContactNameController = TextEditingController(text: patientProfile.emergencyContactName ?? "");
      _emergencyContactPhoneController = TextEditingController(text: patientProfile.emergencyContactPhone ?? "");
    } else if (widget.userProfile is DoctorProfile) {
      final doctorProfile = widget.userProfile as DoctorProfile;
      _specializationController = TextEditingController(text: doctorProfile.specialization ?? "");
      _clinicAddressController = TextEditingController(text: doctorProfile.clinicAddress ?? "");
      _yearsOfExperienceController = TextEditingController(text: doctorProfile.yearsOfExperience?.toString() ?? "");
      _qualificationsController = TextEditingController(text: doctorProfile.qualifications?.join(', ') ?? "");
    } else if (widget.userProfile is FamilyMemberProfile) {
      
      
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    if (widget.userProfile is PatientProfile) {
      _addressController.dispose();
      _emergencyContactNameController.dispose();
      _emergencyContactPhoneController.dispose();
    } else if (widget.userProfile is DoctorProfile) {
      _specializationController.dispose();
      _clinicAddressController.dispose();
      _yearsOfExperienceController.dispose();
      _qualificationsController.dispose();
    } else if (widget.userProfile is FamilyMemberProfile) {
      
    }
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _initializeControllers();
         if (widget.userProfile is PatientProfile) {
            _selectedDateOfBirth = (widget.userProfile as PatientProfile).dateOfBirth;
         }
      }
    });
  }

  void _saveProfile() {
    setState(() {
      widget.userProfile.name = _nameController.text;
      widget.userProfile.email = _emailController.text;
      widget.userProfile.phoneNumber = _phoneController.text.isNotEmpty ? _phoneController.text : null;
      

      if (widget.userProfile is PatientProfile) {
        final patientProfile = widget.userProfile as PatientProfile;
        patientProfile.address = _addressController.text.isNotEmpty ? _addressController.text : null;
        patientProfile.dateOfBirth = _selectedDateOfBirth;
        patientProfile.emergencyContactName = _emergencyContactNameController.text.isNotEmpty ? _emergencyContactNameController.text : null;
        patientProfile.emergencyContactPhone = _emergencyContactPhoneController.text.isNotEmpty ? _emergencyContactPhoneController.text : null;
      } else if (widget.userProfile is DoctorProfile) {
        final doctorProfile = widget.userProfile as DoctorProfile;
        doctorProfile.specialization = _specializationController.text.isNotEmpty ? _specializationController.text : null;
        doctorProfile.clinicAddress = _clinicAddressController.text.isNotEmpty ? _clinicAddressController.text : null;
        doctorProfile.yearsOfExperience = int.tryParse(_yearsOfExperienceController.text);
        doctorProfile.qualifications = _qualificationsController.text.split(',').map((q) => q.trim()).where((q) => q.isNotEmpty).toList();
      } else if (widget.userProfile is FamilyMemberProfile) {
        
        
      }
      _isEditing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Profile updated successfully! (Simulated)"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  void _showChangePasswordDialog() {
    _oldPasswordController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Password"),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _oldPasswordController,
                    decoration: const InputDecoration(labelText: 'Old Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your old password';
                      }
                      
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _newPasswordController,
                    decoration: const InputDecoration(labelText: 'New Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(labelText: 'Confirm New Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your new password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Change"),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  
                  Navigator.of(context).pop(); 
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Password changed successfully! (Simulated)"),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      margin: const EdgeInsets.all(10),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildProfileImage() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: widget.userProfile.profileImageUrl != null && widget.userProfile.profileImageUrl!.isNotEmpty
              ? NetworkImage(widget.userProfile.profileImageUrl!)
              : null,
          child: widget.userProfile.profileImageUrl == null || widget.userProfile.profileImageUrl!.isEmpty
              ? Icon(Icons.person, size: 60, color: Theme.of(context).colorScheme.onPrimaryContainer)
              : null,
        ),
        if (_isEditing)
          TextButton.icon(
            icon: Icon(Icons.camera_alt_outlined, size: 18),
            label: Text("Change Photo", style: Theme.of(context).textTheme.labelSmall),
            onPressed: () {
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Image picker not implemented yet.")),
              );
            },
          ),
      ],
    );
  }

  Widget _buildTextField(
    String label, 
    TextEditingController controller, {
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon) : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          filled: !enabled,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        obscureText: obscureText,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: enabled ? null : Colors.grey[700]
        ),
      ),
    );
  }

 Widget _buildDisplayField(String label, String? value, {IconData? icon}) {
    return ListTile(
      leading: icon != null ? Icon(icon, color: Theme.of(context).colorScheme.primary) : null,
      title: Text(label, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[600])),
      subtitle: Text(
        value != null && value.isNotEmpty ? value : "Not set",
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
      ),
      contentPadding: icon != null ? EdgeInsets.zero : const EdgeInsets.only(left: 16.0), 
    );
  }

  Widget _buildDatePickerField(String label, DateTime? selectedDate, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              selectedDate != null
                  ? DateFormat.yMMMd().format(selectedDate)
                  : 'Select Date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            IconButton(
              icon: Icon(Icons.edit_calendar_outlined, color: Theme.of(context).colorScheme.primary),
              onPressed: () => _selectDate(context),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionCard(String title, List<Widget> children, {EdgeInsets? margin}) {
    
    
    
    
    return Card(
      elevation: 2.0,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCommonFields(BuildContext context) {
    return [
      _isEditing
          ? _buildTextField("Name", _nameController, icon: Icons.person_outline)
          : _buildDisplayField("Name", widget.userProfile.name, icon: Icons.person_outline),
      _buildDisplayField("Username", widget.userProfile.username, icon: Icons.account_circle_outlined), 
      _isEditing
          ? _buildTextField("Email", _emailController, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress)
          : _buildDisplayField("Email", widget.userProfile.email, icon: Icons.email_outlined),
      _isEditing
          ? _buildTextField("Phone Number", _phoneController, icon: Icons.phone_outlined, keyboardType: TextInputType.phone)
          : _buildDisplayField("Phone Number", widget.userProfile.phoneNumber, icon: Icons.phone_outlined),
    ];
  }

  List<Widget> _buildPatientFields(BuildContext context) {
    final patientProfile = widget.userProfile as PatientProfile;
    return [
      _isEditing
          ? _buildDatePickerField("Date of Birth", _selectedDateOfBirth, context)
          : _buildDisplayField("Date of Birth", patientProfile.dateOfBirth != null ? DateFormat.yMMMd().format(patientProfile.dateOfBirth!) : null, icon: Icons.cake_outlined),
      _isEditing
          ? _buildTextField("Address", _addressController, icon: Icons.location_on_outlined, maxLines: 2)
          : _buildDisplayField("Address", patientProfile.address, icon: Icons.location_on_outlined),
      _isEditing
          ? _buildTextField("Emergency Contact Name", _emergencyContactNameController, icon: Icons.contact_emergency_outlined)
          : _buildDisplayField("Emergency Contact Name", patientProfile.emergencyContactName, icon: Icons.contact_emergency_outlined),
      _isEditing
          ? _buildTextField("Emergency Contact Phone", _emergencyContactPhoneController, icon: Icons.phone_forwarded_outlined, keyboardType: TextInputType.phone)
          : _buildDisplayField("Emergency Contact Phone", patientProfile.emergencyContactPhone, icon: Icons.phone_forwarded_outlined),
    ];
  }

  List<Widget> _buildDoctorFields(BuildContext context) {
    final doctorProfile = widget.userProfile as DoctorProfile;
    return [
      _isEditing
          ? _buildTextField("Specialization", _specializationController, icon: Icons.medical_services_outlined)
          : _buildDisplayField("Specialization", doctorProfile.specialization, icon: Icons.medical_services_outlined),
      _isEditing
          ? _buildTextField("Clinic Address", _clinicAddressController, icon: Icons.business_outlined, maxLines: 2)
          : _buildDisplayField("Clinic Address", doctorProfile.clinicAddress, icon: Icons.business_outlined),
      _isEditing
          ? _buildTextField("Years of Experience", _yearsOfExperienceController, icon: Icons.work_history_outlined, keyboardType: TextInputType.number)
          : _buildDisplayField("Years of Experience", doctorProfile.yearsOfExperience?.toString(), icon: Icons.work_history_outlined),
       _isEditing
          ? _buildTextField("Qualifications (comma-separated)", _qualificationsController, icon: Icons.school_outlined, maxLines: 2)
          : _buildDisplayField("Qualifications", doctorProfile.qualifications?.join(', '), icon: Icons.school_outlined),
    ];
  }

  List<Widget> _buildFamilyMemberFields(BuildContext context) {
    
    return []; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? "Edit Profile" : "View Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 3.0,
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.cancel_outlined),
              tooltip: "Cancel",
              onPressed: _toggleEdit,
            ),
          IconButton(
            icon: Icon(_isEditing ? Icons.save_alt_outlined : Icons.edit_outlined),
            tooltip: _isEditing ? "Save Profile" : "Edit Profile",
            onPressed: _isEditing ? _saveProfile : _toggleEdit,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(child: _buildProfileImage()),
            const SizedBox(height: 16),
            
            _buildSectionCard("Basic Information", _buildCommonFields(context)),
            
            if (widget.userProfile.userType == UserType.patient)
              _buildSectionCard("Patient Details", _buildPatientFields(context)),
            
            if (widget.userProfile.userType == UserType.doctor)
              _buildSectionCard("Doctor Details", _buildDoctorFields(context)),
            
            const SizedBox(height: 16),
            if (!_isEditing) 
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.lock_outline),
                  label: const Text("Change Password"),
                  onPressed: _showChangePasswordDialog,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).colorScheme.primary),
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    textStyle: Theme.of(context).textTheme.labelLarge,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ),

            const SizedBox(height: 8), 
            if (_isEditing)
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined),
                label: const Text("Save Changes"),
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
              )
            else 
              TextButton.icon(
                icon: Icon(Icons.logout, color: Colors.red.shade700),
                label: Text("Logout", style: TextStyle(color: Colors.red.shade700)),
                onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (Route<dynamic> route) => false, 
                    );
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              )
          ],
        ),
      ),
    );
  }
}
