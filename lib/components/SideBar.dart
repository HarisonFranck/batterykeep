import 'package:batterykeep/components/NavSide.dart';
import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.17,
      height: height,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 15, 18, 26),
        borderRadius: BorderRadius.circular(10),
        border: Border(
          right: BorderSide(color: const Color.fromARGB(125, 72, 72, 72)),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          SizedBox(
            height: 130,
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  spacing: 5,
                  children: [
                    SizedBox(width: 10),
                    Image.asset(
                      "assets/images/batterykeept.png",
                      width: 60,
                      height: 60,
                      fit: BoxFit.fitWidth,
                    ),
                    Text(
                      "BatteryKeep",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 35),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 10),
                        children: <InlineSpan>[
                          TextSpan(
                            text: "POWER SMART. ",
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2,
                            ),
                          ),
                          TextSpan(
                            text: "KEEP LONGER",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: height / 1.6,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  NavSide(
                    title: "Accueil",
                    index: index,
                    myIndexed: 0,
                    icon: Icons.house_outlined,
                    tap: () {
                      setState(() {
                        index = 0;
                      });
                    },
                  ),
                  NavSide(
                    title: "Batterie",
                    index: index,
                    myIndexed: 1,
                    icon: Icons.battery_charging_full,
                    tap: () {
                      setState(() {
                        index = 1;
                      });
                    },
                  ),
                  NavSide(
                    title: "Historique",
                    index: index,
                    myIndexed: 2,
                    icon: Icons.history_outlined,
                    tap: () {
                      setState(() {
                        index = 2;
                      });
                    },
                  ),
                  NavSide(
                    title: "Santé",
                    index: index,
                    myIndexed: 3,
                    tap: () {
                      setState(() {
                        index = 3;
                      });
                    },
                    icon: Icons.favorite_outline_outlined,
                  ),
                  NavSide(
                    title: "Réglages",
                    index: index,
                    myIndexed: 4,
                    tap: () {
                      setState(() {
                        index = 4;
                      });
                    },
                    icon: Icons.settings_outlined,
                  ),
                  NavSide(
                    title: "Notifications",
                    index: index,
                    myIndexed: 5,
                    tap: () {
                      setState(() {
                        index = 5;
                      });
                    },
                    icon: Icons.notifications_outlined,
                  ),
                  NavSide(
                    title: "A propos",
                    index: index,
                    myIndexed: 6,
                    tap: () {
                      setState(() {
                        index = 6;
                      });
                    },
                    icon: Icons.info_outlined,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color.fromARGB(51, 255, 255, 255),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: [
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        "Application active",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 255, 254, 254),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.desktop_mac_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      Text(
                        "En arrière-plan",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
