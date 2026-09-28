import 'package:batterykeep/features/battery_monitor/domain/entities/battery_info.dart';

abstract class BatteryRepository {
  Future<BatteryInfo> getBatteryFullInfo();
}
