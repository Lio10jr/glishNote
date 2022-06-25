import 'package:flutter/material.dart';

class Configuracion extends StatefulWidget {
  @override
  _ConfiguracionState createState() => _ConfiguracionState();
}

class _ConfiguracionState extends State<Configuracion>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('_ConfiguracionState'),
        ),
        body: Center(
          child: Container(
            child: Text('_ConfiguracionState'),
          ),
        ),
      ),
    );
  }
}
