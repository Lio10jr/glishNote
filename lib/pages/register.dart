import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wave/config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wave/wave.dart';

class registerAuth extends StatefulWidget {
  const registerAuth({Key? key}) : super(key: key);

  @override
  _StateregisterAuth createState() => _StateregisterAuth();
}

class _StateregisterAuth extends State<registerAuth> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _textCorreoController = TextEditingController();
  final TextEditingController _textContraController = TextEditingController();
  final TextEditingController _textUsernameController = TextEditingController();
  static const _backgroundColor = Color.fromARGB(169, 66, 0, 248);
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  bool imgExits = false;
  late String url;

  static const _colors = [
    Color.fromARGB(104, 255, 255, 255),
    Color.fromARGB(96, 224, 225, 255),
  ];

  static const _durations = [
    5000,
    4000,
  ];

  static const _heightPercentages = [
    0.65,
    0.66,
  ];
  Future _pickImageCamera() async {
    try {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 10);
      if (pickedImage == null) return;

      final pickedImageFile = File(pickedImage.path);

      setState(() {
        _pickedImage = pickedImageFile;
      });
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print("epa $e");
    }
  }

  void _pickImageGalery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });

    Navigator.pop(context);
  }

  void _pickImageRemove() async {
    setState(() {
      _pickedImage = null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Center(
          child: Stack(children: [
            WaveWidget(
              config: CustomConfig(
                colors: _colors,
                durations: _durations,
                heightPercentages: _heightPercentages,
              ),
              backgroundColor: _backgroundColor,
              size: const Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
            Container(
              margin: const EdgeInsets.only(left: 150, top: 50),
              child: CircleAvatar(
                radius: 61,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 58,
                  backgroundImage:
                      _pickedImage == null ? null : FileImage(_pickedImage!),
                ),
              ),
            ),
            Positioned(
                top: 120,
                left: 200,
                child: RawMaterialButton(
                    elevation: 10,
                    fillColor: Colors.white,
                    child: const Icon(Icons.camera_enhance),
                    padding: const EdgeInsets.all(15.0),
                    shape: const CircleBorder(),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                'Elija una opcion',
                                style: TextStyle(color: Colors.indigoAccent),
                              ),
                              content: SingleChildScrollView(
                                child: ListBody(children: [
                                  InkWell(
                                      splashColor: Colors.purpleAccent,
                                      onTap: () => _pickImageCamera(),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.camera,
                                              color: Colors.indigoAccent,
                                            ),
                                          ),
                                          Text(
                                            'Camara',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: ColorsConsts.title),
                                          ),
                                        ],
                                      )),
                                  InkWell(
                                      splashColor: Colors.purpleAccent,
                                      onTap: () => _pickImageGalery(),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.image,
                                              color: Colors.indigoAccent,
                                            ),
                                          ),
                                          Text(
                                            'Galeria',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: ColorsConsts.title),
                                          ),
                                        ],
                                      )),
                                  InkWell(
                                      splashColor: const Color.fromARGB(
                                          255, 217, 0, 255),
                                      onTap: () => _pickImageRemove(),
                                      child: Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: Colors.red,
                                            ),
                                          ),
                                          Text(
                                            'Eliminar',
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: ColorsConsts.title),
                                          ),
                                        ],
                                      )),
                                ]),
                              ),
                            );
                          });
                    })),
            Container(
              width: Size.infinite.width * 0.5,
              height: 500,
              margin: const EdgeInsets.only(left: 40, right: 40, top: 190),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                          controller: _textUsernameController,
                          maxLines: 1,
                          cursorHeight: 25,
                          cursorColor: Colors.red,
                          decoration: const InputDecoration(
                            labelText: "Nombre de Usuario",
                            labelStyle:
                                TextStyle(fontSize: 15.0, color: Colors.black),
                            suffixIcon:
                                Icon(Icons.person, color: Colors.purple),
                            border: InputBorder.none,
                          ),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (user) {
                            if (user!.isEmpty) {
                              return 'Ingrese un nombre de usuario';
                            } else {
                              return null;
                            }
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        controller: _textCorreoController,
                        maxLines: 1,
                        cursorHeight: 25,
                        cursorColor: Colors.red,
                        decoration: const InputDecoration(
                          labelText: "E-mail",
                          labelStyle:
                              TextStyle(fontSize: 15.0, color: Colors.black),
                          suffixIcon:
                              Icon(Icons.email_outlined, color: Colors.purple),
                          border: InputBorder.none,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (email) =>
                            email != null && !EmailValidator.validate(email)
                                ? 'Ingrese un E-mail valido'
                                : null,
                        keyboardType: TextInputType.emailAddress,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextFormField(
                        controller: _textContraController,
                        maxLines: 1,
                        cursorColor: Colors.red,
                        obscureText: true,
                        cursorHeight: 25,
                        decoration: const InputDecoration(
                          labelText: "Contraseña",
                          labelStyle:
                              TextStyle(fontSize: 15.0, color: Colors.black),
                          suffixIcon: Icon(Icons.lock_outline_rounded,
                              color: Colors.purple),
                          border: InputBorder.none,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => value != null && value.length < 6
                            ? 'La contraseña debe tener un minimo de 6 caracteres'
                            : null,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancelar",
                              style: TextStyle(color: Colors.purple),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              fixedSize: MaterialStateProperty.all(
                                  const Size.fromWidth(150)),
                            )),
                        ElevatedButton(
                          //onPressed: () => Get.offAllNamed("/principalSession"),
                          onPressed: signUp,
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.purple),
                              fixedSize: MaterialStateProperty.all(
                                  const Size.fromWidth(150))),
                          child: const Text("Registrar"),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    try {
      if (_pickedImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Necesita ingresar una Foto',
              style: TextStyle(color: Colors.red)),
          backgroundColor: Colors.white,
        ));
      } else {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _textCorreoController.text.trim(),
          password: _textContraController.text.trim(),
        );
        String urlImagen = _textUsernameController.text + '.jpg';
        final ref =
            FirebaseStorage.instance.ref().child('userImage').child(urlImagen);
        await ref.putFile(_pickedImage!);
        url = await ref.getDownloadURL();
        AppState().saveUsers(_textUsernameController.text,
            _textCorreoController.text, url);
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message.toString(),
            style: const TextStyle(color: Colors.red)),
        backgroundColor: Colors.white,
      ));
      //Utils.showSnackBar(e.message);
    }
  }
}
