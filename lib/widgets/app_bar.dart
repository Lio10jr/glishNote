import 'package:fastenglish/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class app_bar extends StatelessWidget {
  final String title;
  const app_bar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorsConsts.primarybackground,
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(30.0)),
      ),
      padding: const EdgeInsets.all(20.0),
      alignment: Alignment.bottomCenter,
      child: Text(
        title,
        style: GoogleFonts.ubuntu(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: ColorsConsts.white),
      ),
    );
  }
}