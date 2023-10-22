import 'package:fastenglish/consts/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      decoration:  BoxDecoration(
        color: ColorsConsts.primarybackground,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30.0)),
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
                  Text(
                    "Hola ",
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      fontWeight: FontWeight.w300,
                      color: Colors.white54
                    ),
                  ),
                  Text(
                    name ?? '',
                    style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.white
                    ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Estas de vuelta",
                textAlign: TextAlign.left,
                style: GoogleFonts.ubuntu(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
              ),
              Row(
                children: [
                  Text(
                    "GLISH",
                    style: GoogleFonts.ubuntu(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white54
                    ),
                  ),
                  Text(
                    "NOTES",
                    style: GoogleFonts.ubuntu(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Colors.white
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
