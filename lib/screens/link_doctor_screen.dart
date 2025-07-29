import 'package:flutter/material.dart';
import 'dart:math'; // For dummy data

import '../models/user_models.dart'; // Ensure DoctorSearchResultInfo is here

// Assume this state is managed globally (e.g., via Provider, Riverpod, Bloc)
// For this example, we'll simulate it as a local variable in the screen,
// but in a real app, this should come from a central state management solution.
String? _currentPatientLinkedDoctorId; // Example: 'DOC1002' if linked
// In a real app, you'd fetch this when the patient's data is loaded.


class LinkDoctorScreen extends StatefulWidget {
  // You might pass the currently linked doctor's ID to this screen
  final String? initiallyLinkedDoctorId;

  const LinkDoctorScreen({super.key, this.initiallyLinkedDoctorId});

  @override
  State<LinkDoctorScreen> createState() => _LinkDoctorScreenState();
}

class _LinkDoctorScreenState extends State<LinkDoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DoctorSearchResultInfo> _searchResults = [];
  bool _isLoading = false;
  String _searchQuery = "";
  String? _statusMessage;

  // Simulate the patient's currently linked doctor ID
  // This would typically come from a state management solution
  late String? _patientLinkedDoctorId;
  DoctorSearchResultInfo? _currentlyLinkedDoctorDetails; // Store full details if fetched

  @override
  void initState() {
    super.initState();
    _patientLinkedDoctorId = widget.initiallyLinkedDoctorId ??
        _currentPatientLinkedDoctorId; // Use passed or simulated global
    if (_patientLinkedDoctorId != null) {
      _fetchLinkedDoctorDetails(_patientLinkedDoctorId!);
    }
  }

  // --- TODO: Fetch details of the currently linked doctor if only ID is known ---
  Future<void> _fetchLinkedDoctorDetails(String doctorId) async {
    if (mounted) setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate API
    // In a real app, fetch doctor details by ID
    // For this dummy example, let's try to find it in a potential dummy list
    // or create a dummy one.
    // This is just to populate _currentlyLinkedDoctorDetails for the UI.
    final Random random = Random();
    const firstNames = [
      "James",
      "Patricia",
      "Robert",
      "Jennifer",
      "Michael",
      "Linda"
    ];
    const lastNames = [
      "Smith",
      "Jones",
      "Williams",
      "Brown",
      "Davis",
      "Miller"
    ];
    final name = "Dr. ${firstNames[random.nextInt(
        firstNames.length)]} ${lastNames[random.nextInt(lastNames.length)]}";

    if (mounted) {
      setState(() {
        _currentlyLinkedDoctorDetails = DoctorSearchResultInfo(
          doctorId: doctorId,
          name: name,
          // Replace with actual fetched name
          profileImageUrl: 'https://i.pravatar.cc/150?u=$doctorId',
          // Dummy image
          isCurrentlyLinkedToThisDoctor: true,
        );
        _isLoading = false;
      });
    }
  }


  Future<void> _searchDoctors(String query) async {
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
          _statusMessage = null;
        });
      }
      return;
    }
    if (mounted) {
      setState(() {
        _isLoading = true;
        _searchQuery = query;
        _statusMessage = null;
      });
    }

    await Future.delayed(const Duration(milliseconds: 1000));

    List<DoctorSearchResultInfo> results = [];
    if (query.isNotEmpty) {
      final Random random = Random();
      const firstNames = [
        "James",
        "Patricia",
        "Robert",
        "Jennifer",
        "Michael",
        "Linda"
      ];
      const lastNames = [
        "Smith",
        "Jones",
        "Williams",
        "Brown",
        "Davis",
        "Miller"
      ];

      int numberOfResults = random.nextInt(4) + 1; // 1 to 4 results
      for (int i = 0; i < numberOfResults; i++) {
        final docId = 'DOC${1000 + i + random.nextInt(100)}';
        final name = "Dr. ${firstNames[random.nextInt(
            firstNames.length)]} ${lastNames[random.nextInt(
            lastNames.length)]}";

        if (name.toLowerCase().contains(query.toLowerCase())) {
          results.add(
            DoctorSearchResultInfo(
              doctorId: docId,
              name: name,
              profileImageUrl: random.nextBool()
                  ? 'https://i.pravatar.cc/150?u=$docId'
                  : null,
              isCurrentlyLinkedToThisDoctor: docId == _patientLinkedDoctorId,
            ),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        _searchResults = results;
        _isLoading = false;
        if (results.isEmpty && query.isNotEmpty) {
          _statusMessage = "No doctors found matching '$query'.";
        }
      });
    }
  }

  // --- TODO: Replace with actual API call to send link/switch request ---
  Future<void> _sendLinkRequest(DoctorSearchResultInfo doctorToLink) async {
    if (mounted) {
      setState(() {
        _isLoading = true;
        _statusMessage = "Sending request to ${doctorToLink.name}...";
      });
    }

    print("Patient is requesting to link with Doctor ID: ${doctorToLink
        .doctorId}");
    // Backend logic:
    // 1. If patient has an existing link, backend might automatically unlink the old one.
    // 2. Or, it might require explicit unlinking first.
    // 3. A request is sent to the new doctor for approval.
    await Future.delayed(const Duration(seconds: 2));

    // --- Backend handles the request ---
    // On success:
    if (mounted) {
      setState(() {
        // Update the local state for the patient's linked doctor
        _patientLinkedDoctorId = doctorToLink.doctorId;
        _currentPatientLinkedDoctorId =
            doctorToLink.doctorId; // Update simulated global
        _currentlyLinkedDoctorDetails =
            doctorToLink.copyWith(isCurrentlyLinkedToThisDoctor: true);

        // Update search results to reflect the new link
        _searchResults = _searchResults.map((doc) {
          return doc.copyWith(isCurrentlyLinkedToThisDoctor: doc.doctorId ==
              doctorToLink.doctorId);
        }).toList();

        _isLoading = false;
        _statusMessage =
        "Link request sent to ${doctorToLink.name}. Waiting for approval.";
        _searchController.clear(); // Clear search
        _searchResults = []; // Clear results to show the main status

      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Link request sent to ${doctorToLink.name}.'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (mounted) { // On failure
      setState(() {
        _isLoading = false;
        _statusMessage = "Could not send request. Please try again.";
      });
    }
  }

  // --- TODO: Replace with actual API call to UNLINK from the current doctor ---


  Future<void> _unlinkCurrentDoctor() async {
    if (_patientLinkedDoctorId == null) return;

    // Store the name BEFORE trying to unlink, in case _currentlyLinkedDoctorDetails is cleared on success
    // before the SnackBar uses it.
    final String doctorNameToDisplay = _currentlyLinkedDoctorDetails?.name ??
        "your doctor";

    if (mounted) {
      setState(() {
        _isLoading = true;
        _statusMessage = "Unlinking from $doctorNameToDisplay...";
      });
    }

    print(
        "Patient is requesting to UNLINK from Doctor ID: $_patientLinkedDoctorId");

    // --- Simulate Backend Unlinking ---
    // In a real app, this would be an async API call that returns a success/failure status
    bool unlinkSuccess = false;
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      // TODO: Replace with actual API call. Example:
      // final response = await http.post(Uri.parse('YOUR_API_UNLINK_URL'), body: {'doctorId': _patientLinkedDoctorId});
      // if (response.statusCode == 200) {
      //   unlinkSuccess = true;
      // } else {
      //   unlinkSuccess = false;
      //   // Optionally, parse error message from response
      // }
      unlinkSuccess = true; // Simulate success for now
    } catch (e) {
      print("Error during unlinking: $e");
      unlinkSuccess = false; // Ensure it's marked as failed on exception
    }
    // --- End Backend Unlinking ---


    if (!mounted)
      return; // Check if widget is still mounted after the async operation

    if (unlinkSuccess) {
      setState(() {
        _patientLinkedDoctorId = null;
        _currentPatientLinkedDoctorId = null; // Update simulated global
        _currentlyLinkedDoctorDetails = null;

        _searchResults = _searchResults.map((doc) {
          return doc.copyWith(isCurrentlyLinkedToThisDoctor: false);
        }).toList();

        _isLoading = false;
        _statusMessage = "Successfully unlinked from $doctorNameToDisplay.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully unlinked from $doctorNameToDisplay.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else { // Unlink failed
      setState(() {
        _isLoading = false;
        _statusMessage =
        "Could not unlink from $doctorNameToDisplay. Please try again.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Failed to unlink from $doctorNameToDisplay. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showLinkConfirmationDialog(DoctorSearchResultInfo doctor) {
    // If patient is already linked to THIS doctor, no action or show "Already Linked"
    if (doctor.isCurrentlyLinkedToThisDoctor) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You are already linked with ${doctor.name}.')),
      );
      return;
    }

    String title;
    String content;
    String confirmButtonText;
    VoidCallback onConfirm;

    if (_patientLinkedDoctorId != null &&
        _patientLinkedDoctorId != doctor.doctorId) {
      // Patient is linked to a DIFFERENT doctor, so this is a SWITCH request
      title = 'Switch to ${doctor.name}?';
      content =
      'You are currently linked with ${_currentlyLinkedDoctorDetails?.name ??
          "another doctor"}.\n\nIf you link with ${doctor
          .name}, your link with the previous doctor will be ${ /* backend might auto-unlink or require manual unlink first */ "replaced upon approval"}.\n\nSend request to ${doctor
          .name}?';
      confirmButtonText = 'Switch & Request';
      onConfirm = () {
        Navigator.of(context).pop();
        _sendLinkRequest(doctor);
      };
    } else {
      // Patient is not linked to any doctor, or linking to the same one again (which is blocked above)
      title = 'Link with ${doctor.name}?';
      content =
      'If ${doctor
          .name} approves your request, they will be able to view your health data.\n\nDo you want to send a link request?';
      confirmButtonText = 'Send Request';
      onConfirm = () {
        Navigator.of(context).pop();
        _sendLinkRequest(doctor);
      };
    }

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            ElevatedButton(
              child: Text(confirmButtonText),
              onPressed: onConfirm,
            ),
          ],
        );
      },
    );
  }

  void _showUnlinkConfirmationDialog() {
    if (_currentlyLinkedDoctorDetails == null) return;
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Unlink from ${_currentlyLinkedDoctorDetails!.name}?'),
          content: const Text(
              'If you unlink, this doctor will no longer have access to your health data. You can link with another doctor later.'),
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
                _unlinkCurrentDoctor();
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildCurrentlyLinkedDoctorCard() {
    if (_currentlyLinkedDoctorDetails == null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          color: Theme
              .of(context)
              .colorScheme
              .surfaceVariant
              .withOpacity(0.7),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.link_off, color: Colors.grey[600], size: 20),
                const SizedBox(width: 12),
                Text("You are not currently linked to any doctor.",
                    style: TextStyle(color: Colors.grey[700])),
              ],
            ),
          ),
        ),
      );
    }

    final doctor = _currentlyLinkedDoctorDetails!;
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme
          .of(context)
          .colorScheme
          .primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                "Currently Linked Doctor:",
                style: Theme
                    .of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withOpacity(0.8)
                )
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Theme
                      .of(context)
                      .colorScheme
                      .secondaryContainer,
                  foregroundColor: Theme
                      .of(context)
                      .colorScheme
                      .onSecondaryContainer,
                  backgroundImage: doctor.profileImageUrl != null
                      ? NetworkImage(doctor.profileImageUrl!)
                      : null,
                  child: doctor.profileImageUrl == null
                      ? Text(doctor.name.isNotEmpty ? doctor.name[0] : 'D')
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    doctor.name,
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onPrimaryContainer
                    ),
                  ),
                ),
                TextButton.icon(
                  icon: Icon(Icons.link_off_outlined, color: Theme
                      .of(context)
                      .colorScheme
                      .error),
                  label: Text('Unlink', style: TextStyle(color: Theme
                      .of(context)
                      .colorScheme
                      .error)),
                  onPressed: _showUnlinkConfirmationDialog,
                  style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10)
                  ),
                ),
              ],
            ),
            // You could add "Link pending approval" status here if that's a state from your backend
            // e.g., if (_patientLinkedDoctorId != null && !_currentlyLinkedDoctorDetails.isApprovedByDoctor)
            // Text("Link pending approval", style: TextStyle(color: Colors.orange)),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Link to a Doctor'),
      ),
      body: Column(
        children: <Widget>[
          // Display current linked doctor or "not linked" message
          if (!_isLoading &&
              _searchQuery.isEmpty) // Show only if not searching actively
            _buildCurrentlyLinkedDoctorCard(),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              controller: _searchController,
              // autofocus: _patientLinkedDoctorId == null, // Autofocus if not linked
              decoration: InputDecoration(
                hintText: 'Search for a doctor by name...',
                prefixIcon: const Icon(Icons.search_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme
                    .of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.5),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear_outlined),
                  onPressed: () {
                    _searchController.clear();
                    _searchDoctors(''); // Clear results
                  },
                )
                    : null,
              ),
              onChanged: (value) {
                if (value.length > 2 || value.isEmpty) {
                  _searchDoctors(value);
                } else if (value
                    .isEmpty) { // Explicitly clear if text is deleted completely
                  setState(() => _searchResults = []);
                }
              },
              onSubmitted: (value) => _searchDoctors(value),
            ),
          ),

          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            if (_statusMessage != null && _searchResults.isEmpty &&
                _searchQuery.isNotEmpty) // Message after search
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: Text(_statusMessage!, textAlign: TextAlign.center,
                      style: textTheme.titleMedium),
                ),
              )
            else
              if (_searchResults.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 16),
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final doctor = _searchResults[index];
                      bool isThisTheCurrentlyLinkedDoctor = doctor.doctorId ==
                          _patientLinkedDoctorId;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 6.0),
                        elevation: 1.5,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .secondaryContainer,
                            foregroundColor: Theme
                                .of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            backgroundImage: doctor.profileImageUrl != null
                                ? NetworkImage(doctor.profileImageUrl!)
                                : null,
                            child: doctor.profileImageUrl == null
                                ? Text(
                                doctor.name.isNotEmpty ? doctor.name.substring(
                                    0, 1) : 'D')
                                : null,
                          ),
                          title: Text(
                              doctor.name, style: textTheme.titleMedium),
                          // No subtitle for specialty/clinic
                          trailing: isThisTheCurrentlyLinkedDoctor
                              ? Chip(
                            avatar: Icon(Icons.check_circle, color: Theme
                                .of(context)
                                .colorScheme
                                .primary),
                            label: Text('Linked', style: TextStyle(color: Theme
                                .of(context)
                                .colorScheme
                                .primary)),
                            backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .primaryContainer
                                .withOpacity(0.5),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 0),
                          )
                              : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                            ),
                            // If already linked to someone else, this button initiates a switch
                            onPressed: () =>
                                _showLinkConfirmationDialog(doctor),
                            child: Text(_patientLinkedDoctorId != null
                                ? 'Switch'
                                : 'Link'),
                          ),
                          onTap: isThisTheCurrentlyLinkedDoctor ? null : () =>
                              _showLinkConfirmationDialog(doctor),
                        ),
                      );
                    },
                  ),
                )
              else
                if (_searchQuery.isNotEmpty && !_isLoading &&
                    _searchResults.isEmpty && _statusMessage == null)
                  Expanded( // Explicit message if search done, no results, no other status
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          "No doctors found for '$_searchQuery'.\nPlease check the name and try again.",
                          textAlign: TextAlign.center,
                          style: textTheme.titleMedium?.copyWith(
                              color: Colors.grey[700]),
                        ),
                      ),
                    ),
                  )
                else
                  if (_searchQuery.isEmpty && !_isLoading &&
                      _currentlyLinkedDoctorDetails ==
                          null) // Initial empty state (not linked, no search)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person_search_outlined, size: 70,
                                color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Search for a doctor by name to link your health data.',
                              style: textTheme.titleMedium?.copyWith(
                                  color: Colors.grey[700]),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
          // Fallback, usually covered if _currentlyLinkedDoctorDetails is shown at top
          // else if (_searchQuery.isEmpty && !_isLoading)
          //    Expanded(child: Center(child: Text("Search to find doctors.")))
        ],
      ),
    );
  }
}

// --- Helper extension for DoctorSearchResultInfo (optional) ---
extension DoctorInfoExtension on DoctorSearchResultInfo {
  DoctorSearchResultInfo copyWith({
    String? doctorId,
    String? name,
    String? profileImageUrl,
    bool? isCurrentlyLinkedToThisDoctor,
  }) {
    return DoctorSearchResultInfo(
      doctorId: doctorId ?? this.doctorId,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isCurrentlyLinkedToThisDoctor: isCurrentlyLinkedToThisDoctor ??
          this.isCurrentlyLinkedToThisDoctor,
    );
  }
}