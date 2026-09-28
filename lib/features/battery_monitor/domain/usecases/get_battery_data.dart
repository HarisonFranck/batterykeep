import 'package:batterykeep/features/battery_monitor/domain/entities/battery_info.dart';
import 'package:batterykeep/features/battery_monitor/domain/repositories/battery_repository.dart';

class GetBatteryData {
  GetBatteryData(this.batteryRepository);

  final BatteryRepository batteryRepository;

  Future<BatteryInfo> call() {
    return batteryRepository.getBatteryFullInfo();
  }
}
