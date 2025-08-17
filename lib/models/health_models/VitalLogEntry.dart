
enum VitalType {
  heartRate,
  bloodPressureSystolic,
  bloodPressureDiastolic,
  bloodOxygen,
  temperature
}


String vitalTypeToString(VitalType type,
    {bool short = false, bool includeUnit = false}) {
  String baseName;
  String unit = getVitalUnit(type);

  switch (type) {
    case VitalType.heartRate:
      baseName = short ? "HR" : "Heart Rate";
      break;
    case VitalType.bloodPressureSystolic:
      baseName = short ? "Systolic" : "Systolic BP";
      break;
    case VitalType.bloodPressureDiastolic:
      baseName = short ? "Diastolic" : "Diastolic BP";
      break;
    case VitalType.bloodOxygen:
      baseName = short ? "SpO2" : "Blood Oxygen";
      break;
    case VitalType.temperature:
      baseName = short ? "Temp" : "Temperature";
      break;
  }
  return includeUnit && unit.isNotEmpty ? "$baseName ($unit)" : baseName;
}

String getVitalUnit(VitalType type) {
  switch (type) {
    case VitalType.heartRate:
      return "bpm";
    case VitalType.bloodPressureSystolic:
    case VitalType.bloodPressureDiastolic:
      return "mmHg";
    case VitalType.bloodOxygen:
      return "%";
    case VitalType.temperature:
      return "°C";
    default:
      return "";
  }
}



class VitalLogEntry {
  final String id;
  final DateTime timestamp;
  final Map<VitalType, double> readings;
  final String? notes;

  const VitalLogEntry({
    required this.id,
    required this.timestamp,
    required this.readings,
    this.notes,
  });

  VitalLogEntry copyWith({
    String? id,
    DateTime? timestamp,
    Map<VitalType, double>? readings,
    String? notes,
    bool clearNotes = false,
  }) {
    return VitalLogEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      readings: readings ?? this.readings,
      notes: clearNotes ? null : (notes ?? this.notes),
    );
  }
}
