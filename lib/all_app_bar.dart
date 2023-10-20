import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class todoAppBarLog extends StatefulWidget {
  @override
  todoAppBarLogState createState() => todoAppBarLogState();
}

class todoAppBarLogState extends State<todoAppBarLog> {
  final user = FirebaseAuth.instance.currentUser!;
  late ScrollController _scrollController;
  String? uid;
  String? name;
  String? email;
  String? userUrlImage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {});
    });
    getData();
  }

  void getData() async {
    final DataSnapshot userDoc =
        await FirebaseDatabase.instance.ref().child("Users").get();
    setState(() {
      for (DataSnapshot sn in userDoc.children) {
        if (user.email == sn.child('Email').value) {
          uid = sn.key.toString();
          email = sn.child('Email').value.toString();
          name = sn.child('UserName').value.toString();
          userUrlImage = sn.child('ImagenUrl').value.toString();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF5E35B1),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.0)),
      ),
      margin: const EdgeInsets.only(bottom: 50),
      height: 140.0,
      padding: const EdgeInsets.only(top: 40, left: 15, right: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,  
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    "Hola ",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Grenze',
                      fontWeight: FontWeight.bold,
                      color: Colors.white54,
                    ),
                  ),
                  Text(
                    name ?? '',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
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
                    image: NetworkImage(userUrlImage ??
                        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSEpWWQrAJpIR6Xy7FhzhCT00vzSmT7xw9S2Q&usqp=CAU'),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Estas de vuelta",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Grenze',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Row(
                children: [
                  Text(
                    "GLISH",
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'Grenze',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "NOTES",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF44336),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
