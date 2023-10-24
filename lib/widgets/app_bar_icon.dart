import 'package:fastenglish/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class app_bar_icon extends StatelessWidget {
  final String title;
  final IconData icon;

  const app_bar_icon({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        color: ColorsConsts.primarybackground,
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(30.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            color: ColorsConsts.white,
          ),
          Text(
            title,
            style: GoogleFonts.ubuntu(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: ColorsConsts.white),
          ),
          IconButton(
            onPressed: () {
              
            },
            icon: Icon(
              icon,
              color: ColorsConsts.white,
            ),
          ),
                          
        ],
      ),
    );
  }
}