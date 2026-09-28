import 'package:batterykeep/features/battery_monitor/data/models/battery_info_model.dart';
import 'package:flutter/services.dart';

class MacBatteryDatasource {
  static const MethodChannel _channel = MethodChannel(
    "com.example.mac_battery_full",
  );

  Future<BatteryInfoModel> getBatteryFullInfo() async {
    try {
      print("📱 Appel du channel Swift...");

      final result = await _channel.invokeMethod("getCompleteData");

      if (result == null) {
        throw Exception("Aucune donnée batterie reçue du système");
      }

      print("✅ Données reçues avec succès");

      return BatteryInfoModel.fromMap(Map<String, dynamic>.from(result));
    } on PlatformException catch (e) {
      print("❌ Erreur Platform: ${e.message}");
      throw Exception("Erreur: ${e.message}");
    } catch (e) {
      print("❌ Erreur datasource: $e");
      rethrow;
    }
  }
}
