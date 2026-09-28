import 'package:batterykeep/features/battery_monitor/domain/entities/battery_info.dart';

class BatteryInfoModel extends BatteryInfo {
  BatteryInfoModel({
    required super.percentage,
    required super.isPluggedIn,
    required super.isCharging,
    required super.cycleCount,
    required super.temperature,
    required super.health,
    required super.currentCapacity,
    required super.maxCapacity,
    required super.timeToEmpty,
    required super.timeToFull,
    required super.powerSourceState,
    required super.batteryName,
    required super.timeToEmptyStr,
    required super.timeToFullStr,
    required super.chargerWattage,
    required super.liveWattage,
    required super.healthDescription,
    required super.manufactureDate,
    required super.healthPercentage,
    required super.shouldUnplug,
    required super.chargeAdviceMessage,
  });

  factory BatteryInfoModel.fromMap(Map<String, dynamic> map) {
    final isCharging = map["isCharging"] as bool? ?? false;
    final powerState = map["powerSourceState"] as String? ?? "Unknown";

    return BatteryInfoModel(
      percentage: map["percentage"] as int? ?? 0,
      isPluggedIn: isCharging || powerState.contains("AC"),
      isCharging: isCharging,
      cycleCount: map["cycleCount"] as int? ?? 0,
      temperature: map["temperature"] as int? ?? 0,
      health: map["health"] as String? ?? "Unknown",
      currentCapacity: map["currentCapacity"] as int? ?? 0,
      maxCapacity: map["maxCapacity"] as int? ?? 0,
      timeToEmpty: map["timeToEmpty"] as int? ?? -1,
      timeToFull: map["timeToFull"] as int? ?? -1,
      powerSourceState: powerState,
      batteryName: map["name"] as String? ?? "Battery",

      timeToEmptyStr: map["timeToEmptyFormatted"] as String? ?? "--h --min",
      timeToFullStr: map["timeToFullFormatted"] as String? ?? "--h --min",

      chargerWattage: map["chargerWattage"] as int? ?? 0,
      liveWattage: (map["liveWattage"] as num?)?.toDouble() ?? 0.0,

      healthDescription:
          map["healthDescription"] as String? ??
          "Impossible de lire l'état de la batterie de ce Mac.",
      manufactureDate: map["manufactureDate"] as String? ?? "N/A",
      healthPercentage: map["healthPercentage"] as int? ?? 0,

      shouldUnplug: map["shouldUnplug"] as bool? ?? false,
      chargeAdviceMessage:
          map["chargeAdviceMessage"] as String? ??
          "Pour préserver la santé de votre batterie, il serait mieux de la brancher au moins dans les 20%.",
    );
  }
}
