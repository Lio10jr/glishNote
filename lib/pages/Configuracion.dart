import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:flutter/material.dart';

class Configuracion extends StatefulWidget {
  @override
  _ConfiguracionState createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion> {
  TextEditingController textControlador = TextEditingController();
  TextEditingController textsubTemaControlador = TextEditingController();
  final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(300.0),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: 0.8,
          child: Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 100, bottom: 100),
              child: text_title(
                  color: ColorsConsts.primarybackground,
                  size: 30,
                  fontw: FontWeight.w500,
                  titulo: "Aquí puedes agregar una nueva nota")),
        ),
      ),
      body: Center(
        child: Container(
          child: Text('_ConfiguracionState'),
        ),
      ),
    );
  }
}
