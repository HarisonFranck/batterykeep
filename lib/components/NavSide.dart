import 'package:flutter/material.dart';

class NavSide extends StatefulWidget {
  NavSide({
    super.key,
    required this.title,
    required this.myIndexed,
    required this.icon,
    required this.tap,
    required this.index,
  });

  String title;
  int myIndexed;
  IconData icon;
  int index;
  Function() tap;

  @override
  State<NavSide> createState() => _NavSideState();
}

class _NavSideState extends State<NavSide> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.tap,
          child: Container(
            height: 45,

            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              gradient: (widget.myIndexed == widget.index)
                  ? LinearGradient(
                      colors: [
                        const Color.fromARGB(255, 86, 139, 114),
                        const Color.fromARGB(255, 50, 74, 63),
                      ],
                    )
                  : LinearGradient(
                      colors: [Colors.transparent, Colors.transparent],
                    ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,

              spacing: 20,
              children: [
                SizedBox(width: 2),
                Icon(
                  widget.icon,
                  color: const Color.fromARGB(255, 184, 184, 184),
                ),
                Text(
                  textAlign: TextAlign.center,
                  widget.title,
                  style: TextStyle(
                    color: (widget.myIndexed == widget.index)
                        ? Colors.white
                        : const Color.fromARGB(200, 184, 184, 184),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
