import 'dart:async';
import 'dart:convert';
import 'package:fastenglish/dark_theme_provider.dart';
import 'package:fastenglish/entity/TopicE.dart';
import 'package:fastenglish/pages/login.dart';
import 'package:fastenglish/pages/verbs.dart';
import 'package:fastenglish/pages/verificarEmailPage.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:fastenglish/theme/dark_theme.dart';
import 'package:fastenglish/theme/light_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  DatabaseReference refbase =
      FirebaseDatabase.instance.ref().child("VocabularyNote");
  refbase.keepSynced(true);
  runApp(const MyApp()); //home: login(),
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  StateMyApp createState() => StateMyApp();
}

class StateMyApp extends State<MyApp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  DarkThemeProvider themeChangeProvider = DarkThemeProvider();
  String? metodo;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) {
              return themeChangeProvider;
            },
          )
        ],
        child: ChangeNotifierProvider(
            create: (_) => AppState(), // colorProvider(),
            child: Consumer<DarkThemeProvider>(
              builder: (context, themeData, child) {
                return MediaQuery(
                  data: const MediaQueryData(),
                  child: MaterialApp(
                      /* theme: Styles.themeData(
                          (themeChangeProvider.darkTheme), context), */
                      theme: lightTheme,
                      darkTheme: darkTheme,
                      debugShowCheckedModeBanner: false,
                      home: Scaffold(
                        body: StreamBuilder<User?>(
                          stream: FirebaseAuth.instance.authStateChanges(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return verificarEmailPage();
                            } else {
                              return login();
                            }
                          },
                        ),
                      )),
                );
              },
            )));
  }
}

Future<List<VerbsDateModel>> readJsonData() async {
  final jsondata =
      await rootBundle.rootBundle.loadString('assets/verbsList.json');
  final list = json.decode(jsondata) as List<dynamic>;
  return list.map((e) => VerbsDateModel.fromJson(e)).toList();
}

Future<List<contTopic>> readJsonDataCT() async {
  final jsondata1 =
      await rootBundle.rootBundle.loadString('assets/contenidoTopic.json');
  final list1 = json.decode(jsondata1) as List<dynamic>;
  return list1.map((e) => contTopic.fromJson(e)).toList();
}
