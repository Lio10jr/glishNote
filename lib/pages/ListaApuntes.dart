import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/entity/ApuntesTopic.dart';
import 'package:fastenglish/pages/add_note_page.dart';
import 'package:fastenglish/pages/edit_note_page.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:fastenglish/widgets/titulo_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ListApuntes extends StatefulWidget {
  ListApuntes({Key? key}) : super(key: key);

  @override
  _ListApuntesState createState() => _ListApuntesState();
}

class _ListApuntesState extends State<ListApuntes> {
  List<ApuntesTopic> listApuntes = [];
  TextEditingController textControlador = TextEditingController();
  TextEditingController textsubTemaControlador = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  List misApuntes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(300.0),
        child: titulo_icon(titulo: "Aquí puedes ver todas tus notas",),
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
        child: FutureBuilder<List<ApuntesTopic>>(
          future: AppState().obtenerApuntes(
                user.email!,
              )
              .then((value) => value),
          builder: (BuildContext context, AsyncSnapshot<List<ApuntesTopic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
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
