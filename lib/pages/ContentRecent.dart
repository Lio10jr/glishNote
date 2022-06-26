import 'dart:ui';

import 'package:fastenglish/entity/ImgCamera.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ContentRecent extends StatefulWidget {
  @override
  _ContentRecentState createState() => _ContentRecentState();
}

class _ContentRecentState extends State<ContentRecent> {
  final user = FirebaseAuth.instance.currentUser!;
  List<ImgCamera> listImg = [];
  @override
  void initState() {
    super.initState();
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
  @override
  Widget build(BuildContext context) {
    
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width * 0.50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            'Recientes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(5),
              child: Row(
                children: [
                  for(ImgCamera img in listImg)
                    ImgContainer(img.key.toString(),img.email, img.img, img.fecha, img.hora),
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
              padding: const EdgeInsets.all(10),
              child: Container(
                color: Colors.red.shade400,
                margin: const EdgeInsets.only(top: 55),
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
            );
  }
}
