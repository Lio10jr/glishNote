import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../services/userState.dart';

class registerAuth extends StatefulWidget {
  const registerAuth({Key? key}) : super(key: key);

  @override
  stateregisterAuth createState() => stateregisterAuth();
}

class stateregisterAuth extends State<registerAuth> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _textCorreoController = TextEditingController();
  final TextEditingController _textContraController = TextEditingController();
  final TextEditingController _textUsernameController = TextEditingController();
  /* final ImagePicker _picker = ImagePicker(); */
  File? _pickedImage;
  bool imgExits = false;
  late String url;

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
      print("Error al cargar la Imagen en: $e");
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
        body: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Colors.white,
            Color(0xFF9D11B2),
            Color(0xFF9D11B2),
          ], begin: Alignment(0.6, 0.8), end: Alignment(0.80, 0.80))),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: const text_title(
                              size: 30,
                              titulo: "REGISTRARSE",
                              fontw: FontWeight.w800,
                              color: Colors.black),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF9D11B2),
                                border:
                                    Border.all(color: const Color(0xffF0EDD4)),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: _textUsernameController,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  labelText: "Nombre de usuario",
                                  labelStyle: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: Icon(Icons.person_2_outlined,
                                      color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo Obligatorio';
                                  } else if (value.length < 5) {
                                    return 'Minimo 5 Caracteres';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF9D11B2),
                                border:
                                    Border.all(color: const Color(0xffF0EDD4)),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: _textCorreoController,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  labelText: "Correo",
                                  labelStyle: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: Icon(Icons.email_outlined,
                                      color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo Obligatorio';
                                  } else if (!EmailValidator.validate(value)) {
                                    return 'Ingrese un Correo valido';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF9D11B2),
                                border:
                                    Border.all(color: const Color(0xffF0EDD4)),
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: TextFormField(
                                controller: _textContraController,
                                maxLines: 1,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: "Contraseña",
                                  labelStyle: TextStyle(
                                    fontSize: 15.0,
                                    color: Colors.white,
                                  ),
                                  suffixIcon: Icon(Icons.lock_outline_rounded,
                                      color: Colors.white),
                                  border: InputBorder.none,
                                ),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo Obligatorio';
                                  } else if (value.length < 6) {
                                    return 'Debe contener al menos 6 caracteres';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 100,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 61,
                                backgroundColor: ColorsConsts.endColor,
                                child: CircleAvatar(
                                  radius: 58,
                                  backgroundImage: _pickedImage == null
                                      ? null
                                      : FileImage(_pickedImage!),
                                ),
                              ),
                              Positioned(
                                  bottom: 0,
                                  left: 70,
                                  width: 50,
                                  child: RawMaterialButton(
                                      elevation: 10,
                                      fillColor: Colors.white,
                                      padding: const EdgeInsets.all(15.0),
                                      shape: const CircleBorder(),
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                  'Elija una opcion',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.indigoAccent),
                                                ),
                                                content: SingleChildScrollView(
                                                  child: ListBody(children: [
                                                    InkWell(
                                                        splashColor:
                                                            Colors.purpleAccent,
                                                        onTap: () =>
                                                            _pickImageCamera(),
                                                        child: Row(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                Icons.camera,
                                                                color: Colors
                                                                    .indigoAccent,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Camara',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      ColorsConsts
                                                                          .title),
                                                            ),
                                                          ],
                                                        )),
                                                    InkWell(
                                                        splashColor:
                                                            Colors.purpleAccent,
                                                        onTap: () =>
                                                            _pickImageGalery(),
                                                        child: Row(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                Icons.image,
                                                                color: Colors
                                                                    .indigoAccent,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Galeria',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      ColorsConsts
                                                                          .title),
                                                            ),
                                                          ],
                                                        )),
                                                    InkWell(
                                                        splashColor: const Color
                                                            .fromARGB(
                                                            255, 217, 0, 255),
                                                        onTap: () =>
                                                            _pickImageRemove(),
                                                        child: Row(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: Icon(
                                                                Icons
                                                                    .remove_circle,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            ),
                                                            Text(
                                                              'Eliminar',
                                                              style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      ColorsConsts
                                                                          .title),
                                                            ),
                                                          ],
                                                        )),
                                                  ]),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(
                                                            context, 'Cancel'),
                                                    child: const Text(
                                                      'Cerrar',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      child: const Icon(Icons.camera_enhance))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.white),
                                  fixedSize: MaterialStateProperty.all(
                                      const Size.fromWidth(150)),
                                ),
                                child: const Text(
                                  "Cancelar",
                                  style: TextStyle(color: Colors.purple),
                                )),
                            ElevatedButton(
                              onPressed: signUp,
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      const Color(0xFF4611B2)),
                                  fixedSize: MaterialStateProperty.all(
                                      const Size.fromWidth(150))),
                              child: const Text("Registrarse"),
                            )
                          ],
                        ),
                      ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signUp() async {
    try {
      if (_formKey.currentState!.validate()) {
        if (_pickedImage == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('La foto es requerida',
                style: TextStyle(color: Colors.white)),
            backgroundColor: ColorsConsts.msgErrbackground,
          ));
        } else {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _textCorreoController.text.trim(),
            password: _textContraController.text.trim(),
          );
          // ignore: prefer_interpolation_to_compose_strings
          String urlImagen = _textUsernameController.text + '.jpg';
          final ref = FirebaseStorage.instance
              .ref()
              .child('userImage')
              .child(urlImagen);
          await ref.putFile(_pickedImage!);
          url = await ref.getDownloadURL();
          userState().saveUsers(
              _textUsernameController.text, _textCorreoController.text, url);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Cuenta creada satisfactoriamente',
                style: TextStyle(color: Colors.white)),
            backgroundColor: ColorsConsts.msgValidbackground,
          ));
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Todos los campos son requeridos.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: ColorsConsts.msgErrbackground,
        ));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Error al crear la cuenta, intentelo nuevamente.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorsConsts.msgErrbackground,
      ));
    }
  }
}
