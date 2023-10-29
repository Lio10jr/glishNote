import 'dart:async';
import 'dart:convert';
import 'package:fastenglish/entity/ContenidoPage.dart';
import 'package:fastenglish/entity/ContenidoPageTitulo.dart';
import 'package:fastenglish/entity/TopicE.dart';
import 'package:fastenglish/pages/login.dart';
import 'package:fastenglish/pages/verificarEmailPage.dart';
import 'package:fastenglish/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as rootBundle;
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isDarkMode = prefs.getBool('isDarkMode') ?? false;
  
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(isDarkMode), child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  StateMyApp createState() => StateMyApp();
}

class StateMyApp extends State<MyApp> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? metodo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Provider.of<ThemeProvider>(context).themeData,
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
        ));
  }
}

Future<List<contTopic>> readJsonDataCT() async {
  final jsondata1 =
      await rootBundle.rootBundle.loadString('assets/contenidoTopic.json');
  final list1 = json.decode(jsondata1) as List<dynamic>;
  return list1.map((e) => contTopic.fromJson(e)).toList();
}

Future<List<contenidoPage>> readJsonDataContainerPage() async {
  final jsondata1 =
      await rootBundle.rootBundle.loadString('assets/contenido_page.json');
  final list1 = json.decode(jsondata1) as List<dynamic>;
  return list1.map((e) => contenidoPage.fromJson(e)).toList();
}

List<ContenidoPageTitulo> contenidoPagesFromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return List<ContenidoPageTitulo>.from(jsonData.map((item) {
    return ContenidoPageTitulo.fromJson(item);
  }));
}

Future<List<ContenidoPageTitulo>> getContenidoPagesFromAssets() async {
  final jsonString =
      await rootBundle.rootBundle.loadString('assets/contenidoTopic.json');
  return contenidoPagesFromJson(jsonString);
}

Future<ContenidoPageTitulo> buscarContenidoPorTitulo(String titulo) async {
  final contenidoPages = await getContenidoPagesFromAssets();

  final resultado = contenidoPages.firstWhere((page) => page.titulo == titulo,
      orElse: () => ContenidoPageTitulo(
            titulo: 'No encontrado',
            utilizacion: 'No encontrado',
            contenido: [],
          ));
  return resultado;
}
