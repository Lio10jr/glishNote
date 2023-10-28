import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/widgets/text_title.dart';
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
  String uid = "";
  String name = "";
  String email = "";
  String userUrlImage = "";

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 200,
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
                      titulo: "Hola $name")),
              userUrlImage != ""
                  ? SizedBox(
                      width: 50,
                      height: 50,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(140),
                          boxShadow: [
                            BoxShadow(
                              color: ColorsConsts.primarybackground,
                              spreadRadius: 10,
                              blurRadius: 5,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 120,
                          backgroundImage: NetworkImage(userUrlImage),
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 50,
                      height: 50,
                      child: CircleAvatar(
                        radius: 120,
                        backgroundImage: AssetImage('assets/usuarioDefecto.jpg'),
                      ),
                    ),
            ],
          ),
        ),
        SizedBox(
          height: 80,
          child: Text(
            "Explora la riqueza de contenido que hemos preparado para ti!",
            textAlign: TextAlign.center,
            style: GoogleFonts.ubuntu(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: ColorsConsts.white),
          ),
        ),
      ],
    );
  }
}
