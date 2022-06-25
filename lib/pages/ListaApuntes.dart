import 'package:fastenglish/entity/ApuntesTopic.dart';
import 'package:fastenglish/services/appState.dart';
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
        appBar: AppBar(
          title: Text(widget.tema),
          backgroundColor: Colors.orange.shade900,
        ),
        body: 
        Container(
          padding:
          const EdgeInsets.only(bottom: 20),
          child: FutureBuilder(
            future: estadado!.obtenerApuntes(user.email!, widget.tema).then((value) => value),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot){
            misApuntes = snapshot.data ?? [];
            return ListView(              
              children: [
                for(ApuntesTopic apuntes in misApuntes)
                  Dismissible(
                      key: Key(apuntes.key.toString()),
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        color: Colors.redAccent,
                        child: const Align(
                          alignment: Alignment.centerLeft,
                          child: Icon(Icons.delete,
                        size: 20),
                        )
                      ),
                      onDismissed: (direction) async {
                        bool resul =
                            await Provider.of<AppState>(context, listen: false)
                                .deleteApuntes(apuntes.key.toString(),
                                    user.email!, apuntes.tema);
                        if (resul) {
                         setState(() {
                          misApuntes;
                         });
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("Apunte eliminado correctamente"),
                            backgroundColor: Colors.red,
                          ));
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text("A ocurrido un error"),
                            backgroundColor: Colors.red,
                          ));
                        }
                      },
                      
                      child: ListTile(
                        title: Text(
                          apuntes.subTema,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          apuntes.contenido,
                          style: const TextStyle(fontSize: 15),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: (){
                            textsubTemaControlador.text = apuntes.subTema;
                            textControlador.text = apuntes.contenido;
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
                                                                .editNota(
                                                          apuntes.key.toString(),
                                                          widget.tema,
                                                          textsubTemaControlador.text,
                                                          textControlador.text,
                                                        );
                                                        if (result) {
                                                          ScaffoldMessenger.of(context)
                                                              .showSnackBar(const SnackBar(
                                                            content:
                                                                Text("Actualizado correctamente"),
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
                        ),
                      ),
                      
                      
                  )
              ]      
              
            );},
          ),
        )
      );
  }
}
