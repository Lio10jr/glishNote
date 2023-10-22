import 'package:fastenglish/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable, camel_case_types
class textScan extends StatefulWidget {
  String texto;
  textScan({Key? key, required this.texto}) : super(key: key);

  @override
  State<textScan> createState() => _textScanState();
}

// ignore: camel_case_types
class _textScanState extends State<textScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
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
                  'Texto Reconocido',
                  style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: ColorsConsts.white),
                ),
                if (!widget.texto.isEmpty)
                  IconButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.texto));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Copiado con exito!",
                          style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: ColorsConsts.white),
                        ),
                        backgroundColor: ColorsConsts.msgValidbackground,
                      ));
                  },
                  icon: Icon(
                    Icons.copy_rounded,
                    color: ColorsConsts.white,
                  ),
                ),
                if (widget.texto.isEmpty)
                  Icon(
                      Icons.mood_bad,
                      color: ColorsConsts.white,
                    ),                
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(20),
                child: widget.texto.isNotEmpty
                    ? Text(
                        widget.texto,
                        style: GoogleFonts.ubuntu(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: ColorsConsts.black),
                      )
                    : Text(
                        "La imagen no contiene texto válido o la imagen no esta muy clara!",
                        style: GoogleFonts.ubuntu(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: ColorsConsts.black),
                      ))));
  }
}
