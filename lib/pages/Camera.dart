import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../services/appState.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final user = FirebaseAuth.instance.currentUser!;
  File? _pickedImage;
  bool imgExits = false;
  late String url;
  String scannedText = "";
  XFile? _imgBD;

  Future _pickCamera() async {
    try {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);
      if (pickedImage == null) return;

      final pickedImageFile = File(pickedImage.path);
 
        setState(() {
          _imgBD = pickedImage;
          _pickedImage = pickedImageFile;
          imgExits = true;
        });
              
      getRecognisedText(pickedImage);
    } on PlatformException catch (e) {
      print("Error al obtener imagen de camara. $e");
    }
  }

  Future _pickGalery() async {
    try {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 10);
      if (pickedImage == null) return;

      final pickedImageFile = File(pickedImage.path);

      setState(() {
        _pickedImage = pickedImageFile;
        imgExits = true;
      });
      getRecognisedText(pickedImage);
    } on PlatformException catch (e) {
      print("Error al obtener imagen de galeria. $e");
    }
  }

  Future _pickImageRemove() async {
    setState(() {
      _pickedImage = null;
      imgExits = false;
      scannedText = "";
    });
  }

Future _pickGuardado() async{
    String urlImagen = _imgBD!.name;
    final ref =
           FirebaseStorage.instance.ref().child('ImgCamera').child(urlImagen);

    await ref.putFile(_pickedImage!);
        url = await ref.getDownloadURL();
        DateTime date = DateTime.now();
        DateFormat formatter =DateFormat('yyyy-MM-dd');
        String fecha = formatter.format(date);
        String hora = date.hour.toString();
        await AppState().saveImagenes(user.email!, url, fecha, hora);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Opciones de Camara'),
        ),
        body: Stack(
          children: [
            Positioned(top: 0, child: BacdgroundCamera()),
            Positioned(
              right: 0,
              top: 0,
              child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.greenAccent)),
                onPressed: (){
                  _pickGuardado();
                  Navigator.push(context,
                          MaterialPageRoute(builder: (context) => textScan( texto: scannedText,)));
                },
                
                icon: const Icon(Icons.document_scanner, color: Colors.white),
                label: const Text('Convertir a Texto',style: TextStyle(color: Colors.white),),
              ),
            ),
            Positioned(
              right: 0,
              top: 70,
              child: TextButton.icon(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
                onPressed: () {
                   _pickImageRemove();
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Imagen eliminada!", style: TextStyle(color: Colors.black),),
                      backgroundColor: Colors.white,
                    ));
                   },
                icon: const Icon(Icons.remove_circle, color: Colors.white),
                label: const Text(
                  'Remover imagen',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.add_event,
            backgroundColor: Colors.orange.shade900,
            closeManually: true,
            children: [
              SpeedDialChild(
                  child: const Icon(Icons.camera_alt),
                  label: 'Camara',
                  onTap: () => _pickCamera()),
              SpeedDialChild(
                  child: const Icon(Icons.image),
                  label: 'Galeria',
                  onTap: () => _pickGalery()),
            ]));
  }

  Widget BacdgroundCamera() {
    if (imgExits == false) {
      return Container(
        height: 200,
        width: 200,
        decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.white, blurRadius: 1.0),
          ],
        ),
      );
    } else {
      return SizedBox(
          width: 410,
          height: 600,
          child: Image.file(
            _pickedImage!,
            fit: BoxFit.contain,
          ));
    }
  }

  void getRecognisedText(XFile imagen) async {
    final inputImagen = InputImage.fromFilePath(imagen.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText =
        await textDetector.processImage(inputImagen);
    await textDetector.close();

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";
      }
    }
  }
}

// ignore: camel_case_types
class textScan extends StatefulWidget {
  String texto;
  textScan({Key? key, required this.texto}) : super(key: key);

  @override
  State<textScan> createState() => _textScanState();
}

// ignore: camel_case_types
class _textScanState extends State<textScan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Texto Reconocido'),
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: widget.texto));
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Copiado con exito!", style: TextStyle(color: Colors.black),),
                      backgroundColor: Colors.white,
                    ));
                  },
                  icon: const Icon(Icons.copy_all, size: 20, color: Colors.white),
                  label: const Text('Copiar todo', style: TextStyle(fontSize: 20, color: Colors.white), ))
            ],
          ),
          
        ),
        body: SingleChildScrollView(child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text(widget.texto))));
  }
}