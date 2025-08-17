// models/user_models/doctor.dart
class Doctor {
  final String id;
  String name;
  String specialty;
  bool isVerified;
  String email;
  String? profileImageUrl;

  // Add other relevant fields

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.isVerified,
    required this.email,
    this.profileImageUrl,
  });

  // Optional: Factory constructor for JSON deserialization
  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as String,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      isVerified: json['isVerified'] as bool,
      email: json['email'] as String,
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  // Optional: Method for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'isVerified': isVerified,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }
}
