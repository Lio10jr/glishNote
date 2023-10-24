import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class text_title extends StatelessWidget {
  final String titulo;
  final double size;
  final FontWeight fontw;
  final Color color;

  const text_title({Key? key, 
    required this.titulo,
    required this.size,
    required this.fontw,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      titulo,
      style:
          GoogleFonts.ubuntu(fontSize: size, fontWeight: fontw, color: color),
    );
  }
}