import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/pages/Grammar.dart';
import 'package:fastenglish/pages/ListaApuntes.dart';
import 'package:fastenglish/pages/verbs.dart';
import 'package:fastenglish/pages/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'all_app_bar.dart';

const IconData facebook = IconData(0xe255, fontFamily: 'MaterialIcons');

//PagSecundaria con sesion iniciada
class PrincipalSession extends StatefulWidget {
  const PrincipalSession({Key? key}) : super(key: key);

  @override
  stateHomePageSession createState() => stateHomePageSession();
}

class stateHomePageSession extends State<PrincipalSession> {
  int _currentPage = 0;
  List<Color> backgroundColors = [
    const Color(0xFF211F60),
    const Color(0xFF501E6B),
    const Color(0xFF211F60),
    const Color(0xFF501E6B),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: const Alignment(0.0, 0.0),
            end: const Alignment(0.25, 0.50),
            colors: <Color>[
              const Color(0xFFFFE162),
              backgroundColors[_currentPage],
            ],
          ),
        ),
        child: Column(
          children: [
            todoAppBarLog(),
            SizedBox(
              height: 400,
              child: PageView(
                controller: PageController(
                  viewportFraction: 0.8,
                ),
                onPageChanged: (newPage) {
                  setState(() {
                    _currentPage = newPage;
                  });
                },
                children: [
                  animatedPaddingPage(context, "Contenidos", const Grammar(), 0,
                      const Color(0x15FFD640), "contenido.png"),
                  animatedPaddingPage(
                      context,
                      "Vocabulario",
                      const vocabulary(),
                      1,
                      const Color(0x24FF5252),
                      "vocabulario.png"),
                  animatedPaddingPage(context, "Verbos", const verbs(), 2,
                      const Color(0x2B4489FF), "verbos.png"),
                  animatedPaddingPage(context, "Notas", ListApuntes(), 3,
                      const Color(0x1F69F0AF), "notas.png"),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  AnimatedPadding animatedPaddingPage(BuildContext context, String title,
      Widget pag, int num, Color color, String img) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      padding: _currentPage == num
          ? const EdgeInsets.all(0)
          : const EdgeInsets.symmetric(vertical: 30),
      child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: 0.8,
          child: Container(
            width: 20,
            margin: const EdgeInsets.only(
              right: 30,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(179, 233, 233, 233),
                  offset: Offset(1, 1),
                  blurRadius: 2,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(color),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.focused)) {
                            return Colors.red;
                          }
                          return null;
                        }),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => pag));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 200,
                            child: Image.asset('assets/$img'),
                          ),
                          SizedBox(
                            height: 100,
                            child: Center(
                              child: Text(
                                title,
                                style: GoogleFonts.ubuntu(
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold,
                                    color: ColorsConsts.primarybackground),
                              ),
                            ),
                          ),
                        ],
                      ))),
            ),
          )),
    );
  }
}
