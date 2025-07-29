import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:uuid/uuid.dart'; // For new IDs

import '../models/user_models.dart'; // Assuming FamilyMember model is here

class AddEditFamilyMemberScreen extends StatefulWidget {
  final FamilyMember? initialMember; // Null if adding, populated if editing

  const AddEditFamilyMemberScreen({super.key, this.initialMember});

  @override
  State<AddEditFamilyMemberScreen> createState() =>
      _AddEditFamilyMemberScreenState();
}

class _AddEditFamilyMemberScreenState extends State<AddEditFamilyMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _relationshipController;
  DateTime? _selectedDateOfBirth;

  // In a real app, image picking logic would be here
  String? _profileImageUrl; // For simplicity, we'll just use a text field or keep existing

  bool get _isEditing => widget.initialMember != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialMember?.name);
    _relationshipController =
        TextEditingController(text: widget.initialMember?.relationship);
    _selectedDateOfBirth = widget.initialMember?.dateOfBirth;
    _profileImageUrl = widget.initialMember?.profileImageUrl;
  }

  Future<void> _pickDateOfBirth(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateOfBirth ??
          DateTime.now().subtract(const Duration(days: 365 * 10)),
      // Default to 10 years ago or selected
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select Date of Birth',
    );
    if (picked != null && picked != _selectedDateOfBirth) {
      setState(() {
        _selectedDateOfBirth = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!
          .save(); // Not strictly needed if using controllers directly

      final member = FamilyMember(
        id: widget.initialMember?.id ?? const Uuid().v4(),
        // Keep ID if editing, new if adding
        name: _nameController.text.trim(),
        relationship: _relationshipController.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        profileImageUrl: _profileImageUrl, // Handle image update logic if implementing
      );
      Navigator.of(context).pop(member); // Return the added/edited member
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Family Member' : 'Add Family Member'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_outlined),
            onPressed: _submitForm,
            tooltip: 'Save',
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- TODO: Add image picker widget here ---
              if (_isEditing && _profileImageUrl != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(_profileImageUrl!),
                      child: _profileImageUrl == null ? const Icon(
                          Icons.person, size: 50) : null,
                    ),
                  ),
                ),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter member\'s full name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return 'Please enter a name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _relationshipController,
                decoration: const InputDecoration(
                  labelText: 'Relationship',
                  hintText: 'e.g., Spouse, Child, Parent',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people_alt_outlined),
                ),
                validator: (value) {
                  if (value == null || value
                      .trim()
                      .isEmpty) {
                    return 'Please enter the relationship.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDateOfBirth == null
                          ? 'Date of Birth (Optional)'
                          : 'DOB: ${DateFormat.yMd().format(
                          _selectedDateOfBirth!)}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.calendar_month_outlined),
                    label: Text(_selectedDateOfBirth == null
                        ? 'Select Date'
                        : 'Change Date'),
                    onPressed: () => _pickDateOfBirth(context),
                  ),
                ],
              ),
              const SizedBox(height: 12.0),
              const Divider(),


              // --- TODO: Add more fields as needed (e.g., gender, specific health conditions short summary) ---
              // For simplicity, we are keeping it basic.

              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined),
                label: Text(_isEditing ? 'Save Changes' : 'Add Member',
                    style: const TextStyle(fontSize: 16)),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  // backgroundColor: Theme.of(context).colorScheme.primary,
                  // foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}