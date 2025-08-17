import 'package:flutter/material.dart';
import '../../models/user_models/PatientBasicInfo.dart';
import 'RelatedPatientDetailScreen.dart';
import '../../widgets/AppDrawer.dart';


class LinkedFamilyMember {
  final PatientBasicInfo patient;
  final String relationship;

  LinkedFamilyMember({
    required this.patient,
    required this.relationship,
  });
}

class LinkPatientByIdScreen extends StatefulWidget {
  final List<String> alreadyLinkedIds;

  const LinkPatientByIdScreen({super.key, required this.alreadyLinkedIds});

  @override
  State<LinkPatientByIdScreen> createState() => _LinkPatientByIdScreenState();
}

class _LinkPatientByIdScreenState extends State<LinkPatientByIdScreen> {
  final _patientIdController = TextEditingController();
  final _relationshipController = TextEditingController();
  String _searchMessage = '';

  static final List<PatientBasicInfo> _allSystemPatients = [
    PatientBasicInfo(id: "PAT001", name: "Alice Wonderland", age: 30, gender: "Female", profileImageUrl: "https://i.pravatar.cc/150?u=PAT001", lastActivity: "Online 5 mins ago"),
    PatientBasicInfo(id: "PAT002", name: "Bob The Builder", age: 45, gender: "Male", profileImageUrl: "https://i.pravatar.cc/150?u=PAT002", lastActivity: "Active 1 hour ago"),
    PatientBasicInfo(id: "PAT003", name: "Charlie Chaplin", age: 60, gender: "Male", profileImageUrl: null, lastActivity: "Seen yesterday"),
    PatientBasicInfo(id: "PAT004", name: "Diana Prince", age: 28, gender: "Female", profileImageUrl: "https://i.pravatar.cc/150?u=PAT004", lastActivity: "Online now"),
    PatientBasicInfo(id: "PAT005", name: "Edward Scissorhands", age: 35, gender: "Male", profileImageUrl: "https://i.pravatar.cc/150?u=PAT005", lastActivity: "Vitals updated 2h ago"),
  ];

  void _searchAndLinkPatient() {
    final String enteredId = _patientIdController.text.trim();
    final String enteredRelationship = _relationshipController.text.trim();

    if (enteredId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a Patient ID."), backgroundColor: Colors.orange),
      );
      return;
    }

