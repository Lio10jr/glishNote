import 'dart:ui';

import 'package:fastenglish/entity/ImgCamera.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ContentRecent extends StatefulWidget {
  @override
  _ContentRecentState createState() => _ContentRecentState();
}

class _ContentRecentState extends State<ContentRecent> {
  final user = FirebaseAuth.instance.currentUser!;
  late ScrollController _scrollController;
  String? _uid;
  String? _name;
  String? _email;
  String? _userUrlImage;
  List<ImgCamera> listImg = [];
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() { 
      setState(() {});
    });
    getData();
  }

  void getData() async{
    String name = "ImgCamera/"+ user.email!;
    try{
      final DataSnapshot userDoc = await FirebaseDatabase.instance.ref().child(name).get();
      if(userDoc.exists){
        setState(() {
        for(DataSnapshot sn in userDoc.children){
            ImgCamera ovn = ImgCamera(
              key: sn.key.toString(),
              email: sn.child('Email').value.toString(),
              img: sn.child('Img').value.toString(),
              fecha: sn.child('Fecha').value as DateTime,
            );
            listImg.add(ovn);             
        }
      });
      }
    }catch(e){
      
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
          Divider(),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  for(ImgCamera img in listImg)
                    ImgContainer(img.key.toString(),img.email, img.img, img.fecha)
                ],
              )
          ),

        ],
      ),
    );
  }

  Container ImgContainer(String key, String email, String img, DateTime fecha) {
    return Container(
              width: 100,
              height: 100,
              margin: const EdgeInsets.only(right: 10),
              decoration:  BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(img),
                ),
              ),
              padding: const EdgeInsets.all(10),
              child: Stack(
                children: [
                  Positioned(top: 50, child: Text(fecha.hour.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                      )
                  ),),
                  Positioned(top: 65, child: Text(fecha.toString(),
                      style: const TextStyle(
                        fontSize: 15,
                      )
                  ),
                  )
                ],
              ),
            );
  }
}

