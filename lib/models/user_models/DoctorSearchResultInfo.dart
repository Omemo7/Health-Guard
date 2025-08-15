import 'package:flutter/foundation.dart';

@immutable
class DoctorSearchResultInfo {
  final String doctorId;
  final String name;
  final String? profileImageUrl;
  final bool isCurrentlyLinkedToThisDoctor;

  const DoctorSearchResultInfo({
    required this.doctorId,
    required this.name,
    this.profileImageUrl,
    this.isCurrentlyLinkedToThisDoctor = false,
  });
}
