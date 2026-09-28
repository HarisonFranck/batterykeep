// ignore_for_file: unnecessary_string_interpolations

import 'package:batterykeep/features/battery_monitor/domain/entities/battery_info.dart';
import 'package:flutter/material.dart';

class ContainerBatteryStats extends StatelessWidget {
  const ContainerBatteryStats({
    super.key,
    required this.height,
    required this.width,
    required this.bat,
  });

  final double height;
  final double width;
  final BatteryInfo bat;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height / 3.4,

      child: Padding(
        padding: const EdgeInsets.only(left: 45.0, right: 45),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          spacing: 20,
          children: [
            Expanded(
              child: Container(
                height: double.infinity,

                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 26, 30, 38),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromARGB(20, 255, 255, 255),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  spacing: 10,
                  children: [
                    SizedBox(
                      width: width * 0.085,
                      height: width * 0.085,
                      //color: Colors.grey,
                      child: Stack(
                        fit: StackFit.expand,
                        alignment: AlignmentGeometry.center,
                        children: [
                          CircularProgressIndicator(
                            strokeWidth: 10,

                            value: (bat.percentage ?? 0) / 100,
                            color: (bat.percentage > 35)
                                ? Colors.green
                                : (bat.percentage > 20 && bat.percentage <= 35)
                                ? const Color.fromARGB(255, 238, 194, 61)
                                : const Color.fromARGB(255, 186, 85, 85),
                            strokeCap: StrokeCap.round,
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Text(
                                  "${bat.percentage}%",
                                  style: TextStyle(
                                    fontSize: width * 0.018,
                                    color: const Color.fromARGB(
                                      255,
                                      255,
                                      255,
                                      255,
                                    ),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Icon(
                                  Icons.flash_on_outlined,
                                  size: 28,
                                  color: (bat.percentage > 35)
                                      ? Colors.green
                                      : (bat.percentage > 20 &&
                                            bat.percentage <= 35)
                                      ? const Color.fromARGB(255, 238, 194, 61)
                                      : const Color.fromARGB(255, 186, 85, 85),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: double.infinity,
                      width: width * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 60,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Niveau de batterie",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  spacing: 10,
                                  children: [
                                    Icon(
                                      Icons.charging_station_rounded,
                                      color: Colors.green,
                                      size: 15,
                                    ),
                                    Text(
                                      (bat.isPluggedIn)
                                          ? "En charge (secteur)"
                                          : "Sur Batterie",
                                      style: TextStyle(
                                        color: const Color.fromARGB(
                                          255,
                                          16,
                                          198,
                                          110,
                                        ),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 35, 40, 51),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: const Color.fromARGB(255, 35, 40, 51),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 15.0,
                                top: 15,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 20,
                                children: [
                                  Icon(
                                    Icons.eco_rounded,
                                    color: Colors.green,
                                    size: 30,
                                  ),
                                  Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      spacing: 10,
                                      children: [
                                        Text(
                                          bat.health ?? 'N/A',
                                          style: TextStyle(
                                            color: const Color.fromARGB(
                                              255,
                                              80,
                                              197,
                                              84,
                                            ),
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SizedBox(
                                          width: width * 0.2,
                                          child: Text(
                                            (bat.isPluggedIn)
                                                ? (bat.percentage >= 80)
                                                      ? "Votre batterie a fait le plein d'énergie ! En la débranchant avant les 100%, vous prolongez activement sa longévité au quotidien."
                                                      : "Charge en cours. Laissez votre Mac branché pour atteindre sereinement votre niveau d'autonomie."
                                                : (bat.percentage <= 30)
                                                ? "Pour preserver la santé de votre batterie, il serait mieux de le brancher au moins dans les 25%."
                                                : "Votre Mac fonctionne sur batterie. Profitez pleinement de votre autonomie en toute liberté.",
                                            style: TextStyle(
                                              color: const Color.fromARGB(
                                                255,
                                                255,
                                                255,
                                                255,
                                              ),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w400,
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
                          Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Container(
                                            width: 26,
                                            height: 26,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                              color: Colors.white12,
                                            ),
                                            child: Icon(
                                              Icons.access_time_outlined,
                                              color: const Color.fromARGB(
                                                255,
                                                232,
                                                231,
                                                231,
                                              ),
                                              size: 18,
                                            ),
                                          ),
                                          Text(
                                            (bat.isPluggedIn)
                                                ? bat.timeToFullStr ?? 'N/A'
                                                : bat.timeToEmptyStr ?? 'N/A',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                255,
                                                232,
                                                231,
                                                231,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Temps restants",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  color: const Color.fromARGB(
                                    105,
                                    255,
                                    255,
                                    255,
                                  ),
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Container(
                                            width: 26,
                                            height: 26,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                              color: Colors.white12,
                                            ),
                                            child: Icon(
                                              Icons.power_outlined,
                                              color: const Color.fromARGB(
                                                255,
                                                232,
                                                231,
                                                231,
                                              ),
                                              size: 18,
                                            ),
                                          ),
                                          Text(
                                            (bat.isPluggedIn)
                                                ? "${bat.chargerWattage.toStringAsFixed(0)} W"
                                                : "${bat.liveWattage.toStringAsFixed(0)} W",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                255,
                                                232,
                                                231,
                                                231,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Puissance",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                VerticalDivider(
                                  color: const Color.fromARGB(
                                    105,
                                    255,
                                    255,
                                    255,
                                  ),
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Row(
                                        spacing: 10,
                                        children: [
                                          Container(
                                            width: 26,
                                            height: 26,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(26),
                                              color: Colors.white12,
                                            ),
                                            child: Icon(
                                              Icons.thermostat,
                                              color: const Color.fromARGB(
                                                255,
                                                232,
                                                231,
                                                231,
                                              ),
                                              size: 18,
                                            ),
                                          ),
                                          Text(
                                            "${bat.temperature ?? 0}°C",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                255,
                                                232,
                                                231,
                                                231,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "Température",
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
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: width * 0.27,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentGeometry.topCenter,
                  end: AlignmentGeometry.bottomCenter,
                  colors: (bat.health == "Révision conseillée")
                      ? [
                          const Color.fromARGB(48, 232, 26, 26),
                          const Color.fromARGB(95, 0, 0, 0),
                        ]
                      : (bat.health == "Capacité en baisse")
                      ? [
                          const Color.fromARGB(255, 243, 194, 32),
                          const Color.fromARGB(95, 0, 0, 0),
                        ]
                      : [
                          const Color.fromARGB(48, 76, 175, 101),
                          const Color.fromARGB(95, 0, 0, 0),
                        ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 25,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(28, 76, 175, 79),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.lightbulb_outline,
                              color: (bat.health == "Révision conseillée")
                                  ? const Color.fromARGB(255, 186, 85, 85)
                                  : (bat.health == "Capacité en baisse")
                                  ? const Color.fromARGB(255, 232, 206, 40)
                                  : const Color.fromARGB(255, 96, 203, 100),
                              size: 26,
                            ),
                          ),
                          Text(
                            "Suggestion !",
                            style: TextStyle(
                              color: (bat.health == "Révision conseillée")
                                  ? const Color.fromARGB(255, 186, 85, 85)
                                  : (bat.health == "Capacité en baisse")
                                  ? const Color.fromARGB(255, 232, 206, 40)
                                  : const Color.fromARGB(255, 96, 203, 100),
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Text(
                        "${bat.chargeAdviceMessage}",
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),

                    Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                        color: (bat.health == "Révision conseillée")
                            ? const Color.fromARGB(255, 186, 85, 85)
                            : (bat.health == "Capacité en baisse")
                            ? const Color.fromARGB(255, 232, 206, 40)
                            : const Color.fromARGB(255, 52, 149, 56),

                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 5,
                            children: [
                              Text(
                                (bat.isPluggedIn)
                                    ? "J'ai débranché le chargeur"
                                    : "Checker des réparateurs à proximité",
                                style: TextStyle(
                                  color: const Color.fromARGB(
                                    255,
                                    255,
                                    255,
                                    255,
                                  ),
                                  fontSize: 14,
                                ),
                              ),
                              Icon(Icons.check, color: Colors.white),
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
    );
  }
}
