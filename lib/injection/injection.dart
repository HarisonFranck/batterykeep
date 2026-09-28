import 'package:batterykeep/core/services/BatteryHistoryService.dart';
import 'package:batterykeep/features/battery_monitor/data/datasources/mac_battery_datasource.dart';
import 'package:batterykeep/features/battery_monitor/domain/repositories/battery_repository.dart';
import 'package:batterykeep/features/battery_monitor/domain/repositories/battery_repository_impl.dart';
import 'package:batterykeep/features/battery_monitor/domain/usecases/get_battery_data.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => MacBatteryDatasource());

  sl.registerLazySingleton<BatteryRepository>(
    () => BatteryRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => GetBatteryData(sl()));
  sl.registerLazySingleton(() => BatteryHistoryService());
}
