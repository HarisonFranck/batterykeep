import 'dart:async';

import 'package:batterykeep/components/BatteryHistoryChart.dart';
import 'package:batterykeep/core/services/BatteryHistoryService.dart';
import 'package:batterykeep/features/battery_monitor/data/models/BatterySample.dart';
import 'package:batterykeep/features/battery_monitor/domain/entities/battery_info.dart';
import 'package:flutter/material.dart';

class ContainerStats extends StatelessWidget {
  ContainerStats({
    super.key,
    required this.height,
    required this.width,
    required this.bat,
    required this.historySamples,
    required this.timeAbove80,
    required this.totalChargingTime,
    required this.OnChangement,
    required this.valeurSelectionnee,
    required this.mesOptions,
  });

  final double height;
  final double width;
  final BatteryInfo bat;
  final List<BatterySample> historySamples;
  final Duration totalChargingTime;
  final Duration timeAbove80;
  final ValueChanged<String?> OnChangement;
  final String valeurSelectionnee;
  final List<String> mesOptions;

  BatteryHistoryService batteryHistoryService = BatteryHistoryService();

  String formatDuration(Duration duration) {
    // Extrait les heures totales
    String hours = duration.inHours.toString().padLeft(2, '0');

    // Extrait le reste des minutes (entre 0 et 59)
    String minutes = duration.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    // Extrait le reste des secondes (entre 0 et 59)
    String seconds = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');

    return "${hours}h ${minutes}m"; // Résultat : "02:05:09"
  }

