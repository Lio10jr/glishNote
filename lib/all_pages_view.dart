import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/pages/Grammar.dart';
import 'package:fastenglish/pages/ListaApuntes.dart';
import 'package:fastenglish/pages/verbs.dart';
import 'package:fastenglish/pages/vocabulary.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllPageView extends StatefulWidget {
  const AllPageView({Key? key}) : super(key: key);

  @override
  _StateAllPageView createState() => _StateAllPageView();
}

class _StateAllPageView extends State<AllPageView> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              const Color(0x49FFD640), "contenido.png"),
          animatedPaddingPage(context, "Vocabulario", const vocabulary(), 1,
              const Color(0x4EFF5252), "vocabulario.png"),
          animatedPaddingPage(context, "Verbos", const verbs(), 2,
              const Color.fromARGB(77, 68, 137, 255), "verbos.png"),
          animatedPaddingPage(context, "Notas",  ListApuntes(), 3,
              const Color(0x4B69F0AF), "notas.png"),
        ],
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
                  color: Color.fromARGB(179, 233, 233, 233), // Color de la sombra
                  offset: Offset(1, 1), // Desplazamiento en X e Y
                  blurRadius: 2, // Radio de difuminación
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(color),
                        overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                          if (states.contains(MaterialState.focused)) {
                            return Colors.red;
                          }
                          return null; // Defer to the widget's default.
                        }),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => pag));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: Image.asset('assets/$img'),
                            /* width: MediaQuery.of(context).size.width */
                          ),
                          SizedBox(
                            height: 100,
                            /* width: MediaQuery.of(context).size.width, */
                            child: Center(
                              child: Text(
                                title,
                                style: GoogleFonts.ubuntu(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: ColorsConsts.primarybackground
                                ),
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
