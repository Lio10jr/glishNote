import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/pages/add_vocabulario_page.dart';
import 'package:fastenglish/pages/edit_vocabulario_page.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:fastenglish/widgets/titulo_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../entity/VocabularyNote.dart';

class vocabulary extends StatefulWidget {
  const vocabulary({Key? key}) : super(key: key);

  @override
  Statevocabulary createState() => Statevocabulary();
}

late List<VocabularyNote> dataVocabularyList = [];

class Statevocabulary extends State<vocabulary> {
  final int _currentSortColumn = 0;
  final bool _isSortAsc = true;
  final TextEditingController _textBuscar = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  List misnotas = [];
  AppState? estadado;

  //database
  late final dref = FirebaseDatabase.instance.ref();
  late DatabaseReference databaseReferent;
  late List listBuscar =
      [] as List<VocabularyNote>;
  DatabaseReference refbase =
      FirebaseDatabase.instance.ref().child("VocabularyNote");

  @override
  Widget build(BuildContext context) {
    estadado = Provider.of<AppState>(context, listen: true);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(300.0),
          child: titulo_icon(titulo: "Todo tu vocabulario esta aqui!",),
        ),
        body: Stack(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: ColorsConsts.primarybackground),
              child: TextField(
                controller: _textBuscar,
                onChanged: (val) {
                  setState(() {
                    listBuscar = misnotas
                        .where((element) {
                          final inglesPalabra = element.ingles
                            .toLowerCase()
                            .contains(val.toLowerCase());
                          final espaPalabra = element.espanish
                            .toLowerCase()
                            .contains(val.toLowerCase());
                            return inglesPalabra || espaPalabra;
                        })
                        .toList();
                  });
                },
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _textBuscar.clear();
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
              margin: const EdgeInsets.only(top:80),
              padding:
                  const EdgeInsets.only(right: 10, left: 10),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(30),),
                color: Colors.grey[200],
              ),
              child: FutureBuilder(
                future: estadado!.obtenerVocabulario(user.email!),
                builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                  misnotas = snapshot.data ?? [];
                  return ListView(children: [
                    DataTable(
                      horizontalMargin: 7,
                      columnSpacing: 0,
                      sortColumnIndex: _currentSortColumn,
                      sortAscending: _isSortAsc,
                      border: const TableBorder(
                          horizontalInside: BorderSide(width: 1)),
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => ColorsConsts.endColor),
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
                            "Pronunciación",
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text("Act.",
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        ),
                      ],
                      rows: [
                        if (_textBuscar.text.isNotEmpty)
                          for (VocabularyNote nota in listBuscar)
                            DataRow(
                              selected: true,
                              cells: <DataCell>[
                                DataCell(
                                  Text(nota.ingles),
                                ),
                                DataCell(Text(nota.espanish)),
                                DataCell(Text(nota.pronunciacion)),
                                DataCell(Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.edit,
                                          color: ColorsConsts.primarybackground,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          estadado!.deleteVocabulario(nota.key);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red.shade300,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          estadado!.deleteVocabulario(nota.key);
                                        },
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                        if (_textBuscar.text.isEmpty)
                          for (VocabularyNote nota in misnotas)
                            DataRow(
                              cells: <DataCell>[
                                DataCell(Text(nota.ingles)),
                                DataCell(Text(nota.espanish)),
                                DataCell(Text(nota.pronunciacion)),
                                DataCell(Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.edit,
                                          color: ColorsConsts.primarybackground,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => edit_vocabulario_page(objVocabulario: nota,)));
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                      child: IconButton(
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red.shade300,
                                          size: 20,
                                        ),
                                        onPressed: () {
                                          estadado!.deleteVocabulario(nota.key);
                                        },
                                      ),
                                    ),
                                  ],
                                ))
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
          backgroundColor: ColorsConsts.primarybackground,
          child: const Icon(
            Icons.add,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => const add_vocabulario_page()));
          }
        ),
      ),
    );
  }
}
