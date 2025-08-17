import 'package:flutter/material.dart';
import '../../models/user_models/FamilyMember.dart';

final List<FamilyMember> _allSystemUsers = [
  FamilyMember(
    id: "laura_s_88",
    name: "Laura Smith",
    relationship: "Spouse",
    dateOfBirth: DateTime(1988, 7, 20),
    profileImageUrl: 'https://i.pravatar.cc/150?u=laura_smith_family',
  ),
  FamilyMember(
    id: "michael_jr_15",
    name: "Michael Smith Jr.",
    relationship: "Child",
    dateOfBirth: DateTime(2015, 3, 10),
  ),
  FamilyMember(
    id: "sarah_c_65",
    name: "Sarah Connor",
    relationship: "Mother",
    dateOfBirth: DateTime(1965, 11, 5),
    profileImageUrl: 'https://i.pravatar.cc/150?u=sarah_connor_family',
  ),
  FamilyMember(
    id: "john_d_70",
    name: "John Doe",
    relationship: "Friend",
    dateOfBirth: DateTime(1970, 1, 1),
    profileImageUrl: 'https://i.pravatar.cc/150?u=john_doe_sys',
  ),
  FamilyMember(
    id: "jane_r_92",
    name: "Jane Roe",
    relationship: "Colleague",
    dateOfBirth: DateTime(1992, 5, 15),
  ),
];

class ManageFamilyMembersScreen extends StatefulWidget {
  const ManageFamilyMembersScreen({super.key});

  @override
  State<ManageFamilyMembersScreen> createState() =>
      _ManageFamilyMembersScreenState();
}

class _ManageFamilyMembersScreenState extends State<ManageFamilyMembersScreen> {
  static List<FamilyMember> _sessionLinkedMembers = [];

  List<FamilyMember> _linkedFamilyMembers = [];
  bool _isLoadingInitialLinks = true;
  final TextEditingController _searchIdController = TextEditingController();
  FamilyMember? _searchedUserResult;
  String? _searchFeedbackMessage;
  bool _isProcessingAction = false;

  @override
  void initState() {
    super.initState();
    _linkedFamilyMembers = List.from(_sessionLinkedMembers);
    _handleRefreshLinkedMembers();
  }

  @override
  void dispose() {
    _searchIdController.dispose();
    super.dispose();
  }

  Future<void> _handleRefreshLinkedMembers() async {
    if (mounted) setState(() => _isLoadingInitialLinks = true);
    await Future.delayed(const Duration(milliseconds: 300));

    _linkedFamilyMembers = List.from(_sessionLinkedMembers);
    _linkedFamilyMembers.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    if (mounted) {
      setState(() {
        _isLoadingInitialLinks = false;
      });
    }
  }

  void _handleSearchUserById() async {
    final String idToSearch = _searchIdController.text.trim();
    FocusScope.of(context).unfocus();

    if (idToSearch.isEmpty) {
      setState(() {
        _searchedUserResult = null;
        _searchFeedbackMessage = "Please enter a User ID to search.";
        _isProcessingAction = false;
      });
      return;
    }

    setState(() {
      _isProcessingAction = true;
      _searchedUserResult = null;
      _searchFeedbackMessage = "Searching for ID: $idToSearch...";
    });

    await Future.delayed(const Duration(milliseconds: 800));

    FamilyMember? foundUserInSystem;
    try {
      foundUserInSystem =
          _allSystemUsers.firstWhere((member) => member.id == idToSearch);
    } catch (e) {
      foundUserInSystem = null;
    }

    if (mounted) {
      if (foundUserInSystem != null) {
        final bool isAlreadyLinked = _linkedFamilyMembers
            .any((linkedMember) => linkedMember.id == foundUserInSystem!.id);
        if (isAlreadyLinked) {
          _searchFeedbackMessage =
              "'${foundUserInSystem.name}' is already linked.";
        } else {
          _searchFeedbackMessage = "Found user: '${foundUserInSystem.name}'.";
        }
        _searchedUserResult = foundUserInSystem;
      } else {
        _searchFeedbackMessage = "User with ID '$idToSearch' not found.";
        _searchedUserResult = null;
      }
      setState(() {
        _isProcessingAction = false;
      });
    }
  }

