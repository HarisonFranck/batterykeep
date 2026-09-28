import 'dart:async';

import 'package:batterykeep/components/ContainerBatteryStats.dart';
import 'package:batterykeep/components/ContainerStats.dart';
import 'package:batterykeep/components/FotterBatteryStats.dart';
import 'package:batterykeep/components/SideBar.dart';
import 'package:batterykeep/core/services/BatteryHistoryService.dart';
import 'package:batterykeep/core/services/battery_event_service.dart';
import 'package:batterykeep/features/battery_monitor/data/models/BatterySample.dart';

import 'package:batterykeep/features/battery_monitor/domain/entities/battery_info.dart';
import 'package:batterykeep/features/battery_monitor/domain/usecases/get_battery_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../injection/injection.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;

  BatteryInfo? battery;
  bool isLoading = true;
  String? error;

  StreamSubscription? _batterySub;
  bool isBatteryLoading = false;
  Timer? _historyTimer;
  late final BatteryHistoryService _historyService;

  late final BatteryEventService _batteryEventService;

  Duration totalChargingTime = Duration.zero;
  Duration timeAbove80 = Duration.zero;

  String valeurFiltreActuel = "24h";

  Future<void> _loadChargeStats() async {
    final results = await Future.wait([
      _historyService.getTotalChargingTimeToday(),
      _historyService.getTimeInRangeToday(80, 100),
    ]);
    if (!mounted) return;
    setState(() {
      totalChargingTime = results[0];
      timeAbove80 = results[1];
    });
  }

  String tempsEcoule(DateTime dateEvenement) {
    final maintenant = DateTime.now();
    final difference = maintenant.difference(dateEvenement);

    if (difference.inMinutes < 1) {
      return "À l'instant";
    } else if (difference.inMinutes < 60) {
      return "Il y a ${difference.inMinutes} min";
    } else if (difference.inHours < 24) {
      return "Il y a ${difference.inHours} h";
    } else {
      // Affiche la date classique si cela dépasse 24 heures
      return DateFormat('dd/MM/yyyy').format(dateEvenement);
    }
  }

  List<BatterySample> historySamples = [];

  Future<void> _loadHistory() async {
    final samples = await _historyService.getLastHours(24);
    if (!mounted) return;
    setState(() => historySamples = samples);
  }

  Future<void> loadBattery() async {
    if (isBatteryLoading) return;
    isBatteryLoading = true;

    try {
      final getBatteryData = sl<GetBatteryData>();

      final result = await getBatteryData();

      if (!mounted) return;
      setState(() {
        battery = result;
        isLoading = false;
        error = null;
      });
    } catch (e, stack) {
      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    } finally {
      isBatteryLoading = false;
    }
  }

  @override
  void initState() {
    super.initState();
    _batteryEventService = BatteryEventService();
    _historyService = sl<BatteryHistoryService>();

    _batterySub = _batteryEventService.stream.listen((event) {
      loadBattery();
    });

    loadBattery();
    _loadHistory();
    _loadChargeStats();

    // Échantillonnage pour l'historique : 1x/minute, indépendant du stream 5s
    _historyTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      if (battery != null) {
        _historyService.addSample(
          percentage: battery!.percentage,
          isCharging: battery!.isCharging,
          isPluggedIn: battery!.isPluggedIn,
        );
        await _loadHistory();
      }
    });
  }

  @override
  void dispose() {
    _batterySub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    // ✅ VÉRIFICATION 1: Si loading
    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 14, 14, 14),
        body: Center(child: CircularProgressIndicator(color: Colors.blueGrey)),
      );
    }

    // ✅ VÉRIFICATION 2: Si erreur ou battery null
    if (battery == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 14, 14, 14),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Text(
                "Erreur: ${error ?? 'Impossible de récupérer les données de batterie'}",
                style: TextStyle(color: Colors.white, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: loadBattery, child: Text("Réessayer")),
            ],
          ),
        ),
      );
    }

    // ✅ VÉRIFICATION 3: Maintenant on peut afficher en sécurité
    final bat = battery!; // Force unwrap maintenant que c'est sûr

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 16, 19, 27),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 15,
            left: 20,
            right: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            spacing: 10,
            children: [
              Sidebar(),
              Container(
                width: width * 0.78,
                height: height,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 16, 19, 27),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 500,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        spacing: 5,
                                        children: [
                                          Text(
                                            "Bonjour",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 27,
                                              letterSpacing: 1.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Icon(
                                            Icons.waving_hand_outlined,
                                            color: const Color.fromARGB(
                                              255,
                                              255,
                                              222,
                                              8,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Voici un aperçu de l'état de votre batterie aujourd'hui.",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 350,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 290,
                                    child: Row(
                                      spacing: 15,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: double.infinity,
                                          child: Center(
                                            child: Icon(
                                              Icons
                                                  .check_circle_outline_outlined,
                                              color: Colors.green,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 250,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Surveillance active",
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                "Dernière mise à jour : ${tempsEcoule(DateTime.now())}",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 60,
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.notifications_on_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ContainerBatteryStats(
                                  height: height,
                                  width: width,
                                  bat: bat,
                                ),
                                ContainerStats(
                                  height: height,
                                  width: width,
                                  bat: bat,
                                  historySamples: historySamples,
                                  timeAbove80: timeAbove80,
                                  totalChargingTime: totalChargingTime,
                                  mesOptions: ["24h", "12h", "6h"],
                                  valeurSelectionnee: valeurFiltreActuel,
                                  OnChangement: (option) {
                                    valeurFiltreActuel = option!;
                                  },
                                ),
                                FotterBatteryStats(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
