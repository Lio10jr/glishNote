/* import 'package:fastenglish/entity/ContenidoPageTitulo.dart';
import 'package:fastenglish/pages/Grammar.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:provider/provider.dart';
import 'package:ionicons/ionicons.dart';

import '../entity/ApuntesTopic.dart';
import 'ListaApuntes.dart';

class allTopic extends StatefulWidget {
  late final String tema;

  allTopic({required this.tema});

  @override
  StateallTopic createState() => StateallTopic();
}

late List<ApuntesTopic> dataApuntesTopicList = [];
late List<ContenidoPageTitulo> dataContenidoPageTituloList = [];

class StateallTopic extends State<allTopic> {
  TextEditingController textControlador = TextEditingController();
  TextEditingController textsubTemaControlador = TextEditingController();
  final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();
  AppState? estadado;
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    estadado = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        title: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: Text(
                  widget.tema,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              ClipOval(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: InkWell(
                      splashColor: Colors.lightGreen, // splash color
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ListApuntes(tema: widget.tema),
                          ),
                        );
                      }, // button pressed
                      child: const Icon(
                        Icons.note_alt,
                        size: 30,
                        color: Colors.white,
                      )),
                  //child:
                ),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: Size.infinite.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, top: 30),
                child: const Text(
                  "USO",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 187, 0),
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  listCT[widget.pos].uso.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, bottom: 10, top: 10),
                child: const Text(
                  "Estructura",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 20,
                      color: Color.fromARGB(255, 255, 187, 0),
                      fontWeight: FontWeight.bold),
                ),
              ),
              DataTable(
                dividerThickness: 50,
                border:
                    const TableBorder(horizontalInside: BorderSide(width: 2)),
                sortColumnIndex: 0,
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 255, 187, 0)),
                sortAscending: false,
                columns: const [
                  DataColumn(
                    label: Text("AFIRMATIVO",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                      Text(listCT[widget.pos].affimative.toString()),
                    ),
                  ])
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  listCT[widget.pos].infoa.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 30, top: 10),
                child: const Text(
                  "Por Ejemplo:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Text(
                  listCT[widget.pos].examplea.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              DataTable(
                dividerThickness: 50,
                border:
                    const TableBorder(horizontalInside: BorderSide(width: 2)),
                sortColumnIndex: 0,
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 255, 187, 0)),
                sortAscending: false,
                columns: const [
                  DataColumn(
                    label: Text("NEGATIVO",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                      Text(listCT[widget.pos].negative.toString()),
                    ),
                  ])
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  listCT[widget.pos].infon.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 30, top: 10),
                child: const Text(
                  "Por Ejemplo:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Text(
                  listCT[widget.pos].examplen.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              DataTable(
                dividerThickness: 50,
                border:
                    const TableBorder(horizontalInside: BorderSide(width: 2)),
                sortColumnIndex: 0,
                sortAscending: false,
                headingRowColor: MaterialStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 255, 187, 0)),
                columns: const [
                  DataColumn(
                    label: Text("INTERROGATIVO",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(
                      Text(listCT[widget.pos].interrogative.toString()),
                    ),
                  ])
                ],
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, top: 10),
                child: Text(
                  listCT[widget.pos].infoi.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 30, top: 10),
                child: const Text(
                  "Por Ejemplo:",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                child: Text(
                  listCT[widget.pos].examplei.toString(),
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          textControlador.clear();
          showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              isScrollControlled: true,
              builder: (BuildContext context) {
                return Container(
                  height: Size.infinite.height,
                  width: Size.infinite.height,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Form(
                    key: _formularioKey,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 25,
                        ),
                        Container(
                          color: const Color.fromARGB(255, 255, 187, 0),
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 0,
                                ),
                                child: Text(
                                  widget.tema,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                      fontSize: 20),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Ionicons.bookmark,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      if (_formularioKey.currentState!
                                          .validate()) {
                                        Navigator.pop(context);
                                        bool result =
                                            await Provider.of<AppState>(context,
                                                    listen: false)
                                                .saveApuntes(
                                          user.email!,
                                          widget.tema,
                                          textsubTemaControlador.text,
                                          textControlador.text,
                                        );
                                        if (result) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content:
                                                Text("Agregado correctamente"),
                                            backgroundColor: Colors.lightGreen,
                                          ));
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(const SnackBar(
                                            content: Text("Algo salio mal"),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      }
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close_sharp,
                                      size: 30,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text("Proceso cancelado"),
                                      ));
                                      setState(() {
                                        textControlador.clear();
                                      });
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              controller: textsubTemaControlador,
                              decoration: const InputDecoration(
                                labelText: "SubTema",
                                hintText: "Write Here!",
                              ),
                              maxLines: 1,
                              validator: (String? date) {
                                if (date!.isEmpty) {
                                  return "Este campo es requerido";
                                }
                              },
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: TextFormField(
                              controller: textControlador,
                              decoration: const InputDecoration(
                                labelText: "Tus Notas",
                                hintText: "Write Here!",
                                border: InputBorder.none,
                              ),
                              maxLines: null,
                              validator: (String? date) {
                                if (date!.isEmpty) {
                                  return "Este campo es requerido";
                                }
                              },
                              keyboardType: TextInputType.multiline,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        splashColor: Colors.orange.shade200,
        backgroundColor: Colors.orange.shade900,
        child: const Icon(
          Icons.add,
          size: 50,
        ),
      ),
    );
  }
}
 */