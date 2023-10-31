import 'dart:async';
import 'dart:io' show Platform;
import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/widgets/titulo.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';
import 'package:flutter_tts/flutter_tts.dart';

class PageTranslation extends StatefulWidget {
  const PageTranslation({Key? key}) : super(key: key);

  @override
  _StatepagTranslation createState() => _StatepagTranslation();
}

class _StatepagTranslation extends State<PageTranslation> {
  final FlutterTts flutterTts = FlutterTts();
  String selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    defaultConfigVoice();
  }

  defaultConfigVoice() async {
    try {
      await flutterTts.setLanguage('en-US');
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.setPitch(1.0);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Error al configurar TTS.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorsConsts.msgErrbackground,
      ));
    }
  }

  String combo = "Español";
  String idomaTranslation = "Ingles";
  TextEditingController textContr = TextEditingController();

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  var resulT = "";
  var translator = GoogleTranslator();
  String idiomE = 'es';
  String idiomS = 'en';

  Future<void> translateText() async {
    final translator = GoogleTranslator();
    try {
      final translation = await translator.translate(
        textContr.text,
        from: selectedLanguage == 'en' ? 'en' : 'es',
        to: selectedLanguage == 'en' ? 'es' : 'en',
      );
      setState(() {
        resulT = translation.text;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Error de traducción.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorsConsts.msgErrbackground,
      ));
    }
  }

  Future<void> speakTranslatedText() async {
    await flutterTts.setLanguage(selectedLanguage == 'en' ? 'es-ES' : 'en-US');
    await flutterTts.speak(resulT);
  }

  void updateVoiceSettings() async {
    String languageCode = selectedLanguage == 'en' ? 'en-US' : 'es-ES';
    try {
      await flutterTts.setLanguage(languageCode);
      // Ajusta otras configuraciones según sea necesario
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Error al actualizar la configuración de voz.",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ColorsConsts.msgErrbackground,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(300.0),
          child: titulo(tema: "Traductor"),
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
            padding: const EdgeInsets.all(10.0),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        DropdownButton<String>(
                          value: combo,
                          icon: const Icon(Icons.arrow_right),
                          elevation: 16,
                          style: GoogleFonts.ubuntu(
                              fontWeight: FontWeight.w600,
                              color: ColorsConsts.primarybackground),
                          underline: Container(
                            height: 2,
                            color: ColorsConsts.primarybackground,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                          onChanged: (String? newValue) {
                            setState(() {
                              combo = newValue!;
                              if (combo != "Español") {
                                idomaTranslation = "Ingles";
                                idiomE = 'en';
                                idiomS = 'es';
                                selectedLanguage = 'en';
                              } else if (combo != "Ingles") {
                                idomaTranslation = "Español";
                                idiomE = 'es';
                                idiomS = 'en';
                                selectedLanguage = 'es';
                              }
                              updateVoiceSettings();
                            });
                          },
                          items: <String>['Ingles', 'Español']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        Text(
                          idomaTranslation,
                          style: GoogleFonts.ubuntu(
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: Icon(
                          Icons.clear_all,
                          color: ColorsConsts.endColor,
                        ),
                        onPressed: () {
                          setState(() {
                            resulT = '';
                            textContr.clear();
                          });
                        },
                      ),
                    )
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: 220,
                  child: TextField(
                    scrollController: ScrollController(keepScrollOffset: false),
                    style: GoogleFonts.ubuntu(
                        fontSize: 15, fontWeight: FontWeight.w300),
                    controller: textContr,
                    onChanged: (val) async {
                      try {
                        final translation =
                            await val.translate(from: idiomE, to: idiomS);
                        setState(() {
                          resulT = translation.text;
                        });
                      } catch (e) {
                        setState(() {
                          resulT = '';
                        });
                      }
                    },
                    maxLength: 500,
                    maxLines: 10,
                    cursorColor:
                        Theme.of(context).primaryColor.withOpacity(0.6),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Container(
                  width: double.infinity,
                  height: 230,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: SingleChildScrollView(
                          child: Text(
                        resulT,
                        style: GoogleFonts.ubuntu(
                            fontSize: 15, fontWeight: FontWeight.w300),
                      ))),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.volume_up_outlined,
                        color: ColorsConsts.endColor,
                      ),
                      onPressed: () async {
                        /* volume = await VolumeController().getVolume(); */
                        speakTranslatedText();
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.copy_rounded,
                        color: ColorsConsts.endColor,
                      ),
                      onPressed: () {
                        setState(() {
                          Clipboard.setData(ClipboardData(text: resulT));
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
