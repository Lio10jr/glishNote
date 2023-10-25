import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/entity/ApuntesTopic.dart';
import 'package:fastenglish/pages/add_note_page.dart';
import 'package:fastenglish/pages/edit_note_page.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class ListApuntes extends StatefulWidget {
  String tema;
  ListApuntes({Key? key, required this.tema}) : super(key: key);

  @override
  _ListApuntesState createState() => _ListApuntesState();
}

class _ListApuntesState extends State<ListApuntes> {
  List<ApuntesTopic> listApuntes = [];
  TextEditingController textControlador = TextEditingController();
  TextEditingController textsubTemaControlador = TextEditingController();
  final GlobalKey<FormState> _formularioKey = GlobalKey<FormState>();
  AppState? estadado;
  final user = FirebaseAuth.instance.currentUser!;
  List misApuntes = [];

  @override
  Widget build(BuildContext context) {
    estadado = Provider.of<AppState>(context, listen: true);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(300.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
                width: 200,
                padding: const EdgeInsets.only(top: 50, bottom: 50),
                child: text_title(
                    color: ColorsConsts.primarybackground,
                    size: 30,
                    fontw: FontWeight.w500,
                    titulo: "Aquí puedes ver todas tus notas")),
            Ink(
              decoration: ShapeDecoration(
                color: ColorsConsts.primarybackground,
                shape: const CircleBorder(),
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_sharp,
                    color: Colors.white,
                    size: 30,
                  )),
            )
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(bottom: 20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.purple, // Color del borde superior
              width: 1.5, // Grosor del borde
            ),
          ),
        ),
        child: FutureBuilder<List<ApuntesTopic>>(
          future: estadado!
              .obtenerApuntes(
                user.email!,
              )
              .then((value) => value),
          builder: (BuildContext context, AsyncSnapshot<List<ApuntesTopic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              misApuntes = snapshot.data ?? [];
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 20),
                children: [
                  for (ApuntesTopic apuntes in misApuntes)
                    Dismissible(
                      key: Key(apuntes.key.toString()),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                          color: Colors.redAccent,
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(Icons.delete, size: 20),
                          )),
                      onDismissed: (direction) async {
                        bool resul =
                            await Provider.of<AppState>(context, listen: false)
                                .deleteApuntes(apuntes.key.toString(),
                                    user.email!, apuntes.tema);
                        if (resul) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Apunte eliminado correctamente"),
                            backgroundColor: Colors.red,
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("A ocurrido un error"),
                            backgroundColor: Colors.red,
                          ));
                        }
                      },
                      child: ListTile(
                        title: Text(
                          apuntes.tema,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          apuntes.contenido,
                          style: const TextStyle(fontSize: 15),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        edit_note_page(apuntes: apuntes)));
                          },
                        ),
                      ),
                    )
                ]);
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const add_note_page()));
        },
        foregroundColor: ColorsConsts.white,
        backgroundColor: ColorsConsts.primarybackground,
        shape: const CircleBorder(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
