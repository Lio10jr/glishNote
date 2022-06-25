import 'package:fastenglish/services/appState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../entity/VocabularyNote.dart';

class vocabulary extends StatefulWidget {
  const vocabulary({Key? key}) : super(key: key);

  @override
  Statevocabulary createState() => Statevocabulary();
}

late List<VocabularyNote> dataVocabularyList = [];

class Statevocabulary extends State<vocabulary> {
  int _currentSortColumn = 0;
  bool _isSortAsc = true;
  final TextEditingController? _textBuscar = TextEditingController();
  final TextEditingController _inglesController = TextEditingController();
  final TextEditingController _espanishController = TextEditingController();
  final TextEditingController _pronunciacionController =
      TextEditingController();
  final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();
  final user = FirebaseAuth.instance.currentUser!;
  List misnotas = [];
  AppState? estadado;

  //database
  late final dref = FirebaseDatabase.instance.ref();
  late DatabaseReference databaseReferent;
  late List<VocabularyNote> listBuscar =
      [] as List<VocabularyNote>; //lista de busquedad
  DatabaseReference refbase =
      FirebaseDatabase.instance.ref().child("VocabularyNote");

  @override
  Widget build(BuildContext context) {
    estadado = Provider.of<AppState>(context, listen: true);
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween ,
            children: [
              const Text("VOCABULARY"),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: (){
                  setState(() {});
                },
              )
            ],
          ),
          shadowColor: Colors.red,
          backgroundColor: Colors.orange.shade900,
        ),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color.fromARGB(255, 255, 187, 0)),
              child: TextField(
                controller: _textBuscar,

                onChanged: (val) {
                  setState(() {
                    listBuscar = dataVocabularyList
                        .where(((element) => element.ingles
                            .toLowerCase()
                            .contains(val.toLowerCase())))
                        .toList();
                  });
                },
                decoration: InputDecoration(
                    suffixIcon:  IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: (){
                        setState(() {
                          _textBuscar!.clear();
                        });
                      },
                    ),
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.all(15),
                    hintText: 'Search'),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50),
              padding:
                  const EdgeInsets.only(top: 20, bottom: 20, right: 5, left: 5),
              child: FutureBuilder(
                future: estadado!.obtenerNotas(user.email!),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  misnotas = snapshot.data ?? [];
                  return ListView(children: [
                    DataTable(
                      horizontalMargin: 7,                      
                      columnSpacing: 0,
                      dataRowHeight: 80,
                      sortColumnIndex: _currentSortColumn,
                      sortAscending: _isSortAsc,
                      border: const TableBorder(
                          horizontalInside: BorderSide(width: 1,)),
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.orange.shade400),
                      columns: const <DataColumn>[
                        DataColumn(
                          label: Text(
                            "Ingles",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Español",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Pronunciacion",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text("Eliminar",
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                      ],
                      rows: [
                        if (_textBuscar!.text.isNotEmpty)
                          for (VocabularyNote nota in listBuscar)
                            DataRow(
                              selected: true,
                              cells: <DataCell>[
                                DataCell(Text(nota.ingles),),
                                DataCell(Text(nota.espanish)),
                                DataCell(Text(nota.pronunciacion)),
                                DataCell(IconButton(
                                    icon: Icon(
                                  Icons.delete,
                                  color: Colors.red.shade300,
                                      size: 20,
                                ),
                                  onPressed: (){
                                      estadado!.deleteNota(nota.key);
                                  },
                                )
                                )
                              ],
                            ),
                        if (_textBuscar!.text.isEmpty)
                          for (VocabularyNote nota in misnotas)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(nota.ingles)),
                                DataCell(Text(nota.espanish)),
                                DataCell(Text(nota.pronunciacion)),
                                DataCell(IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade300,
                                    size: 20,
                                  ),
                                  onPressed: (){
                                    estadado!.deleteNota(nota.key);
                                  },
                                )
                                )
                              ],
                            ),
                      ],
                    ),
                  ]);
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          splashColor: Colors.orange.shade200,
          backgroundColor: Colors.orange.shade900,
          child: const Icon(
            Icons.add,
            size: 50,
          ),
          onPressed: () {
            _inglesController.clear();
            _espanishController.clear();
            _pronunciacionController.clear();
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(25.0))),
                builder: (BuildContext context) {
                  return Container(
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
                            color: Colors.orange.shade900,
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 15),
                                  child: const Text(
                                    "Nuevo",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30),
                                  ),
                                ),
                                Row(
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
                                          bool result = await Provider.of<AppState>(
                                                  context,
                                                  listen: false)
                                              .saveNotas(
                                                  user.email!,
                                                  _inglesController.text,
                                                  _espanishController.text,
                                                  _pronunciacionController.text);
                                          if (result) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                content:
                                                    Text("Agregado correctamente"),
                                                backgroundColor: Colors.lightGreen,
                                              )
                                              );
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
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text("Proceso cancelado"),
                                        ));
                                        setState(() {
                                          _pronunciacionController.clear();
                                          _espanishController.clear();
                                          _inglesController.clear();
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
                                controller: _inglesController,maxLength: 17,
                                decoration: const InputDecoration(
                                  labelText: "Ingles",
                                  hintText: "Write Here in English!",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (String? date) {
                                  if (date!.isEmpty) {
                                    return "Este campo es requerido";
                                  }
                                },
                                maxLines: 1,
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
                                controller: _espanishController,
                                maxLength: 17,
                                decoration: const InputDecoration(
                                  labelText: "Español",
                                  hintText: "Write Here in Spanish!",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (String? date) {
                                  if (date!.isEmpty) {
                                    return "Este campo es requerido";
                                  }
                                },
                                maxLines: 1,
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
                                controller: _pronunciacionController,
                                maxLength: 17,
                                decoration: const InputDecoration(
                                  labelText: "Pronunciación",
                                  hintText: "Write Here the pronunciation!",
                                  border: OutlineInputBorder(),
                                ),
                                validator: (String? date) {
                                  if (date!.isEmpty) {
                                    return "Este campo es requerido";
                                  }
                                },
                                maxLines: 1,
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
        ),
      ),
    );
  }
}
