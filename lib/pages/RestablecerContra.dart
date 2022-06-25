import 'dart:ui';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RestablecerContra extends StatefulWidget{
  const RestablecerContra({Key? key}) : super(key: key);

  _RestablecerContraState createState() => _RestablecerContraState();
}
class _RestablecerContraState  extends State<RestablecerContra> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _textCorreoController = TextEditingController();
  //TextEditingController _textContraController = TextEditingController();

  @override
  void dispose(){
    _textCorreoController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    backgroundColor: Colors.black54,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Restablecer Contraseña'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Ingrese un email, para recibir un correo electronico y restablecer su contraseña",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.white),),
                const SizedBox(height: 20,),
                Container(
                  decoration: BoxDecoration(color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(5)),
                  child: TextFormField(
                    controller: _textCorreoController,
                    maxLines: 1,
                    cursorHeight: 25,
                    cursorColor: Colors.blue,
                    decoration: const InputDecoration(
                      labelText: "E-mail",
                      labelStyle: TextStyle(fontSize: 15.0,color: Colors.black),
                      suffixIcon: Icon(Icons.email_outlined,
                          color: Colors.purple),
                      border: InputBorder.none,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>  email != null && !EmailValidator.validate(email)
                        ? 'Ingrese un E-mail valido'
                        : null,
                  ),
                ),
                const SizedBox(height: 20,),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: verificarEmail,
                    icon: const Icon(Icons.email_outlined),
                    label: const Text('Restablecer contraseña',
                    style: TextStyle(fontSize: 24),))
              ],
            ),
          )
        ),
    );
  Future verificarEmail() async{
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _textCorreoController.text.trim());

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Se ha enviado un correo electronico para restablecer su contraseña',
                style: TextStyle(color: Colors.red)),
            backgroundColor: Colors.white,
          )
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }on FirebaseAuthException catch(e){
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                e.message.toString(),
                style: const TextStyle(color: Colors.red)),
            backgroundColor: Colors.white,
          )
      );
      Navigator.of(context).pop();
    }
  }
  }

