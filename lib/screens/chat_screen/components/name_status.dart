import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NameActivity extends StatelessWidget {
  final String name;
  final String lastActive;

  const NameActivity({Key? key, required this.name, required this.lastActive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            textAlign: TextAlign.left,
            style: GoogleFonts.lato(
              fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (lastActive.toLowerCase().contains("active"))
                Container(
                  width: 5,
                  height: 5,
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              EasyRichText(
                lastActive,
                textAlign: TextAlign.left,
                defaultStyle: GoogleFonts.lato(
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize,
                  fontWeight: FontWeight.w400,
                  color: Colors.black.withOpacity(.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
