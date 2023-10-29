// ignore_for_file: unused_field
import 'dart:async';
import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/widgets/titulo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';
import 'package:text_to_speech/text_to_speech.dart';
import 'package:volume_controller/volume_controller.dart';

class PageTranslation extends StatefulWidget {
  const PageTranslation({Key? key}) : super(key: key);

  @override
  _StatepagTranslation createState() => _StatepagTranslation();
}

class _StatepagTranslation extends State<PageTranslation> {
  final String defaultLanguage = 'en-US';

  TextToSpeech tts = TextToSpeech();

  String text = '';
  double volume = 1; // Range: 0-1
  double rate = 0.0; // Range: 0-2
  double pitch = 0.0; // Range: 0-2

  String? language;
  String? languageCode;
  List<String> languages = <String>[];
  List<String> languageCodes = <String>[];
  String? voice;

  double _volumeListenerValue = 0;
  double _getVolume = 0;
  double _setVolumeValue = 0;

  String combo = "Español";
  String idomaTranslation = "Ingles";
  TextEditingController textContr = TextEditingController();

  var resulT = "";
  var translator = GoogleTranslator();
  String idiomE = 'es';
  String idiomS = 'en';

  @override
  void initState() {
    super.initState();
    textContr.text = text;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      initLanguages();
    });

    VolumeController().listener((volume) {
      setState(() => _volumeListenerValue = volume);
    });

    VolumeController().getVolume().then((volume) => _setVolumeValue = volume);
  }

  Future<void> initLanguages() async {
    /// populate lang code (i.e. en-US)
    languageCodes = await tts.getLanguages();

    /// populate displayed language (i.e. English)
    final List<String>? displayLanguages = await tts.getDisplayLanguages();
    if (displayLanguages == null) {
      return;
    }

    languages.clear();
    for (final dynamic lang in displayLanguages) {
      languages.add(lang as String);
    }

    final String? defaultLangCode = await tts.getDefaultLanguage();
    if (defaultLangCode != null && languageCodes.contains(defaultLangCode)) {
      languageCode = defaultLangCode;
    } else {
      languageCode = defaultLanguage;
    }
    language = await tts.getDisplayLanguageByCode(languageCode!);

    /// get voice
    voice = await getVoiceByLang(languageCode!);

    if (mounted) {
      setState(() {});
    }
  }

  Future<String?> getVoiceByLang(String lang) async {
    final List<String>? voices = await tts.getVoiceByLang(languageCode!);
    if (voices != null && voices.isNotEmpty) {
      return voices.first;
    }
    return null;
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
              scrollDirection: Axis.vertical,
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
                              if (combo == "Español") {
                                idomaTranslation = "Ingles";
                                idiomE = 'en';
                                idiomS = 'es';
                              } else if (combo == "Ingles") {
                                idomaTranslation = "Español";
                                idiomE = 'es';
                                idiomS = 'en';
                              }
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
                              fontWeight: FontWeight.w300,),
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
                  color: Colors.transparent,
                  child: TextField(
                    scrollController: ScrollController(keepScrollOffset: false),
                    style: GoogleFonts.ubuntu(
                        fontSize: 15,
                        fontWeight: FontWeight.w300),
                    controller: textContr,
                    onChanged: (val) async {
                      try {
                        final translation =
                            await val.translate(from: idiomE, to: idiomS);
                        setState(() {
                          resulT = translation.text;
                        });
                      } catch (e) {
                        print('error:' + e.toString());
                        setState(() {
                          resulT = '';
                        });
                      }
                    },
                    maxLength: 500,
                    maxLines: 10,
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
                            fontSize: 15,
                            fontWeight: FontWeight.w300),
                      ))),
                ),
                const SizedBox(
                  height: 15,
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
                        text = resulT;
                        volume = await VolumeController().getVolume();
                        speak();
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

  void speak() {
    tts.setVolume(volume);
    tts.setRate(rate);
    tts.setLanguage(languageCode!);
    tts.setPitch(pitch);
    tts.speak(text);
  }
}
