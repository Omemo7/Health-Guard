import 'package:flutter/foundation.dart';

@immutable
class VitalDataPoint {
  final DateTime date;
  final double value;

  const VitalDataPoint(this.date, this.value);
}