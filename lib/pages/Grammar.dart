import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/entity/CalificacionContenido.dart';
import 'package:fastenglish/entity/ContenidoPage.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:fastenglish/pages/contenido_page_titulo.dart';
import 'package:fastenglish/widgets/titulo_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Grammar extends StatefulWidget {
  const Grammar({Key? key}) : super(key: key);

  _grammarState createState() => _grammarState();
}

class _grammarState extends State<Grammar> {
  List<CalificacionContenido> list = [];
  final user = FirebaseAuth.instance.currentUser!;
  CalificacionContenido? contenidoo;

  @override
  initState() {
    super.initState();
    setState(() {
      getData();
    });
  }

  getData() async {
    final contenido = await AppState().obtenerValoracionContenido(user.email!);

    setState(() {
      list = contenido;
    });
  }

  CalificacionContenido? buscarPorTema(
      List<CalificacionContenido> lista, String tema) {
    try {
      contenidoo = list.firstWhere((calificacion) => calificacion.tema == tema);
      print(contenidoo);
      return contenidoo;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(300.0),
          child: titulo_icon(
            titulo: "Temas relevantes sobre el aprendizaje",
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
          child: FutureBuilder(
              future: readJsonDataContainerPage(),
              builder: (context, data) {
                if (data.hasError) {
                  return Center(child: Text("${data.error}"));
                } else if (data.hasData) {
                  var items = data.data as List<contenidoPage>;
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final temas = items[index];

                        return Stack(
                          children: [
                            Container(
                              width: Size.infinite.width * 0.5,
                              margin: const EdgeInsets.only(top: 10),
                              child: Column(
                                children: [
                                  Container(
                                    height: 50,
                                    width: Size.infinite.width * 0.5,
                                    alignment: Alignment.center,
                                    child: text_title(
                                      titulo: temas.titulo ?? '',
                                      size: 20,
                                      fontw: FontWeight.w800,
                                      color: ColorsConsts.primarybackground,
                                    ),
                                  ),
                                  if (temas.subtitulos != null)
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ListView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            padding: const EdgeInsets.only(
                                                left: 25, right: 25),
                                            itemCount: temas.subtitulos!.length,
                                            itemBuilder: (context, subIndex) {
                                              return card(
                                                  context,
                                                  temas.subtitulos![subIndex],
                                                  contenido_page_titulo(
                                                    tema: temas
                                                        .subtitulos![subIndex],
                                                  ));
                                            }),
                                      ],
                                    )
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }

  Card card(BuildContext context, String tema, Widget pagina) {
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(20.0),
      ),
      child: InkWell(
        splashColor: ColorsConsts.backgroundColor,
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => pagina));
        },
        child: SizedBox(
          height: 100,
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.article,
                      color: ColorsConsts.endColor, size: 80)),
              Container(
                padding: const EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tema,
                          textAlign: TextAlign.end,
                        ),
                        Row(
                          children: [
                            if (buscarPorTema(list, tema) != null)
                              const Icon(Icons.star,
                                  color: Colors.greenAccent, size: 25),
                            if (buscarPorTema(list, tema) != null)
                              Text(contenidoo!.valoracion.toString())
                            else
                              const Icon(Icons.star_border,
                                  color: Colors.yellow, size: 25),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
