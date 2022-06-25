import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/translator.dart';

class PageTranslation extends StatefulWidget {
  const PageTranslation({Key? key}) : super(key: key);

  @override
  _StatepagTranslation createState() => _StatepagTranslation();
}

class _StatepagTranslation extends State<PageTranslation> {
  String combo = "Español";
  String idomaTranslation = "Ingles";
  TextEditingController textContr = TextEditingController();
  var resulT = "";
  var translator = GoogleTranslator();
  String idiomE = 'es';
  String idiomS = 'en';

  @override
  Widget build(BuildContext context) {
    //final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[900]?.withOpacity(0.9),
          title: const Text("Translation"),
        ),
        body: Container(
          margin: const EdgeInsets.only(right: 15, left: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                          style: const TextStyle(color:  Color.fromARGB(255, 255, 187, 0)),
                          underline: Container(
                            height: 2,
                            color: const Color.fromARGB(255, 255, 187, 0),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              combo = newValue!;
                              if (combo.compareTo("Español") == 0) {
                                idomaTranslation = "Ingles";
                                idiomE = "es";
                                idiomS = "en";
                              } else {
                                idomaTranslation = "Español";
                                idiomE = "en";
                                idiomS = "es";
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
                        Text(idomaTranslation),
                      ],
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red.shade300,
                        ),
                        onPressed: () {
                          resulT = '';
                          textContr.clear();
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
                    scrollController:
                        ScrollController(keepScrollOffset: false),
                    controller: textContr,
                    onChanged: (val) {
                      setState(() {
                        translator
                            .translate(textContr.text,
                                from: idiomE, to: idiomS)
                            .then((value) {
                          setState(() {
                            resulT = value.toString();
                          });
                        });
                      });
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
                  //color: Colors.white,
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.blue)),
                      child: SingleChildScrollView(
                        child: Text(
                          resulT, 
                          style: const TextStyle())
                          )
                        ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: Icon(
                        Icons.copy_all,
                        size: 30,
                        color: Colors.green.shade900,
                      ),
                      onPressed: () {
                        setState(() {
                          Clipboard.setData(ClipboardData(text: resulT));
                        });
                      },
                      label: const Text("Copiar todo", style: TextStyle(color: Colors.white),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green),
                      ),                       
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
