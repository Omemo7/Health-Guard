
class PatientBasicInfo {
  final String id;
  final String name;
  final String? profileImageUrl;
  final String lastActivity;
  final int age;
  final String gender;



  const PatientBasicInfo({
    required this.id,
    required this.name,
    this.profileImageUrl,
    required this.lastActivity,
    required this.age,
    required this.gender,


  });
}
