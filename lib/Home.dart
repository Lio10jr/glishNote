import 'dart:ui';
import 'package:fastenglish/all_pages_view.dart';
import 'package:fastenglish/pages/ContentRecent.dart';
import 'package:fastenglish/pages/login.dart';
import 'package:fastenglish/pages/register.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'all_app_bar.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';



const IconData facebook = IconData(0xe255, fontFamily: 'MaterialIcons');

//PagSecundaria con sesion iniciada
class PrincipalSession extends StatefulWidget {
  const PrincipalSession({Key? key}) : super(key: key);

  @override
  _StateHomePageSession createState() => _StateHomePageSession();
}

class _StateHomePageSession extends State<PrincipalSession> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(top: 60, child: TodoAppBarLog(),),
            Positioned(top: 175, child: ContentRecent(),),
            const Positioned(bottom: 40, child: AllPageView(),)
           // Positioned(bottom: 0, child: ,)
          ],
        ),
    );
  }
}

/*
Login
class logHome extends StatelessWidget {
  logHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => testWidget;

  Widget testWidget =  MediaQuery(
    data:  const MediaQueryData(),
    child:  MaterialApp(
        home: Scaffold(
          body: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot){
              if(snapshot.hasData) {
                return const PrincipalSession();
              }else{
                return login();
              }
            },
          ),
        )
    ),
  );
}*/