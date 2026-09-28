import 'package:flutter/material.dart';

class FooterIndice extends StatefulWidget {
  FooterIndice({
    super.key,
    required this.icon,
    required this.title,
    required this.statut,
    required this.description,
    required this.color,
  });

  IconData icon;
  String title;
  String statut;
  String description;
  Color color;

  @override
  State<FooterIndice> createState() => _FooterIndiceState();
}

class _FooterIndiceState extends State<FooterIndice> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 15,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color.fromARGB(73, 158, 158, 158),
              ),
            ),
            child: Icon(
              size: 15,
              widget.icon, //Icons.person_outline_outlined,
              color: const Color.fromARGB(126, 158, 158, 158),
            ),
          ),
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 7,
              children: [
                Text(
                  widget.title, //"Profil actif",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                Text(
                  widget.statut, //"Equilibré",
                  style: TextStyle(color: widget.color, fontSize: 14),
                ),
                Text(
                  widget.description, //"Optimisation quotidienne",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
