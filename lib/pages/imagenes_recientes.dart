import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/entity/ImgCamera.dart';
import 'package:fastenglish/services/appState.dart';
import 'package:fastenglish/widgets/titulo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class ImagenesRecientes extends StatefulWidget {
  const ImagenesRecientes({Key? key}) : super(key: key);

  @override
  _ImagenesRecientesState createState() => _ImagenesRecientesState();
}

class _ImagenesRecientesState extends State<ImagenesRecientes> {
  final user = FirebaseAuth.instance.currentUser!;
  List<ImgCamera> listImg = [];
  String? scannedText;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    try {
      final DataSnapshot userDoc =
          await FirebaseDatabase.instance.ref().child('ImgCamera').get();
      if (userDoc.exists) {
        await AppState().obtenerImagenes(user.email!).then((value) {
          listImg = value;
        });
        setState(() {
          listImg;
        });
      }
    } catch (e) {
      print('A ocurrido un error al retornar la lista de imagenes.  $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(300.0),
        child: titulo(tema: "Actividad reciente de Imagenes"),
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
        child: listImg != []
            ? ListView.separated(
                itemCount: listImg.length,
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                itemBuilder: (BuildContext context, int index) {
                  final imageData = listImg[index];
                  return InkWell(
                    splashColor: ColorsConsts.backgroundColor,
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: imageData.nota));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Copiado con exito!",
                          style: GoogleFonts.ubuntu(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: ColorsConsts.white),
                        ),
                        backgroundColor: ColorsConsts.msgValidbackground,
                      ));
                    },
                    child: ListTile(
                      leading: Container(
                        width: 75,
                        height: 75,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imageData.imgurl),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      title: Text(imageData.img),
                      subtitle: Text("${imageData.fecha} ${imageData.hora}"),
                    ),
                  );
                })
            : const Icon(Icons.image_not_supported),
      ),
    );
  }
}
