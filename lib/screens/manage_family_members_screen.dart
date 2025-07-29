import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/user_models.dart'; // Assuming FamilyMember and _dummyFamilyMembers are here
import 'add_edit_family_member_screen.dart';


final List<FamilyMember> _dummyFamilyMembers = [
  FamilyMember(
    id: const Uuid().v4(),
    name: "Laura Smith",
    relationship: "Spouse",
    dateOfBirth: DateTime(1988, 7, 20),
    profileImageUrl: 'https://i.pravatar.cc/150?u=laura_smith_family', // Placeholder image
  ),
  FamilyMember(
    id: const Uuid().v4(),
    name: "Michael Smith Jr.",
    relationship: "Child",
    dateOfBirth: DateTime(2015, 3, 10),
    // profileImageUrl: null, // No image for this one
  ),
  FamilyMember(
    id: const Uuid().v4(),
    name: "Sarah Connor",
    relationship: "Mother",
    dateOfBirth: DateTime(1965, 11, 5),
    profileImageUrl: 'https://i.pravatar.cc/150?u=sarah_connor_family',
  ),
];

class ManageFamilyMembersScreen extends StatefulWidget {
  const ManageFamilyMembersScreen({super.key});

  @override
  State<ManageFamilyMembersScreen> createState() =>
      _ManageFamilyMembersScreenState();
}

class _ManageFamilyMembersScreenState extends State<ManageFamilyMembersScreen> {
  // In a real app, this list would be fetched from a service/backend
  // and managed via a state management solution.
  List<FamilyMember> _familyMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFamilyMembers();
  }

  // --- TODO: Replace with actual data fetching logic ---
  Future<void> _loadFamilyMembers() async {
    if (mounted) setState(() => _isLoading = true);
    await Future.delayed(
        const Duration(milliseconds: 600)); // Simulate API call

    // For now, use the dummy list. In a real app, fetch from your persistence layer.
    // If you were using a global list like _dummyFamilyMembers, you might copy it:
    // _familyMembers = List.from(_dummyFamilyMembers);
    // However, it's better if this screen manages its own copy or gets it from a state provider.
    // For this example, let's initialize it if it's the first load to simulate.
    if (_familyMembers.isEmpty &&
        _dummyFamilyMembers.isNotEmpty) { // Only load dummy if empty
      _familyMembers = List.from(_dummyFamilyMembers);
    }


    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToAddEditScreen({FamilyMember? member}) async {
    final result = await Navigator.push<FamilyMember>(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditFamilyMemberScreen(initialMember: member),
      ),
    );

    if (result != null && mounted) {
      // --- TODO: Persist this change to your backend/local storage ---
      setState(() {
        if (member != null) { // Editing existing
          final index = _familyMembers.indexWhere((m) => m.id == result.id);
          if (index != -1) {
            _familyMembers[index] = result;
          }
        } else { // Adding new
          _familyMembers.add(result);
          // Add to dummy list as well if you want it to persist across hot reloads FOR DEMO
          _dummyFamilyMembers.add(result);
        }
        _familyMembers.sort((a, b) =>
            a.name.toLowerCase().compareTo(
                b.name.toLowerCase())); // Keep sorted
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Family member ${member != null
            ? "updated"
            : "added"} successfully.')),
      );
    }
  }

  void _confirmDeleteMember(FamilyMember member) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete ${member.name}?'),
          content: Text(
              'Are you sure you want to remove ${member
                  .name} from your family members? This action cannot be undone.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteMember(member);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteMember(FamilyMember member) {
    // --- TODO: Persist this change to your backend/local storage ---
    if (mounted) {
      setState(() {
        _familyMembers.removeWhere((m) => m.id == member.id);
        // Remove from dummy list as well FOR DEMO
        _dummyFamilyMembers.removeWhere((m) => m.id == member.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${member.name} removed.'),
            backgroundColor: Colors.orange),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Family Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _loadFamilyMembers, // Allows manual refresh
            tooltip: "Refresh List",
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _familyMembers.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No family members added yet.',
                style: textTheme.titleLarge?.copyWith(color: Colors.grey[700])),
            const SizedBox(height: 8),
            Text('Tap the "+" button to add your first family member.',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_circle_outline),
              label: const Text('Add First Member'),
              onPressed: () => _navigateToAddEditScreen(),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: _familyMembers.length,
        itemBuilder: (context, index) {
          final member = _familyMembers[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme
                    .of(context)
                    .colorScheme
                    .secondaryContainer,
                foregroundColor: Theme
                    .of(context)
                    .colorScheme
                    .onSecondaryContainer,
                backgroundImage: member.profileImageUrl != null
                    ? NetworkImage(member.profileImageUrl!)
                    : null,
                child: member.profileImageUrl == null
                    ? Text(
                    member.name.isNotEmpty ? member.name[0].toUpperCase() : 'F')
                    : null,
              ),
              title: Text(member.name, style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(member.relationship,
                      style: textTheme.bodyMedium?.copyWith(color: Theme
                          .of(context)
                          .colorScheme
                          .primary)),
                  if (member.dateOfBirth != null)
                    Text('Age: ${member.age}', style: textTheme.bodySmall),
                ],
              ),
              trailing: PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_outlined),
                onSelected: (value) {
                  if (value == 'edit') {
                    _navigateToAddEditScreen(member: member);
                  } else if (value == 'delete') {
                    _confirmDeleteMember(member);
                  }
                  // --- TODO: Add 'view_details' or other actions if needed ---
                },
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: ListTile(leading: Icon(Icons.edit_outlined),
                        title: Text('Edit')),
                  ),
                  const PopupMenuItem<String>(
                    value: 'delete',
                    child: ListTile(leading: Icon(Icons.delete_outline,
                        color: Colors.red),
                        title: Text('Delete', style: TextStyle(
                            color: Colors.red))),
                  ),
                ],
              ),
              onTap: () {
                // Optionally, navigate to a detailed view screen for the family member
                // For now, edit is in the popup menu.
                _navigateToAddEditScreen(
                    member: member); // Or a dedicated view screen
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToAddEditScreen(),
        label: const Text('Add Member'),
        icon: const Icon(Icons.add_outlined),
      ),
    );
  }
}