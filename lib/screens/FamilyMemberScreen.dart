import 'package:flutter/material.dart';
import 'dart:math'; // For dummy data

import '../models/user_models.dart'; // For PatientBasicInfo (or your specific model)
import 'FamilyMemberDetailScreen.dart'; // The detail screen
import '../widgets/app_drawer.dart'; // For the drawer
import '../models/user_roles.dart'; // For UserRole';
// Placeholder for the "Add Family Member" flow
class RequestLinkFamilyMemberScreen extends StatelessWidget {
  const RequestLinkFamilyMemberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Link New Member")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "To link with another family member, you'll typically send them a request. They will need to approve it from their account.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add_alt_1_outlined),
                label: const Text("Initiate Link Request (TODO)"),
                onPressed: () {
                  // TODO: Implement the actual linking request logic with backend
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(
                        'Linking request feature is not yet implemented.')),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}


class FamilyMemberScreen extends StatefulWidget {
  const FamilyMemberScreen({super.key});

  @override
  State<FamilyMemberScreen> createState() => _FamilyMemberScreenState();
}

class _FamilyMemberScreenState extends State<FamilyMemberScreen> {
  List<PatientBasicInfo> _linkedFamilyMembers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchLinkedFamilyMembers();
  }

  Future<void> _fetchLinkedFamilyMembers() async {
    if (mounted) setState(() => _isLoading = true);

    // --- TODO: ACTUAL API call to get the list of family members ---
    // This will involve authentication for the logged-in family member
    // and querying the backend for their approved connections.
    print("Fetching list of linked family members...");
    await Future.delayed(
        const Duration(milliseconds: 1200)); // Simulate API call

    // --- Dummy Data Generation ---
    final Random random = Random();
    const names = [
      "Eleanor Vance",
      "Marcus Chen",
      "Sophia Miller",
      "David Rodriguez",
      "Olivia Kim"
    ];
    const relationships = ["Mother", "Brother", "Spouse", "Father", "Daughter"];
    _linkedFamilyMembers =
        List.generate(random.nextInt(4) + 1, (index) { // 1 to 4 members
          final name = names[random.nextInt(names.length)];
          return PatientBasicInfo(
            id: 'FMID${2000 + index}',
            name: name,
            relationship: relationships[random.nextInt(relationships.length)],
            profileImageUrl: random.nextBool()
                ? 'https://i.pravatar.cc/150?u=$name'
                : null,
            lastActivity: "Vitals updated ${random.nextInt(3) + 1}h ago",
          );
        });
    _linkedFamilyMembers.sort((a, b) => a.name.compareTo(b.name));
    // --- End Dummy Data Generation ---

    if (mounted) setState(() => _isLoading = false);
  }

  List<PatientBasicInfo> get _filteredMembers {
    if (_searchQuery.isEmpty) {
      return _linkedFamilyMembers;
    }
    return _linkedFamilyMembers
        .where((member) =>
    member.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        member.relationship.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _navigateToMemberDetail(PatientBasicInfo member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FamilyMemberDetailScreen(memberInfo: member),
      ),
    );
  }

  void _navigateToAddFamilyMemberFlow() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (
            context) => const RequestLinkFamilyMemberScreen(), // Placeholder screen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme
        .of(context)
        .textTheme;
    final String _adminName = "Super Admin";
    final String _adminEmail = "admin@healthguard.com";
    final String? _adminProfilePic = null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Family Circle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchLinkedFamilyMembers,
            tooltip: "Refresh List",
          )
        ],
        bottom: PreferredSize( // Search Bar
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or relationship...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme
                    .of(context)
                    .colorScheme
                    .surface,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 0, horizontal: 20),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
        ),
      ),
      drawer: AppDrawer(
        currentUserRole: UserRole.patient, // <-- Set the role to admin
        userName: _adminName,
        userEmail: _adminEmail,
        userProfileImageUrl: _adminProfilePic,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredMembers.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _searchQuery.isNotEmpty
                    ? "No members found matching '$_searchQuery'."
                    : "You are not monitoring any family members yet.",
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.group_add_outlined),
                label: const Text("Link to a Family Member"),
                onPressed: _navigateToAddFamilyMemberFlow,
              )
            ],
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchLinkedFamilyMembers,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8), // Add padding on top of list
          itemCount: _filteredMembers.length,
          itemBuilder: (context, index) {
            final member = _filteredMembers[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                  horizontal: 12.0, vertical: 6.0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .tertiaryContainer,
                  foregroundColor: Theme
                      .of(context)
                      .colorScheme
                      .onTertiaryContainer,
                  backgroundImage: member.profileImageUrl != null
                      ? NetworkImage(member.profileImageUrl!)
                      : null,
                  child: member.profileImageUrl == null
                      ? Text(member.name.isNotEmpty
                      ? member.name[0].toUpperCase()
                      : 'F')
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
                    const SizedBox(height: 2),
                    Text(member.lastActivity, style: textTheme.bodySmall),
                  ],
                ),
                trailing: Icon(Icons.chevron_right, color: Theme
                    .of(context)
                    .colorScheme
                    .outline),
                onTap: () => _navigateToMemberDetail(member),
                isThreeLine: true, // Allows subtitle to wrap if needed
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddFamilyMemberFlow,
        label: const Text("Link Member"),
        icon: const Icon(Icons.group_add_outlined),
        // backgroundColor: Theme.of(context).colorScheme.tertiary,
        // foregroundColor: Theme.of(context).colorScheme.onTertiary,
      ),
    );
  }
}