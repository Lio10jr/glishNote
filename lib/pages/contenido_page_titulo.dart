import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/entity/ContenidoPageTitulo.dart';
import 'package:fastenglish/pages/ListaApuntes.dart';
import 'package:fastenglish/pages/add_note_page.dart';
import 'package:fastenglish/pages/verbs.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:fastenglish/main.dart';
import 'package:fastenglish/widgets/app_bar_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class contenido_page_titulo extends StatefulWidget {
  final String tema;
  const contenido_page_titulo({required this.tema});

  @override
  State<contenido_page_titulo> createState() => _contenido_page_tituloState();
}

class _contenido_page_tituloState extends State<contenido_page_titulo> {
  ContenidoPageTitulo? objContenidoPageTitulo;
  TextEditingController textControlador = TextEditingController();
  TextEditingController textsubTemaControlador = TextEditingController();
  AppState? estadado;
  final user = FirebaseAuth.instance.currentUser!;
  
  List<Color> listColor = [
    Colors.greenAccent,
    Colors.red.shade100,
    Colors.yellowAccent,
    Colors.orangeAccent
  ];
  @override
  initState() {
    super.initState();
    setState(() {
      getData();
    });
  }

  getData() async {
    final contenido = await buscarContenidoPorTitulo(widget.tema);
    setState(() {
      objContenidoPageTitulo = contenido;
    });
  }

  @override
  Widget build(BuildContext context) {
    estadado = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: app_bar_icon(
          title: widget.tema,
          icon: Icons.chrome_reader_mode_outlined,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                card(context, 'Nueva Nota', const add_note_page(), Icons.note_add),
                card(context, 'Notas', ListApuntes(), Icons.view_headline_rounded),
                card(context, 'Verbos', const verbs(), Icons.view_list_rounded),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const text_title(
                  color: Colors.black,
                  fontw: FontWeight.w800,
                  size: 20,
                  titulo: "Uso"),
            ),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: text_title(
                  color: Colors.black,
                  fontw: FontWeight.w300,
                  size: 15,
                  titulo: objContenidoPageTitulo?.utilizacion ?? ""),
            ),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.only(left: 10, right: 10),
                itemCount: objContenidoPageTitulo?.contenido.length ?? 0,
                itemBuilder: (context, index) {
                  if (objContenidoPageTitulo?.contenido[index] != []) {
                    final contenido = objContenidoPageTitulo?.contenido[index];
                    return Card(
                      elevation: 3.0,
                      margin: const EdgeInsets.only(bottom: 15.0),
                      color: listColor[index],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5.0),
                              child: text_title(
                                  color: Colors.black,
                                  fontw: FontWeight.w800,
                                  size: 20,
                                  titulo: contenido?.subtitulo ?? ''),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white54,
                                  borderRadius: BorderRadius.circular(10.0)),
                              padding: const EdgeInsets.all(10.0),
                              child: text_title(
                                  color: Colors.black,
                                  fontw: FontWeight.w500,
                                  size: 15,
                                  titulo: contenido?.datos[0].uso ?? ''),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10.0),
                              child: const text_title(
                                  color: Colors.blue,
                                  fontw: FontWeight.w500,
                                  size: 15,
                                  titulo: "Info:"),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: text_title(
                                  color: Colors.black,
                                  fontw: FontWeight.w100,
                                  size: 15,
                                  titulo:
                                      contenido?.datos[0].informacion ?? ''),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.all(10.0),
                              child: const text_title(
                                  color: Colors.blue,
                                  fontw: FontWeight.w500,
                                  size: 15,
                                  titulo: "Ejemplos:"),
                            ),
                            if (contenido?.datos[0].ejemplos != [])
                              ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  itemCount:
                                      contenido?.datos[0].ejemplos.length ?? 0,
                                  itemBuilder: (context, indexExample) {
                                    final ejemplos =
                                        contenido?.datos[0].ejemplos ?? [];
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: text_title(
                                          color: Colors.black,
                                          fontw: FontWeight.w300,
                                          size: 15,
                                          titulo: ejemplos[indexExample] ?? ''),
                                    );
                                  })
                            else
                              const text_title(
                                  color: Colors.black,
                                  fontw: FontWeight.w500,
                                  size: 15,
                                  titulo: "Ejemplos no encontrados")
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const text_title(
                        color: Colors.black,
                        fontw: FontWeight.w500,
                        size: 15,
                        titulo: "Contenido no encontrado");
                  }
                }),
          ],
        ),
      )
    );
  }
}

Card card(BuildContext context, String tema, Widget pagina, IconData icon) {
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
        width: 80,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(5.0),
                child: Icon(icon,
                    color: ColorsConsts.endColor, size: 30)),
            text_title(
                  color: Colors.black,
                  fontw: FontWeight.w500,
                  size: 10,
                  titulo: tema),
          ],
        ),
      ),
    ),
  );
}
