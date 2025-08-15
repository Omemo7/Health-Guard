import 'package:flutter/foundation.dart'; // For @immutable


@immutable
class PatientBasicInfo {
  final String id;
  final String name;
  final String? profileImageUrl;
  final String lastActivity;

  final String relationship;

  const PatientBasicInfo({
    required this.id,
    required this.name,
    this.profileImageUrl,
    required this.lastActivity,

    this.relationship = "Patient",
  });
}

