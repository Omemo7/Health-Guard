import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../models/user_models/FamilyMember.dart';

class AddEditFamilyMemberScreen extends StatefulWidget {
  final FamilyMember? initialMember;

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

  String? _profileImageUrl;

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
      initialDate: _selectedDateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 10)),
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
      _formKey.currentState!.save();

      final member = FamilyMember(
        id: widget.initialMember?.id ?? const Uuid().v4(),
        name: _nameController.text.trim(),
        relationship: _relationshipController.text.trim(),
        dateOfBirth: _selectedDateOfBirth,
        profileImageUrl: _profileImageUrl,
      );
      Navigator.of(context).pop(member);
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
                  if (value == null || value.trim().isEmpty) {
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
                  if (value == null || value.trim().isEmpty) {
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
                      style: Theme.of(context).textTheme.titleMedium,
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

              const SizedBox(height: 24.0),
              ElevatedButton.icon(
                icon: const Icon(Icons.save_alt_outlined),
                label: Text(_isEditing ? 'Save Changes' : 'Add Member',
                    style: const TextStyle(fontSize: 16)),
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}