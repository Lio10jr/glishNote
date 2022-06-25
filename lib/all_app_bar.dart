import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class TodoAppBarLog extends StatefulWidget {
  @override
  _TodoAppBarLogState createState() => _TodoAppBarLogState();
}

class _TodoAppBarLogState extends State<TodoAppBarLog> {
  final user = FirebaseAuth.instance.currentUser!;
  late ScrollController _scrollController;
  String? _uid;
  String? _name;
  String? _email;
  String? _userUrlImage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() { 
      setState(() {});
    });
    getData();
  }

  void getData() async{
    final DataSnapshot userDoc = await FirebaseDatabase.instance.ref().child("Users").get();
    setState(() {
      for(DataSnapshot sn in userDoc.children){
        if(user.email ==sn.child('Email').value){
          _uid = sn.key.toString();
          _email = sn.child('Email').value.toString();
          _name = sn.child('UserName').value.toString();
          _userUrlImage = sn.child('ImagenUrl').value.toString();
        }      
      }
    });    
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
            children: [              
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                "GLISH",
                style: TextStyle(
                    fontSize: 30,
                    fontFamily: 'Grenze',
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
              ),
              Text(
                "NOTES",
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent.shade700),
              ),
                ],
              ),
              Container(
                    height: kToolbarHeight / 1.8,
                    width: kToolbarHeight / 1.8,
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(color: Colors.white, blurRadius: 1.0),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(_userUrlImage ??
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEpWWQrAJpIR6Xy7FhzhCT00vzSmT7xw9S2Q&usqp=CAU'),
                        ),
                      ),
                  ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                "Hi, ",
                style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Grenze',
                    fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                _name ?? '',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 187, 0)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
