import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:fastenglish/widgets/titulo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class add_vocabulario_page extends StatefulWidget {
  const add_vocabulario_page();

  @override
  State<add_vocabulario_page> createState() => _add_vocabulario_pageState();
}

class _add_vocabulario_pageState extends State<add_vocabulario_page> {
  TextEditingController ingles_text_controlador = TextEditingController();
  TextEditingController espa_text_controlador = TextEditingController();
  TextEditingController pronun_text_controlador = TextEditingController();
  TextEditingController textControlador = TextEditingController();
  TextEditingController textTemaControlador = TextEditingController();
  final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(200.0),
          child: titulo(tema: "Agregar una nueva palabra a tu Vocabulario"),
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Colors.purple, // Color del borde superior
                    width: 1.5, // Grosor del borde
                  ),
                ),
              ),
            child: Form(
              key: _formularioKey,
              child: Column(        
                children: [              
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    margin: const EdgeInsets.only(top: 25),
                    child: TextFormField(
                      controller: ingles_text_controlador,
                      decoration: InputDecoration(
                        labelText: "Palabra en Ingles",
                        hintText: "Escribe aqui!",
                        labelStyle: TextStyle( color: ColorsConsts.primarybackground, fontWeight: FontWeight.w500)
                      ),
                      maxLines: 1,
                      validator: (String? date) {
                        if (date!.isEmpty) {
                          return "Este campo es requerido";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    margin: const EdgeInsets.only(top: 25),
                    child: TextFormField(
                      controller: espa_text_controlador,
                      decoration: InputDecoration(
                        labelText: "Palabra en Español",
                        hintText: "Escribe aqui!",
                        labelStyle: TextStyle( color: ColorsConsts.primarybackground, fontWeight: FontWeight.w500)
                      ),
                      maxLines: 1,
                      validator: (String? date) {
                        if (date!.isEmpty) {
                          return "Este campo es requerido";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    margin: const EdgeInsets.only(top: 25),
                    child: TextFormField(
                      controller: pronun_text_controlador,
                      decoration: InputDecoration(
                        labelText: "¿Como se pronuncia?",
                        hintText: "Escribe aqui!",
                        labelStyle: TextStyle( color: ColorsConsts.primarybackground, fontWeight: FontWeight.w500)
                      ),
                      maxLines: 1,
                      validator: (String? date) {
                        if (date!.isEmpty) {
                          return "Este campo es requerido";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  SizedBox(
                    height: 150,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFFA10D0D),
                                        Color(0xFFD21919),
                                        Color(0xFFF54242),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text("Proceso cancelado"),
                                  ));
                                  setState(() {
                                    espa_text_controlador.text = "";
                                    ingles_text_controlador.text = "";
                                    pronun_text_controlador.text = "";
                                  });
                                },
                                child: text_title(
                                    color: ColorsConsts.white,
                                    size: 15,
                                    fontw: FontWeight.w500,
                                    titulo: "Cancelar"),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Stack(
                            children: <Widget>[
                              Positioned.fill(
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF0D47A1),
                                        Color(0xFF1976D2),
                                        Color(0xFF42A5F5),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.only(left: 20, right: 20),
                                ),
                                onPressed: () async {
                                  if (_formularioKey.currentState!
                                                .validate()) {
                                              Navigator.pop(context);
                                              bool result =
                                                  await AppState()
                                                      .saveVocabulario(
                                                          user.email!,
                                                          ingles_text_controlador.text,
                                                          espa_text_controlador.text,
                                                          pronun_text_controlador
                                                              .text);
                                              if (result) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: const Text(
                                                      "Agregado correctamente"),
                                                  backgroundColor:
                                                      ColorsConsts.msgValidbackground,
                                                ));
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: const Text("Algo salio mal"),
                                                  backgroundColor: ColorsConsts.msgValidbackground,
                                                ));
                                              }
                                            
                                  }
                                },
                                child: text_title(
                                    color: ColorsConsts.white,
                                    size: 15,
                                    fontw: FontWeight.w500,
                                    titulo: "Agregar"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
