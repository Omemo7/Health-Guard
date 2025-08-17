
class FamilyMember {
  final String id;
  final String name;
  final String relationship;
  final DateTime? dateOfBirth;
  final String? profileImageUrl;

  const FamilyMember({
    required this.id,
    required this.name,
    required this.relationship,
    this.dateOfBirth,
    this.profileImageUrl,
  });


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

}

