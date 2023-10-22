import 'dart:io';
import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/pages/text_scan.dart';
import 'package:fastenglish/widgets/app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import '../services/appState.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_cropper/image_cropper.dart';

class Camera extends StatefulWidget {
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final user = FirebaseAuth.instance.currentUser!;  
  bool imgExits = false;
  late String url;
  String scannedText = "";

  File? _pickedImage;
  final picker = ImagePicker();

@override
  void initState() {
    super.initState();
    requestPermissions();
  }

  void requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
    ].request();
    if (statuses[Permission.storage]!.isGranted && statuses[Permission.camera]!.isGranted) {
    } else {
      print('Permiso Denegado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: app_bar(
              title: "Camara",
            )),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.document_scanner_outlined,
                    color: ColorsConsts.endColor,
                  ),
                  onPressed: () async {
                    _pickGuardado();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => textScan(
                                  texto: scannedText,
                                )));
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.clear_all,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _pickImageRemove();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "Imagen eliminada!",
                        style: GoogleFonts.ubuntu(
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                            color: ColorsConsts.white),
                      ),
                      backgroundColor: ColorsConsts.msgErrbackground,
                    ));
                  },
                ),
              ],
            ),
            BacdgroundCamera(),
          ],
        ),        
        floatingActionButton: SpeedDial(
            animatedIcon: AnimatedIcons.menu_close,
            backgroundColor: ColorsConsts.primarybackground,
            closeManually: true,
            children: [
              SpeedDialChild(
                  child: const Icon(Icons.camera_alt),
                  label: 'Camara',
                  onTap: () => _imgFromCamera()),
              SpeedDialChild(
                  child: const Icon(Icons.image),
                  label: 'Galeria',
                  onTap: () => _imgFromGallery()),
            ]));
  }

  // ignore: non_constant_identifier_names
  Widget BacdgroundCamera() {
    if (imgExits == false) {
      return Container(
        alignment: Alignment.center,
        child: const Center(
          child: Icon(
            Icons.image_sharp,
            size: 250.0,
            color: Color(0x847B7979),
          ),
        ),
      );
    } else {
      return ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
                child: Image.file(_pickedImage!, height: 400.0, width: 400.0, fit: BoxFit.contain,)
            );      
    }
  }

  Future _pickImageRemove() async {
    setState(() {
      _pickedImage = null;
      imgExits = false;
      scannedText = "";
    });
  }

  Future _pickGuardado() async {
    if (scannedText.isNotEmpty) {
      String imgName = generarNombreArchivoImg();
      final firebaseStorageRef = FirebaseStorage.instance.ref().child('ImgCamera').child(imgName);
      await firebaseStorageRef.putFile(_pickedImage!);

      final ref =
          FirebaseStorage.instance.ref().child('ImgCamera').child(imgName);

      await ref.putFile(_pickedImage!);
      url = await ref.getDownloadURL();
      DateTime date = DateTime.now();
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      String fecha = formatter.format(date);
      String hora = date.hour.toString();
      await AppState()
          .saveImagenes(user.email!, imgName, url, fecha, hora, scannedText);
    }
  }

  String generarNombreArchivoImg() {
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');
    final timestamp = formatter.format(now);
    final random = DateTime.now().microsecond.toString();
    return 'image_$timestamp$random.jpg';
  }
  
  _imgFromGallery() async {
      await  picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50
      ).then((value){
        if(value != null){
          _cropImage(File(value.path));
        }
      });
    }

  _imgFromCamera() async {
      await picker.pickImage(
          source: ImageSource.camera, imageQuality: 50
      ).then((value){
        if(value != null){
          _cropImage(File(value.path));
        }
      });
    }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ] : [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio5x3,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio7x5,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [AndroidUiSettings(
            toolbarTitle: "Modificar",
            toolbarColor: ColorsConsts.primarybackground,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
          IOSUiSettings(
            title: "Modificar",
          )
        ]);
    if (croppedFile != null) {
      XFile xFile = XFile(croppedFile.path);
      imageCache.clear();
      setState(() {
        _pickedImage = File(croppedFile.path);
        imgExits = true;
      });
      getRecognisedText(xFile);
      // reload();
    }
  }
  
  getRecognisedText(XFile imagen) async {
    final inputImagen = InputImage.fromFilePath(imagen.path);
    final textDetector = GoogleMlKit.vision.textRecognizer();
    RecognizedText recognisedText =
        await textDetector.processImage(inputImagen);
    await textDetector.close();

    for (TextBlock block in recognisedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText = "$scannedText${line.text}\n";
      }
    }
  }
}
