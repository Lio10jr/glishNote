import 'package:email_validator/email_validator.dart';
import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/pages/RestablecerContra.dart';
import 'package:fastenglish/pages/register.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../services/userState.dart';

class login extends StatefulWidget {
  @override
  _StateLogin createState() => _StateLogin();
}

class _StateLogin extends State<login> {
  final TextEditingController _textCorreoController = TextEditingController();
  final TextEditingController _textContraController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Color backColor = const Color(0x974711B2);
  List<Color> listColorValidation = [
    const Color(0x974711B2),
    const Color(0x95B21139),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: <Color>[
            Colors.white,
            Color(0xFF4611B2),
            Color(0xFF4611B2),
          ], begin: Alignment(0.6, 0.8), end: Alignment(0.80, 0.80))),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          vertical: 80, horizontal: 10),
                      child: const text_title(
                          size: 30,
                          titulo: "INICIAR SESIÓN",
                          fontw: FontWeight.w800,
                          color: Colors.black),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0x974711B2),
                                  border: Border.all(
                                      color: const Color(0xffF0EDD4)),
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
                                    } else if (!EmailValidator.validate(
                                        value)) {
                                      return 'Ingrese un Correo valido';
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: const Color(0x974711B2),
                                  border: Border.all(
                                      color: const Color(0xffF0EDD4)),
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
                                  keyboardType: TextInputType.emailAddress,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "¿No tienes una cuenta?, ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 13),
                              ),
                              TextButton(
                                onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const registerAuth()),
                                  )
                                },
                                child: const Text(
                                  "Registrate Aqui",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const RestablecerContra())),
                            child: const Text(
                              "¿Olvidaste tu contraseña?",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: signIn,
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.purple),
                          fixedSize: MaterialStateProperty.all(
                              const Size.fromWidth(150))),
                      child: const Text("Ingresar"),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        margin: const EdgeInsets.only(top: 50),
                        child: const Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Color(0xFF4611B2),
                                  thickness: 2,
                                ),
                              ),
                            ),
                            Text(' O '),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: Color(0xFF4611B2),
                                  thickness: 2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Container(
                        width: Size.infinite.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 22, 26, 248),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton.icon(
                          icon: const Icon(
                            Icons.facebook,
                            size: 20,
                            color: Colors.white,
                          ),
                          label: const Text('Iniciar con Facebook',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.white)),
                          onPressed: _signFaceboock,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future signIn() async {
    try {
      if (_formKey.currentState!.validate()) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _textCorreoController.text.trim(),
          password: _textContraController.text.trim(),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Credenciales incorrectas.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: ColorsConsts.msgErrbackground,
        ));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Error al iniciar sesión.",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: ColorsConsts.msgErrbackground,
        ));
    }
  }

  Future _signFaceboock() async {
    try {
      final faceLogin = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();

      final facebookAuthCredential =
          FacebookAuthProvider.credential(faceLogin.accessToken!.token);
      await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

      String userName = userData['name'].toString();
      String email = userData['email'].toString();
      String image = userData['picture']['data']['url'].toString();
      userState().saveUsers(userName, email, image);
    } on FirebaseAuthException catch (e) {
      print(e.message.toString());
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Ocurrio un Error al iniciar con Facebook",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
      ));
    }
  }
}
