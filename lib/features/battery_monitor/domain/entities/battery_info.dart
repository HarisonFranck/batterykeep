class BatteryInfo {
  final int percentage;
  final bool isPluggedIn;
  final bool isCharging;
  final int cycleCount;
  final int temperature;
  final String health;
  final int currentCapacity;
  final int maxCapacity;
  final int timeToEmpty;
  final int timeToFull;
  final String powerSourceState;
  final String batteryName;
  final String timeToEmptyStr;
  final String timeToFullStr;
  final int chargerWattage;
  final double liveWattage;
  final String healthDescription;
  final String manufactureDate;
  final int healthPercentage; // ✅ int, pas String — corrigé
  final bool shouldUnplug; // ✅ NOUVEAU
  final String chargeAdviceMessage; // ✅ NOUVEAU

  BatteryInfo({
    required this.percentage,
    required this.isPluggedIn,
    required this.isCharging,
    required this.cycleCount,
    required this.temperature,
    required this.health,
    required this.currentCapacity,
    required this.maxCapacity,
    required this.timeToEmpty,
    required this.timeToFull,
    required this.powerSourceState,
    required this.batteryName,
    required this.timeToEmptyStr,
    required this.timeToFullStr,
    required this.chargerWattage,
    required this.liveWattage,
    required this.healthDescription,
    required this.manufactureDate,
    required this.healthPercentage,
    required this.shouldUnplug,
    required this.chargeAdviceMessage,
  });
}
