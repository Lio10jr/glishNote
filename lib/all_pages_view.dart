import 'package:fastenglish/pages/Grammar.dart';
import 'package:fastenglish/pages/verbs.dart';
import 'package:fastenglish/pages/vocabulary.dart';
import 'package:flutter/material.dart';

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
      height: 300,
      width: MediaQuery.of(context).size.width,
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
          animatedPaddingPage(context, "TEMAS", const Grammar(), 0),
          animatedPaddingPage(context, "VOCABULARIO", const vocabulary(), 1),
          animatedPaddingPage(context, "VERBOS", const verbs(), 2),          
        ],
      ),
    );
  }

  AnimatedPadding animatedPaddingPage(BuildContext context, String title, Widget pag, int num) {
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
                  right: 50,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                          style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange.shade900),
                            overlayColor: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.focused)) {
                                    return Colors.red;
                                  }
                                  return null; // Defer to the widget's default.
                                }
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => pag));
                          },
                          child: Column(
                            children: [
                              Container(
                                color: Colors.white,
                                height: 175,
                                width: MediaQuery.of(context).size.width,
                              ),
                              SizedBox(
                                height: 25,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text(title,
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      )

                  ),
                ),
              )),
        );
  }
}