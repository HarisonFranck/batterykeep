import 'package:batterykeep/core/services/BatteryHistoryService.dart';
import 'package:batterykeep/features/battery_monitor/presentation/Home.dart';
import 'package:batterykeep/injection/injection.dart' as inject;
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    debugPrint("MAIN");
    await inject.init();
    print("✅ Injection setup réussi");
  } catch (e) {
    print("❌ Erreur injection: $e");
    rethrow;
  }
  await inject.sl<BatteryHistoryService>().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BatteryKeep',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
    );
  }
}
