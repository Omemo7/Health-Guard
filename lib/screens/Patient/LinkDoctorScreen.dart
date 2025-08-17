import 'package:flutter/material.dart';
import 'dart:math';

import '../../models/user_models/DoctorSearchResultInfo.dart';
import 'DoctorDetailsScreen.dart';
String? _currentPatientLinkedDoctorId;

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
  ];
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
    _loadDummyDoctorSuggestions();
    if (_patientLinkedDoctorId != null) {
      _fetchLinkedDoctorDetails(_patientLinkedDoctorId!);
    }
  }

  void _loadDummyDoctorSuggestions() {
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
          profileImageUrl: null,
          isCurrentlyLinkedToThisDoctor: 'DOC2003' == _patientLinkedDoctorId),
    ];
    _updateDoctorLinkStatus(_patientLinkedDoctorId);
  }

  void _updateDoctorLinkStatus(String? linkedDoctorId) {
    _searchResults = _searchResults.map((doc) {
      return DoctorSearchResultInfo(
          doctorId: doc.doctorId,
          name: doc.name,
          profileImageUrl: doc.profileImageUrl,
          isCurrentlyLinkedToThisDoctor: doc.doctorId == linkedDoctorId,);
    }).toList();
    _dummyDoctorSuggestions = _dummyDoctorSuggestions.map((doc) {
      return DoctorSearchResultInfo(
          doctorId: doc.doctorId,
          name: doc.name,
          profileImageUrl: doc.profileImageUrl,
          isCurrentlyLinkedToThisDoctor: doc.doctorId == linkedDoctorId,);
    }).toList();
  }


  Future<void> _fetchLinkedDoctorDetails(String doctorId) async {
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
    if (query.isEmpty) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isLoading = false;
          _statusMessage = null;
          _updateDoctorLinkStatus(
              _patientLinkedDoctorId);
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
                  _patientLinkedDoctorId,
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
        _updateDoctorLinkStatus(_patientLinkedDoctorId);
      });
    }
  }

  Future<void> _sendLinkRequest(DoctorSearchResultInfo doctorToLink) async {
    if (mounted) {
      setState(() {
        _patientLinkedDoctorId = doctorToLink.doctorId;
        _currentPatientLinkedDoctorId = doctorToLink.doctorId;
        _currentlyLinkedDoctorDetails = DoctorSearchResultInfo(
            doctorId: doctorToLink.doctorId,
            name: doctorToLink.name,
            profileImageUrl: doctorToLink.profileImageUrl,
            isCurrentlyLinkedToThisDoctor: true,);
        _updateDoctorLinkStatus(doctorToLink.doctorId);

        _isLoading = false;
        _statusMessage = "Successfully linked with ${doctorToLink.name}.";
        _searchController.clear();
        _searchQuery = "";
        _searchResults = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully linked with ${doctorToLink.name}.'),
          backgroundColor: Colors.green,
        ),
      );
      _navigateToDoctorDetail(DoctorSearchResultInfo(
          doctorId: doctorToLink.doctorId,
          name: doctorToLink.name,
          profileImageUrl: doctorToLink.profileImageUrl,
          isCurrentlyLinkedToThisDoctor: true,));
    } else if (mounted) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Could not link with ${doctorToLink.name}. Please try again.";
      });
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not link with ${doctorToLink.name}. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _unlinkCurrentDoctor() async {
    if (!mounted) return;
    final String doctorNameToDisplay = _currentlyLinkedDoctorDetails?.name ??
        "your doctor";

    bool unlinkSuccess = true;

    if (unlinkSuccess) {
      setState(() {
        _patientLinkedDoctorId = null;
        _currentPatientLinkedDoctorId = null;
        _currentlyLinkedDoctorDetails = null;
        _updateDoctorLinkStatus(null);

        _isLoading = false;
        _statusMessage = "Successfully unlinked from $doctorNameToDisplay.";
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully unlinked from $doctorNameToDisplay.'),
          backgroundColor: Colors.orange,
        ),
      );
    } else {
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
      _navigateToDoctorDetail(doctor);
      return;
    }
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
          .name}?';
      confirmButtonText = 'Switch & Link';
      onConfirm = () {
        Navigator.of(context).pop();
        _sendLinkRequest(doctor);
      };
    } else {
      title = 'Link with ${doctor.name}?';
      content = 'If you link with ${doctor
          .name}, they will be able to view your health data.\n\nDo you want to link with this doctor?';
      confirmButtonText = 'Link';
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
                Navigator.of(dialogContext).pop();
                _unlinkCurrentDoctor();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCurrentlyLinkedDoctorCard() {
    if (_isLoading && _currentlyLinkedDoctorDetails == null &&
        _patientLinkedDoctorId != null) {
      return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()));
    }
    if (_currentlyLinkedDoctorDetails == null) {
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
          .shrink();
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
      child: InkWell(
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
    Color foregroundColor;

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
            foregroundColor: foregroundColor,
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
                        '');
                  },
                )
                    : null,
              ),
              onChanged: (query) {
                _searchDoctors(query);
              },
            ),
          ),

          if (_isLoading && _searchResults.isEmpty &&
              _searchQuery.isNotEmpty)
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
              if (_searchQuery.isNotEmpty && !_isLoading)
                Expanded(
                  child: Center(
                    child: Text(_statusMessage ??
                        "No doctors found matching '$_searchQuery'. painstaking"),
                  ),
                )
              else
                if (showSuggestions && _dummyDoctorSuggestions.isNotEmpty &&
                    _currentlyLinkedDoctorDetails == null)
                  const SizedBox
                      .shrink()
                else
                  if (_statusMessage != null && _searchQuery.isEmpty &&
                      _searchResults.isEmpty &&
                      !showSuggestions)
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