  void _sendLinkRequestAndSimulateAccept(FamilyMember userToLink) async {
    setState(() {
      _isProcessingAction = true;
      _searchFeedbackMessage = "Sending link request to '${userToLink.name}'...";
    });

    await Future.delayed(const Duration(milliseconds: 1200));

    if (mounted) {
      if (!_linkedFamilyMembers.any((m) => m.id == userToLink.id)) {
        _linkedFamilyMembers.add(userToLink);
        _linkedFamilyMembers.sort((a, b) =>
            a.name.toLowerCase().compareTo(b.name.toLowerCase()));

        if (!_sessionLinkedMembers.any((m) => m.id == userToLink.id)) {
          _sessionLinkedMembers.add(userToLink);
          _sessionLinkedMembers.sort((a, b) => 
              a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Link request for '${userToLink.name}' auto-accepted!"),
            backgroundColor: Colors.green),
      );
      
      setState(() {
        _isProcessingAction = false;
        _searchedUserResult = null; 
        _searchIdController.clear();
        _searchFeedbackMessage = null; 
      });
    }
  }

  void _confirmUnlinkMember(FamilyMember member) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Unlink ${member.name}?'),
          content: Text(
              'Are you sure you want to unlink ${member.name}? They will no longer appear in your linked members list.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Unlink'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _unlinkMember(member);
              },
            ),
          ],
        );
      },
    );
  }

  void _unlinkMember(FamilyMember member) async {
    setState(() {
      _isProcessingAction = true;
    });

    await Future.delayed(const Duration(milliseconds: 600)); 

    if (mounted) {
      _linkedFamilyMembers.removeWhere((m) => m.id == member.id);
      _sessionLinkedMembers.removeWhere((m) => m.id == member.id);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('${member.name} has been unlinked.'),
            backgroundColor: Colors.orange),
      );
      setState(() {
        _isProcessingAction = false;
        if (_searchedUserResult?.id == member.id) {
            _searchedUserResult = null;
            _searchFeedbackMessage = "'${member.name}' was unlinked.";
        }
      });
    }
  }

  Widget _buildAvatar(FamilyMember member, BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
      backgroundImage:
          member.profileImageUrl != null && member.profileImageUrl!.isNotEmpty
              ? NetworkImage(member.profileImageUrl!)
              : null,
      child: member.profileImageUrl == null || member.profileImageUrl!.isEmpty
          ? Text(member.name.isNotEmpty ? member.name[0].toUpperCase() : 'U',
              style: TextStyle(fontWeight: FontWeight.bold))
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    bool isUserFoundAndNotLinked = _searchedUserResult != null &&
        !_linkedFamilyMembers.any((m) => m.id == _searchedUserResult!.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Link Family Members'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: _isLoadingInitialLinks || _isProcessingAction ? null : _handleRefreshLinkedMembers,
            tooltip: "Refresh Linked Members",
          )
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Search by User ID to Link", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              TextField(
                controller: _searchIdController,
                decoration: InputDecoration(
                  labelText: "Enter User ID",
                  hintText: "e.g., laura_s_88, john_d_70",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchIdController.clear();
                      if (mounted) {
                        setState(() {
                          _searchedUserResult = null;
                          _searchFeedbackMessage = null;
                        });
                      }
                    },
                  ),
                ),
                keyboardType: TextInputType.text,
                onSubmitted: (_) => _isProcessingAction ? null : _handleSearchUserById(),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.search_outlined),
                label: const Text("Search User"),
                onPressed: _isProcessingAction ? null : _handleSearchUserById,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
              const SizedBox(height: 16),

              if (_isProcessingAction && _searchFeedbackMessage == "Searching for ID: ${_searchIdController.text.trim()}...")
                const Center(child: Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator())),
              if (_searchFeedbackMessage != null && !(_isProcessingAction && _searchFeedbackMessage!.startsWith("Searching")))
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _searchFeedbackMessage!,
                    style: textTheme.bodyMedium?.copyWith(
                        color: _searchedUserResult != null && isUserFoundAndNotLinked
                            ? Colors.green.shade700
                            : Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              
              if (_searchedUserResult != null)
                Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        _buildAvatar(_searchedUserResult!, context),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_searchedUserResult!.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                              Text("ID: ${_searchedUserResult!.id}", style: textTheme.bodySmall),
                            ],
                          ),
                        ),
                        if (isUserFoundAndNotLinked)
                          ElevatedButton.icon(
                            icon: const Icon(Icons.link_outlined),
                            label: const Text("Link"),
                            onPressed: _isProcessingAction ? null : () => _sendLinkRequestAndSimulateAccept(_searchedUserResult!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        else if (_linkedFamilyMembers.any((m) => m.id == _searchedUserResult!.id))
                          Text("Linked", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),

              const Divider(thickness: 1, height: 32),

              Text("Your Linked Family Members (${_linkedFamilyMembers.length})", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              if (_isLoadingInitialLinks)
                const Center(child: CircularProgressIndicator())
              else if (_linkedFamilyMembers.isEmpty)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "No family members linked yet. Search for a user by their ID above to send a link request.",
                        textAlign: TextAlign.center,
                        style: textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: _linkedFamilyMembers.length,
                    itemBuilder: (context, index) {
                      final member = _linkedFamilyMembers[index];
                      return Card(
                        elevation: 1.5,
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          leading: _buildAvatar(member, context),
                          title: Text(member.name, style: textTheme.titleMedium),
                          subtitle: Text("ID: ${member.id}", style: textTheme.bodySmall),
                          trailing: IconButton(
                            icon: Icon(Icons.link_off_outlined, color: Colors.redAccent.shade200),
                            tooltip: "Unlink ${member.name}",
                            onPressed: _isProcessingAction ? null : () => _confirmUnlinkMember(member),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
