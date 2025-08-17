import 'package:flutter/material.dart';
import 'dart:math'; // For dummy data

// Import the new screen we will create
import '../../models/user_models/DoctorSearchResultInfo.dart';
import 'DoctorDetailsScreen.dart'; // Assuming you'll create this file
String? _currentPatientLinkedDoctorId; // Example: 'DOC1002' if linked
// In a real app, you'd fetch this when the patient's data is loaded.

class LinkDoctorScreen extends StatefulWidget {
  final String? initiallyLinkedDoctorId;

  const LinkDoctorScreen({super.key, this.initiallyLinkedDoctorId});

  @override
  State<LinkDoctorScreen> createState() => _LinkDoctorScreenState();
}

class _LinkDoctorScreenState extends State<LinkDoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DoctorSearchResultInfo> _searchResults = [];
  List<DoctorSearchResultInfo> _dummyDoctorSuggestions = [
  ]; // For predefined list
  bool _isLoading = false;
  String _searchQuery = "";
  String? _statusMessage;

  late String? _patientLinkedDoctorId;
  DoctorSearchResultInfo? _currentlyLinkedDoctorDetails;

  @override
  void initState() {
    super.initState();
    _patientLinkedDoctorId =
        widget.initiallyLinkedDoctorId ?? _currentPatientLinkedDoctorId;
    _loadDummyDoctorSuggestions(); // Load predefined suggestions
    if (_patientLinkedDoctorId != null) {
      _fetchLinkedDoctorDetails(_patientLinkedDoctorId!);
    }
  }

  void _loadDummyDoctorSuggestions() {
    // Predefined list of doctors if no search is active
    // In a real app, this might come from a "suggested doctors" API endpoint
    _dummyDoctorSuggestions = [
      DoctorSearchResultInfo(
          doctorId: 'DOC2001',
          name: 'Dr. Emily Carter (Cardiologist)',
          profileImageUrl: 'https://i.pravatar.cc/150?u=DOC2001',
          isCurrentlyLinkedToThisDoctor: 'DOC2001' == _patientLinkedDoctorId),
      DoctorSearchResultInfo(
          doctorId: 'DOC2002',
          name: 'Dr. Ben Miller (Pediatrician)',
          profileImageUrl: 'https://i.pravatar.cc/150?u=DOC2002',
          isCurrentlyLinkedToThisDoctor: 'DOC2002' == _patientLinkedDoctorId),
      DoctorSearchResultInfo(
          doctorId: 'DOC2003',
          name: 'Dr. Olivia Green (Neurologist)',
          profileImageUrl: null, // Example with no image
          isCurrentlyLinkedToThisDoctor: 'DOC2003' == _patientLinkedDoctorId),
    ];
    // Ensure `isCurrentlyLinkedToThisDoctor` is updated if _patientLinkedDoctorId changes later
    _updateDoctorLinkStatus(_patientLinkedDoctorId);
  }

  void _updateDoctorLinkStatus(String? linkedDoctorId) {
    // Update both search results and dummy suggestions
    _searchResults = _searchResults.map((doc) {
      // Manually create a new instance as copyWith is not implemented
      return DoctorSearchResultInfo(
          doctorId: doc.doctorId,
          name: doc.name,
          profileImageUrl: doc.profileImageUrl,
          isCurrentlyLinkedToThisDoctor: doc.doctorId == linkedDoctorId,);
    }).toList();
    _dummyDoctorSuggestions = _dummyDoctorSuggestions.map((doc) {
      // Manually create a new instance
      return DoctorSearchResultInfo(
          doctorId: doc.doctorId,
          name: doc.name,
          profileImageUrl: doc.profileImageUrl,
          isCurrentlyLinkedToThisDoctor: doc.doctorId == linkedDoctorId,);
    }).toList();
  }


  Future<void> _fetchLinkedDoctorDetails(String doctorId) async {
    // ... (existing _fetchLinkedDoctorDetails code - no change needed here for now)
    // For simplicity, we'll assume the details fetched here are sufficient for _currentlyLinkedDoctorDetails
    // If _currentlyLinkedDoctorDetails is the one to navigate with, make sure it's robustly populated.
    if (mounted) setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 500));
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
          profileImageUrl: 'https://i.pravatar.cc/150?u=$doctorId',
          isCurrentlyLinkedToThisDoctor: true,
        );
        _updateDoctorLinkStatus(doctorId);
        _isLoading = false;
      });
    }
  }

  Future<void> _searchDoctors(String query) async {
    // ... (existing _searchDoctors method)
    // Make sure to call _updateDoctorLinkStatus if the search results might contain the currently linked doctor
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
          _statusMessage = null;
          _updateDoctorLinkStatus(
              _patientLinkedDoctorId); // Refresh link status on dummy list
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
    // ... (rest of your dummy search logic) ...
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
      int numberOfResults = random.nextInt(4) + 1;
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
              isCurrentlyLinkedToThisDoctor: docId ==
                  _patientLinkedDoctorId, // Ensure this is set
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
        _updateDoctorLinkStatus(_patientLinkedDoctorId); // Also update here
      });
    }
  }

  Future<void> _sendLinkRequest(DoctorSearchResultInfo doctorToLink) async {
    // On success:
    if (mounted) {
      setState(() {
        _patientLinkedDoctorId = doctorToLink.doctorId;
        _currentPatientLinkedDoctorId = doctorToLink.doctorId;
        // Manually create a new instance for _currentlyLinkedDoctorDetails
        _currentlyLinkedDoctorDetails = DoctorSearchResultInfo(
            doctorId: doctorToLink.doctorId,
            name: doctorToLink.name,
            profileImageUrl: doctorToLink.profileImageUrl,
            isCurrentlyLinkedToThisDoctor: true,);
        _updateDoctorLinkStatus(doctorToLink.doctorId); // Update all lists

        _isLoading = false;
        _statusMessage = "Successfully linked with ${doctorToLink.name}."; // Changed message
        _searchController.clear();
        _searchQuery = ""; // Clear search query to show suggestions or linked doctor card
        _searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully linked with ${doctorToLink.name}.'), // Changed message
          backgroundColor: Colors.green,
        ),
      );
      // Navigate to the doctor detail screen after successful linking
      _navigateToDoctorDetail(DoctorSearchResultInfo( // Manual "copyWith"
          doctorId: doctorToLink.doctorId,
          name: doctorToLink.name,
          profileImageUrl: doctorToLink.profileImageUrl,
          isCurrentlyLinkedToThisDoctor: true,));
    } else if (mounted) { // On failure
      setState(() {
        _isLoading = false;
        _statusMessage = "Could not link with ${doctorToLink.name}. Please try again.";
      });
       ScaffoldMessenger.of(context).showSnackBar( // Added SnackBar for failure
        SnackBar(
          content: Text('Could not link with ${doctorToLink.name}. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _unlinkCurrentDoctor() async {
    // ... (existing _unlinkCurrentDoctor logic)
    // On success:
    if (!mounted) return;
    final String doctorNameToDisplay = _currentlyLinkedDoctorDetails?.name ??
        "your doctor"; // Capture before nullifying

    // ... (your unlinking simulation) ...
    bool unlinkSuccess = true; // Simulate

    if (unlinkSuccess) {
      setState(() {
        _patientLinkedDoctorId = null;
        _currentPatientLinkedDoctorId = null;
        _currentlyLinkedDoctorDetails = null;
        _updateDoctorLinkStatus(null); // Update all lists

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
      // ... (rest of the method)
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

  void _navigateToDoctorDetail(DoctorSearchResultInfo doctor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DoctorDetailsScreen(doctorInfo: doctor),
      ),
    );
  }

  void _showLinkConfirmationDialog(DoctorSearchResultInfo doctor) {
    if (doctor.isCurrentlyLinkedToThisDoctor) {
      // If already linked, navigate to their detail screen instead of showing dialog
      _navigateToDoctorDetail(doctor);
      return;
    }
    // ... (rest of your existing _showLinkConfirmationDialog method)
    // The onConfirm should still call _sendLinkRequest(doctor);
    // _sendLinkRequest will then handle navigation on successful link.
    String title;
    String content;
    String confirmButtonText;
    VoidCallback onConfirm;

    if (_patientLinkedDoctorId != null &&
        _patientLinkedDoctorId != doctor.doctorId) {
      title = 'Switch to ${doctor.name}?';
      content =
      'You are currently linked with ${_currentlyLinkedDoctorDetails?.name ??
          "another doctor"}.\n\nIf you link with ${doctor
          .name}, your link with the previous doctor will be replaced.\n\nLink with ${doctor
          .name}?'; // Updated content
      confirmButtonText = 'Switch & Link'; // Updated button text
      onConfirm = () {
        Navigator.of(context).pop();
        _sendLinkRequest(doctor);
      };
    } else {
      title = 'Link with ${doctor.name}?';
      content = 'If you link with ${doctor
          .name}, they will be able to view your health data.\n\nDo you want to link with this doctor?'; // Updated content
      confirmButtonText = 'Link'; // Updated button text
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

    final doctorName = _currentlyLinkedDoctorDetails!.name;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Unlink from $doctorName?'),
          content: Text(
              'Are you sure you want to unlink from $doctorName? '
              'They will no longer be able to access your health data through this app.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Unlink'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                _unlinkCurrentDoctor(); // Proceed with unlinking
              },
            ),
          ],
        );
      },
    );
  }

  // ... (dispose method remains the same)

  Widget _buildCurrentlyLinkedDoctorCard() {
    if (_isLoading && _currentlyLinkedDoctorDetails == null &&
        _patientLinkedDoctorId != null) {
      // Show loading indicator only when fetching initial linked doctor details
      return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()));
    }
    if (_currentlyLinkedDoctorDetails == null) {
      // Show "Not Linked" message or suggested doctors if search is empty
      if (_searchQuery.isEmpty && _searchResults.isEmpty) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                "Suggested Doctors",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            if (_dummyDoctorSuggestions.isEmpty)
              const Center(child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("No doctor suggestions available."),
              ))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _dummyDoctorSuggestions.length,
                itemBuilder: (context, index) {
                  final doctor = _dummyDoctorSuggestions[index];
                  return _buildDoctorListItem(doctor);
                },
              ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
            ),
          ],
        );
      }
      return const SizedBox
          .shrink(); // Hide if searching and no results yet, or if search results will show
    }

    // Display the currently linked doctor
    final doctor = _currentlyLinkedDoctorDetails!;
    return Card(
      margin: const EdgeInsets.all(16.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme
          .of(context)
          .colorScheme
          .primaryContainer,
      child: InkWell( // Make the card tappable to navigate to detail screen
        onTap: () => _navigateToDoctorDetail(doctor),
        borderRadius: BorderRadius.circular(12),
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
                    child: doctor.profileImageUrl == null ? Text(
                        doctor.name.isNotEmpty ? doctor.name[0] : 'D') : null,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        "View Details & Reports ", style: TextStyle(color: Theme
                        .of(context)
                        .colorScheme
                        .primary)),
                    Icon(Icons.arrow_forward_ios, size: 16, color: Theme
                        .of(context)
                        .colorScheme
                        .primary),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorListItem(DoctorSearchResultInfo doctor) {
    String buttonText;
    VoidCallback onPressedAction;
    Color buttonColor;
    Color foregroundColor; // For text and icon color of the button

    bool isLinkedToThisDoc = doctor.doctorId == _patientLinkedDoctorId;

    if (isLinkedToThisDoc) {
      buttonText = 'View Details';
      onPressedAction = () => _navigateToDoctorDetail(DoctorSearchResultInfo( 
          doctorId: doctor.doctorId,
          name: doctor.name,
          profileImageUrl: doctor.profileImageUrl,
          isCurrentlyLinkedToThisDoctor: true,));
      buttonColor = Theme.of(context).colorScheme.primary;
      foregroundColor = Theme.of(context).colorScheme.onPrimary;
    } else {
      buttonText = 'Link';
      onPressedAction = () => _showLinkConfirmationDialog(doctor);
      buttonColor = Theme.of(context).colorScheme.secondary;
      foregroundColor = Theme.of(context).colorScheme.onSecondary;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: doctor.profileImageUrl != null ? NetworkImage(
              doctor.profileImageUrl!) : null,
          child: doctor.profileImageUrl == null ? Text(
              doctor.name.isNotEmpty ? doctor.name[0] : 'D') : null,
        ),
        title: Text(doctor.name),
        trailing: ElevatedButton(
          onPressed: onPressedAction,
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            foregroundColor: foregroundColor, // Ensure text color contrasts
          ),
          child: Text(buttonText),
        ),
        onTap: () {
          if (isLinkedToThisDoc) {
            _navigateToDoctorDetail(DoctorSearchResultInfo( 
                doctorId: doctor.doctorId,
                name: doctor.name,
                profileImageUrl: doctor.profileImageUrl,
                isCurrentlyLinkedToThisDoctor: true,));
          } else {
            _showLinkConfirmationDialog(doctor);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme
        .of(context)
        .textTheme;
    bool showSuggestions = _searchQuery.isEmpty && _searchResults.isEmpty &&
        _currentlyLinkedDoctorDetails == null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Link to a Doctor'),
      ),
      body: Column(
        children: <Widget>[
          _buildCurrentlyLinkedDoctorCard(),
          // Shows linked doctor or suggestions if not linked and not searching

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for doctors by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _searchDoctors(
                        ''); // Clear search results and show suggestions
                  },
                )
                    : null,
              ),
              onChanged: (query) {
                // You might want to debounce this in a real app
                _searchDoctors(query);
              },
            ),
          ),

          if (_isLoading && _searchResults.isEmpty &&
              _searchQuery.isNotEmpty) // Show loading indicator for search
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else
            if (_searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final doctor = _searchResults[index];
                    return _buildDoctorListItem(doctor);
                  },
                ),
              )
            else
              if (_searchQuery.isNotEmpty && !_isLoading) // No search results
                Expanded(
                  child: Center(
                    child: Text(_statusMessage ??
                        "No doctors found matching '$_searchQuery'. painstaking"),
                  ),
                )
              else
                if (showSuggestions && _dummyDoctorSuggestions.isNotEmpty &&
                    _currentlyLinkedDoctorDetails == null)
                // This case is now handled inside _buildCurrentlyLinkedDoctorCard when not linked
                // Or you can have a separate section if _buildCurrentlyLinkedDoctorCard only shows the "Not Linked" message
                  const SizedBox
                      .shrink() // Already shown above or covered by _buildCurrentlyLinkedDoctorCard's logic
                else
                  if (_statusMessage != null && _searchQuery.isEmpty &&
                      _searchResults.isEmpty &&
                      !showSuggestions) // E.g. "Link request sent"
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(child: Text(
                          _statusMessage!, style: textTheme.titleMedium,
                          textAlign: TextAlign.center)),
                    ),
        ],
      ),
    );
  }
}
