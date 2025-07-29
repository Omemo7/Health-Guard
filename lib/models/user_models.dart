// lib/models/user_models.dart
import 'package:flutter/foundation.dart'; // For @immutable


@immutable
class PatientBasicInfo {
  final String id;
  final String name;
  final String? profileImageUrl;
  final String lastActivity;
  // This field stores the relationship of the entity contextually viewing this info
  // TO the person represented by this PatientBasicInfo.
  // - For FamilyMemberScreen: It's the relationship of the logged-in family member
  //   TO this listed person (e.g., "Mother", "Son").
  // - For DoctorScreen: It can default to "Patient" or be unused/hidden
  //   as the doctor-patient relationship is implicit.
  final String relationship;

  const PatientBasicInfo({
    required this.id,
    required this.name,
    this.profileImageUrl,
    required this.lastActivity,
    // When creating an instance for a doctor's patient list,
    // you might not explicitly pass 'relationship', so it defaults.
    // When creating for a family member's list, you MUST pass the
    // specific relationship of the logged-in user TO this person.
    this.relationship = "Patient", // Default value
  });
}


@immutable
class DoctorSearchResultInfo {
  final String doctorId;
  final String name; // Just "Dr. Name"
  final String? profileImageUrl; // Optional
  // 'isAlreadyLinked' here means "is this the doctor the patient is CURRENTLY linked to"
  final bool isCurrentlyLinkedToThisDoctor;

  const DoctorSearchResultInfo({
    required this.doctorId,
    required this.name,
    this.profileImageUrl,
    this.isCurrentlyLinkedToThisDoctor = false,
  });
}


@immutable
class FamilyMember {
  final String id;
  final String name;
  final String relationship; // e.g., "Spouse", "Child", "Parent"
  final DateTime? dateOfBirth; // Optional
  final String? profileImageUrl; // Optional

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    this.dateOfBirth,
    this.profileImageUrl,
  });

  // Optional: Calculated age
  int? get age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    int age = now.year - dateOfBirth!.year;
    if (now.month < dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day < dateOfBirth!.day)) {
      age--;
    }
    return age;
  }

  FamilyMember copyWith({
    String? id,
    String? name,
    String? relationship,
    DateTime? dateOfBirth,
    String? profileImageUrl,
    bool clearDateOfBirth = false, // To explicitly set dateOfBirth to null
    bool clearProfileImageUrl = false,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      relationship: relationship ?? this.relationship,
      dateOfBirth: clearDateOfBirth ? null : (dateOfBirth ?? this.dateOfBirth),
      profileImageUrl: clearProfileImageUrl ? null : (profileImageUrl ??
          this.profileImageUrl),
    );
  }
}

