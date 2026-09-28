import 'package:batterykeep/features/battery_monitor/data/datasources/mac_battery_datasource.dart';
import 'package:batterykeep/features/battery_monitor/domain/entities/battery_info.dart';
import 'package:batterykeep/features/battery_monitor/domain/repositories/battery_repository.dart';

class BatteryRepositoryImpl implements BatteryRepository {
  final MacBatteryDatasource datasource;

  BatteryRepositoryImpl(this.datasource);

  @override
  Future<BatteryInfo> getBatteryFullInfo() {
    return datasource.getBatteryFullInfo();
  }
}
