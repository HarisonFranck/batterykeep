class BatterySample {
  final DateTime timestamp;
  final bool isCharging;
  final int percentage;
  final bool isPluggedIn;

  BatterySample({
    required this.timestamp,
    required this.isCharging,
    required this.isPluggedIn,
    required this.percentage,
  });

  factory BatterySample.fromRow(Map<String, Object?> row) {
    return BatterySample(
      timestamp: DateTime.fromMillisecondsSinceEpoch(row["timestamp"] as int),
      isCharging: (row["is_charging"] != null)
          ? (row["is_charging"] as int) == 1
          : false,
      isPluggedIn: (row["is_plugged_in"] != null)
          ? (row["is_plugged_in"] as int) == 1
          : false,
      percentage: row["percentage"] as int,
    );
  }
}
