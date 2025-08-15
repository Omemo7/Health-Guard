import 'package:flutter/foundation.dart';

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

