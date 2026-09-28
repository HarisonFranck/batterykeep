import 'package:batterykeep/components/FooterIndice.dart';
import 'package:flutter/material.dart';

class FotterBatteryStats extends StatelessWidget {
  const FotterBatteryStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        bottom: 20,
        left: 25,
        right: 25,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(66, 47, 46, 58),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: 20,
            left: 10,
            right: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FooterIndice(
                icon: Icons.person_outline_outlined,
                title: "Profil actif",
                statut: "Équilibré",
                description: "Optimisation quotidienne",
                color: Colors.green,
              ),
              VerticalDivider(
                indent: 15,
                endIndent: 15,
                color: const Color.fromARGB(43, 255, 255, 255),
              ),
              FooterIndice(
                icon: Icons.notifications_outlined,
                title: "Prochaine alerte",
                statut: "20%",
                description: "Alerte batterie faible",
                color: const Color.fromARGB(255, 183, 113, 21),
              ),
              VerticalDivider(
                indent: 15,
                endIndent: 15,
                color: const Color.fromARGB(43, 255, 255, 255),
              ),
              FooterIndice(
                icon: Icons.power_outlined,
                title: "Débranché à",
                statut: "85%",
                description: "Alerte de débranchement",
                color: Colors.green,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(42, 255, 255, 255),
                    ),
                    borderRadius: BorderRadius.circular(15),
                    color: const Color.fromARGB(66, 57, 56, 70),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 13.0,
                      bottom: 13,
                      left: 17,
                      right: 17,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.settings_outlined,
                          color: const Color.fromARGB(215, 255, 255, 255),
                          size: 18,
                        ),
                        Text(
                          "Voir tous les réglages",
                          style: TextStyle(
                            color: const Color.fromARGB(215, 255, 255, 255),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
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
