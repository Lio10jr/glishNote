import 'dart:async';
import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/pages/bottom_bar.dart';
import 'package:fastenglish/widgets/titulo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class verificarEmailPage extends StatefulWidget {

  @override
  verificarEmailPageState createState() => verificarEmailPageState();
}
class verificarEmailPageState extends State<verificarEmailPage> {
 
  bool isEmailVerificado = false; 
  Timer? timer;
  bool canReenvioEmail = false;

  @override
  void initState(){
    super.initState();
   
    isEmailVerificado = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerificado){
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
          (_) => checKEmailVerificado()
      );
    }
    
    
  }
  void dispose(){
    timer?.cancel();
    super.dispose();
  }
  Future checKEmailVerificado() async{
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerificado = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerificado) timer?.cancel();
  }

  Future sendVerificationEmail() async{
      try{
        final user = FirebaseAuth.instance.currentUser!;
        await user.sendEmailVerification();

        setState(() => canReenvioEmail = false);
        await Future.delayed(const Duration(seconds: 5));
        setState(() => canReenvioEmail = true);
      } catch (e){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString(),style: const TextStyle(color: Colors.white)),
              backgroundColor: ColorsConsts.msgErrbackground,
            )
        );
      }
  }

  @override
  Widget build(BuildContext context) => isEmailVerificado
      //? const PrincipalSession()
      ? BottomBarScreen()
      : Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(300.0),
          child: titulo(tema: "Verifica tu correo electrónico"),
        ),
        body: Container(
          width: Size.infinite.width,
          height: Size.infinite.height,
          margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.purple,
                  width: 1.5,
                ),
              ),
            ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Se ha enviado un correo de verificación a su email.',
                  style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,),
                const SizedBox(height: 24,),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: ColorsConsts.primarybackground
                    ),
                    onPressed: canReenvioEmail ? sendVerificationEmail : null,
                    icon: const Icon(Icons.email_outlined, size: 32,),
                    label: const Text('Reenviar correo',
                      style: TextStyle(fontSize: 24),),
                ),
                const SizedBox(height: 10,),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: ColorsConsts.endColor
                  ),
                  child: const Text("Cancelar", style: TextStyle(fontSize: 24),
                  ),
                  onPressed: () => FirebaseAuth.instance.signOut(),
                )
              ],
            ),
          ),
        ),

    );
}
