import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/widgets/titulo_icon.dart';
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
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(300.0),
          child: titulo_icon(
            titulo: "Aqui puedes ver el texto de tu imagen",
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(bottom: 20),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.purple,
                width: 1.5,
              ),
            ),
          ),
          child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: widget.texto.isNotEmpty
                      ? Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: widget.texto));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(
                                    "Copiado con exito!",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w300,
                                        color: ColorsConsts.white),
                                  ),
                                  backgroundColor:
                                      ColorsConsts.msgValidbackground,
                                ));
                              },
                              icon: Icon(
                                Icons.copy_rounded,
                                color: ColorsConsts.primarybackground,
                              ),
                            ),
                            Text(
                              widget.texto,
                              style: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        )
                      : Text(
                          "La imagen no contiene texto válido o la imagen no esta muy clara!",
                          style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: ColorsConsts.black),
                        ))),
        ));
  }
}
