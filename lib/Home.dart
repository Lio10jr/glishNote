import 'package:fastenglish/all_pages_view.dart';
import 'package:fastenglish/pages/ContentRecent.dart';
import 'package:flutter/material.dart';
import 'all_app_bar.dart';

const IconData facebook = IconData(0xe255, fontFamily: 'MaterialIcons');

//PagSecundaria con sesion iniciada
class PrincipalSession extends StatefulWidget {
  const PrincipalSession({Key? key}) : super(key: key);

  @override
  stateHomePageSession createState() => stateHomePageSession();
}

class stateHomePageSession extends State<PrincipalSession> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 60,
            child: todoAppBarLog(),
          ),
          Positioned(
            top: 175,
            child: ContentRecent(),
          ),
          const Positioned(
            bottom: 40,
            child: AllPageView(),
          )
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