    if (enteredRelationship.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a relationship."), backgroundColor: Colors.orange),
      );
      return;
    }

    if (widget.alreadyLinkedIds.contains(enteredId)) {
      setState(() {
        _searchMessage = "Patient with ID '$enteredId' is already linked.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Patient with ID '$enteredId' is already linked."), backgroundColor: Colors.amber),
      );
      return;
    }

    try {
      final PatientBasicInfo foundPatient = _allSystemPatients.firstWhere(
            (patient) => patient.id.toLowerCase() == enteredId.toLowerCase(),
      );

      final LinkedFamilyMember linkedMember = LinkedFamilyMember(
        patient: foundPatient,
        relationship: enteredRelationship,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Patient '${foundPatient.name}' linked successfully as $enteredRelationship!"), backgroundColor: Colors.green),
      );

      Navigator.pop(context, linkedMember);

    } catch (e) {
      setState(() {
        _searchMessage = "Patient with ID '$enteredId' not found in the system.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Patient with ID '$enteredId' not found."), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Link Patient by ID")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter the ID of the patient you wish to link with and specify the relationship. The request will be simulated as accepted immediately.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _patientIdController,
              decoration: InputDecoration(
                labelText: "Patient ID",
                hintText: "e.g., PAT001",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.badge_outlined),
              ),
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _relationshipController,
              decoration: InputDecoration(
                labelText: "Relationship",
                hintText: "e.g., Sister, Brother, Cousin",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.family_restroom),
              ),
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _searchAndLinkPatient(),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.search_rounded),
              label: const Text("Search & Link Patient"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              onPressed: _searchAndLinkPatient,
            ),
            const SizedBox(height: 20),
            if (_searchMessage.isNotEmpty)
              Text(
                _searchMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _searchMessage.contains("not found") || _searchMessage.contains("Please enter")
                      ? Colors.redAccent
                      : _searchMessage.contains("already linked")
                      ? Colors.amber.shade700
                      : Colors.green,
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
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
  List<LinkedFamilyMember> _linkedFamilyMembers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchLinkedFamilyMembers();
  }

  Future<void> _fetchLinkedFamilyMembers() async {
    if (mounted) setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    _linkedFamilyMembers = [];
    if (mounted) setState(() => _isLoading = false);
  }

  List<LinkedFamilyMember> get _filteredMembers {
    if (_searchQuery.isEmpty) {
      return _linkedFamilyMembers;
    }
    return _linkedFamilyMembers
        .where((member) => member.patient.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _navigateToMemberDetail(LinkedFamilyMember member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RelatedPatientDetailScreen(memberInfo: member.patient, relationship: member.relationship),
      ),
    );
  }

  Future<void> _navigateAndLinkPatient() async {
    final List<String> currentlyLinkedIds = _linkedFamilyMembers.map((m) => m.patient.id).toList();
    final newMember = await Navigator.push<LinkedFamilyMember>(
      context,
      MaterialPageRoute(
        builder: (context) => LinkPatientByIdScreen(alreadyLinkedIds: currentlyLinkedIds),
      ),
    );

    if (newMember != null && mounted) {
      if (!_linkedFamilyMembers.any((member) => member.patient.id == newMember.patient.id)) {
        setState(() {
          _linkedFamilyMembers.add(newMember);
          _linkedFamilyMembers.sort((a, b) => a.patient.name.compareTo(b.patient.name));
        });
      }
    }
  }

  Future<void> _unlinkPatient(LinkedFamilyMember memberToUnlink) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Unlink'),
          content: Text('Are you sure you want to unlink from ${memberToUnlink.patient.name}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Unlink'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      setState(() {
        _linkedFamilyMembers.removeWhere((member) => member.patient.id == memberToUnlink.patient.id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully unlinked from ${memberToUnlink.patient.name}.'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final String _name = "family";
    final String _email = "family@healthguard.com";
    final String? _profilePic = null;

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
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
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _linkedFamilyMembers.isEmpty && _searchQuery.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "You are not monitoring any family members yet.",
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.group_add_outlined),
                label: const Text("Link to a Family Member"),
                onPressed: _navigateAndLinkPatient,
              )
            ],
          ),
        ),
      )
          : _filteredMembers.isEmpty && _searchQuery.isNotEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No members found matching '$_searchQuery'.",
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.group_add_outlined),
                label: const Text("Link New Member"),
                onPressed: _navigateAndLinkPatient,
              )
            ],
          ),
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchLinkedFamilyMembers,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 8),
          itemCount: _filteredMembers.length,
          itemBuilder: (context, index) {
            final member = _filteredMembers[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                  backgroundImage: member.patient.profileImageUrl != null
                      ? NetworkImage(member.patient.profileImageUrl!)
                      : null,
                  child: member.patient.profileImageUrl == null
                      ? Text(member.patient.name.isNotEmpty ? member.patient.name[0].toUpperCase() : 'P')
                      : null,
                ),
                title: Text(
                  member.patient.name,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  "${member.relationship} • ${member.patient.lastActivity}",
                  style: textTheme.bodySmall,
                ),
                trailing: IconButton(
                  icon: Icon(Icons.link_off, color: Theme.of(context).colorScheme.error),
                  tooltip: "Unlink ${member.patient.name}",
                  onPressed: () => _unlinkPatient(member),
                ),
                onTap: () => _navigateToMemberDetail(member),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateAndLinkPatient,
        label: const Text("Link Member"),
        icon: const Icon(Icons.group_add_outlined),
      ),
    );
  }
}
