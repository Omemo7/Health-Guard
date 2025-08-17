import 'package:flutter/foundation.dart'; // For @immutable


@immutable
class PatientBasicInfo {
  final String id;
  final String name;
  final String? profileImageUrl;
  final String lastActivity;
  final int age; // Added age
  final String gender; // Added gender

  final String relationship;

  const PatientBasicInfo({
    required this.id,
    required this.name,
    this.profileImageUrl,
    required this.lastActivity,
    required this.age, // Added age
    required this.gender, // Added gender

    this.relationship = "Patient",
  });
}
