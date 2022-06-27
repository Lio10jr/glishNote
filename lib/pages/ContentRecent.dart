import 'dart:ui';

import 'package:fastenglish/entity/ImgCamera.dart';
import 'package:fastenglish/pages/Camera.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContentRecent extends StatefulWidget {
  @override
  _ContentRecentState createState() => _ContentRecentState();
}

class _ContentRecentState extends State<ContentRecent> {
  final user = FirebaseAuth.instance.currentUser!;
  List<ImgCamera> listImg = [];
  String? scannedText;
  @override
  void initState() {
    super.initState();
    DateTime date = DateTime.now();
    DateFormat formatter =DateFormat('yyyy-MM-dd');
    String fecha = formatter.format(date);
    AppState().eliminarImagenes(user.email!, fecha);
    getData();
  }

  void getData() async{
    try{
      final DataSnapshot userDoc = await FirebaseDatabase.instance.ref().child('ImgCamera').get();
      if(userDoc.exists){
        await AppState().obtenerImagenes(user.email!).then((value) {
          listImg = value;
        });
        setState(() {
          listImg;
        });
      }
    }catch(e){
      print('A ocurrido un error al retornar la lista de imagenes.  $e');
    }       
  }

  _obtenerNota(BuildContext context, String key) async{
    try{
      String datos = '';
      final DataSnapshot userDoc = await FirebaseDatabase.instance.ref().child('ImgCamera').get();
      if(userDoc.exists){
        await AppState().obtenerImagenes(user.email!).then((value) {
          for(ImgCamera imgg in value){
            if(imgg.key == key){
              datos = imgg.nota.toString();
            }
          }
        });
      }
      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => textScan( texto: datos,)));
      
    }catch(e){
      print('A ocurrido un error al retornar la nota de imagenes.  $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const[              
               Text(
                'Recientes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Reinicio 00:00H',
                style: TextStyle(
                  fontSize: 10,
                ),
              ),

            ],
          ),
          const Divider(),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  for(ImgCamera img in listImg)
                    ImgContainer(img.key.toString(),img.email, img.imgurl, img.fecha, img.hora),
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(right: 10),
                    decoration:  BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(5),                      
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Icon(Icons.image, size: 50,)
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Container ImgContainer(String key, String email, String img, String fecha, String hora) {
    return Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(right: 10),
              decoration:  BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(img),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 70),
                    color: Colors.black,
                  child: IconButton(
                      onPressed: (){
                        _obtenerNota(context,key);                        
                      },
                      icon: const Icon(Icons.document_scanner, color: Colors.amber,),
                    ),),
                  Container(
                    width: 100,
                    margin: const EdgeInsets.only(top: 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.red.shade400,
                    ),
                    child: Column(
                      children: [
                        Text(hora.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold
                            )
                        ),
                        Text(fecha,
                            style: const TextStyle(
                              fontSize: 10,    
                              fontWeight: FontWeight.bold                   
                        ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            );
  }
}