  String formatManufactureDate(String? isoDate) {
    if (isoDate == null) return 'N/A';
    final parts = isoDate.split('-');
    const mois = [
      '',
      'Jan.',
      'Fév.',
      'Mars',
      'Avr.',
      'Mai',
      'Juin',
      'Juil.',
      'Août',
      'Sept.',
      'Oct.',
      'Nov.',
      'Déc.',
    ];
    return '${mois[int.parse(parts[1])]} ${parts[0]}';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height / 2.25,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 20.0,
          left: 10,
          right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: width * 0.22,
              decoration: BoxDecoration(
                color: const Color.fromARGB(92, 35, 40, 51),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color.fromARGB(88, 35, 40, 51)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 15,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  spacing: 10,
                  children: [
                    Container(
                      height: 50,
                      //color: Colors.amberAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              //color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.favorite_outline_rounded,
                                    color: Colors.green,
                                    size: 17,
                                  ),
                                  Text(
                                    "Santé de la batterie",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green,

                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 80,
                              height: 35,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(145, 35, 40, 51),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  spacing: 5,
                                  children: [
                                    Text(
                                      "Détails",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      size: 13,
                                      color: const Color.fromARGB(
                                        255,
                                        255,
                                        255,
                                        255,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Column(
                          spacing: 10,
                          children: [
                            Container(
                              height: 50,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(width: 20),
                                      Text(
                                        "Capacité maximal",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        "${bat.healthPercentage.toString()}%",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                    ],
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      top: 5,
                                      bottom: 10,
                                      left: 20,
                                      right: 15,
                                    ),
                                    child: LinearProgressIndicator(
                                      backgroundColor: const Color.fromARGB(
                                        255,
                                        35,
                                        40,
                                        51,
                                      ),
                                      minHeight: 7,
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.green,
                                      value: bat.healthPercentage / 100,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 20),
                                  Text(
                                    "Capacité de conception",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "100%",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 20),
                                  Text(
                                    "Cycles de charges",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "${bat.cycleCount} cycles",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 20),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 20),
                                  Text(
                                    "Date de fabrication",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    formatManufactureDate(bat.manufactureDate),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 20),
                                  Text(
                                    "Etat",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        145,
                                        34,
                                        67,
                                        14,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color.fromARGB(
                                          31,
                                          255,
                                          255,
                                          255,
                                        ),
                                      ),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 5,
                                          bottom: 5,
                                          left: 11,
                                          right: 11,
                                        ),
                                        child: Text(
                                          bat.health,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: const Color.fromARGB(
                                              255,
                                              36,
                                              147,
                                              5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                      color: const Color.fromARGB(255, 35, 40, 51),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Container(
                        height: 55,
                        child: Center(
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 20),
                              Icon(
                                Icons.safety_check_outlined,
                                color: const Color.fromARGB(255, 34, 215, 70),
                                size: 26,
                              ),

                              Expanded(
                                child: Text(
                                  bat.healthDescription,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color.fromARGB(
                                      255,
                                      34,
                                      215,
                                      70,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: width * 0.22,
              decoration: BoxDecoration(
                color: const Color.fromARGB(92, 35, 40, 51),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color.fromARGB(88, 35, 40, 51)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15.0,
                  bottom: 15,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      //color: Colors.amberAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Container(
                              //color: Colors.blue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                spacing: 10,
                                children: [
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.area_chart_outlined,
                                    color: Colors.green,
                                    size: 17,
                                  ),
                                  Text(
                                    "Niveau de batterie(24h)",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,

                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 45,
                            width: 75,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(145, 35, 40, 51),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10,
                                top: 7,
                                bottom: 7,
                              ),
                              child: Center(
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: Color.fromARGB(
                                    255,
                                    16,
                                    19,
                                    27,
                                  ),
                                  decoration: InputDecoration(
                                    
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    ),
                                    isCollapsed: true,
                                    filled: false,
                                    labelStyle: TextStyle(color: Colors.white),
                                  ),
                                  key: ValueKey(valeurSelectionnee),
                                  icon: Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: Colors.white54,
                                    size: 15,
                                  ),
                                  items: mesOptions
                                      .map(
                                        (option) => DropdownMenuItem<String>(
                                          value: option,
                                          child: Text(
                                            option,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),

                                  initialValue: valeurSelectionnee,
                                  onChanged: OnChangement,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: BatteryHistoryChart(samples: historySamples),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Container(
                        height: 55,
                        child: Center(
                          child: Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(width: 20),

                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10.0,
                                    right: 10,
                                    top: 15,
                                  ),
                                  child: Row(
                                    spacing: 10,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          color: Colors.green,
                                        ),
                                      ),

                                      Text(
                                        "Sur Batterie",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(width: 10),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: width * 0.22,
              decoration: BoxDecoration(
                color: const Color.fromARGB(92, 35, 40, 51),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: const Color.fromARGB(88, 35, 40, 51)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 20.0,
                  left: 10,
                  right: 10,
                ),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      //color: Colors.amberAccent,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            //color: Colors.blue,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              spacing: 10,
                              children: [
                                SizedBox(width: 10),
                                Icon(
                                  Icons.flash_on_outlined,
                                  color: Colors.green,
                                  size: 17,
                                ),
                                Text(
                                  "Activité de charge aujourd'hui",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,

                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 20),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.blue,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.change_circle_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Durée totale en charge",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    formatDuration(totalChargingTime),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 20),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.timelapse_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Temps passé entre 80% et 100%",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    formatDuration(timeAbove80),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 20),
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: Color.fromARGB(255, 255, 183, 0),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.safety_check_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Meilleure plage de charge",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  Spacer(),

                                  Text(
                                    "20% - 80%",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Container(
                        height: 95,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white10),
                          color: const Color.fromARGB(137, 31, 33, 48),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 20),
                                Icon(
                                  Icons.star_border_sharp,
                                  color: const Color.fromARGB(255, 255, 183, 0),
                                  size: 18,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Conseil",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      183,
                                      0,
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 5, right: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(width: 20),
                                  Icon(
                                    Icons.tips_and_updates_outlined,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      183,
                                      0,
                                    ),
                                    size: 15,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      (bat.isPluggedIn)
                                          ? "Évitez de rester trop longtemps au-dessus de 90% pour prolonger la durée de vie de votre batterie."
                                          : "Évitez également de descendre trop souvent en dessous de 20% pour préserver l'autonomie de votre batterie. ",
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                ],
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
          ],
        ),
      ),
    );
  }
}
