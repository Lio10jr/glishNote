
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:fastenglish/main.dart';


class verbs extends StatefulWidget {
  const verbs({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
String busVerb="";



class _MyHomePageState extends State<verbs> {

  late List<VerbsDateModel> listV;
  late List<VerbsDateModel> listSearch= [] as List<VerbsDateModel>;

  final TextEditingController? _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
          backgroundColor: Colors.amberAccent,
          appBar: AppBar(
            backgroundColor: Colors.orange[900]?.withOpacity(0.9),
            title: Container(
              decoration: BoxDecoration(color: Colors.amber.shade200,
              borderRadius: BorderRadius.circular(30)),
              child: TextField(
                onChanged: (value){
                  setState(() {
                    listSearch = listV.where(((element) => element.simpleForm!.toLowerCase().contains(value.toLowerCase())))
                    .toList();
                  });
                },
                controller: _textEditingController,
                decoration:  InputDecoration(
                    suffixIcon:  IconButton(
                      icon:  const Icon(Icons.clear),
                      onPressed: (){
                        setState(() {
                          _textEditingController!.clear();
                        });
                      },
                    ),
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(15),
                  hintText: 'Search'
                ),
              ),
            ),
          ),

        body: FutureBuilder(
          future: ReadJsonData(),
          builder: (context,data){
            if(data.hasError){
              return Center(child: Text("${data.error}"));
            }else if(data.hasData){
              var items =data.data as List<VerbsDateModel>;
              listV = items;
              return ListView.builder(
                itemCount: _textEditingController!.text.isNotEmpty ? listSearch.length: listV.length,
                itemBuilder: (context,index){
                  return Card(
                    elevation: 5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 90,
                          width: 80,
                          child: Column(
                            children: [
                              Text(
                                  _textEditingController!.text.isNotEmpty
                                  ? "\n" +listSearch[index].simpleForm.toString()
                              : "\n" +listV[index].simpleForm.toString(),
                                  style: const TextStyle(color: Colors.red, fontSize: 12.0, fontWeight: FontWeight.bold)),
                              Text(_textEditingController!.text.isNotEmpty
                                  ? "\n" +listSearch[index].meaning.toString()
                                  : listV[index].meaning.toString(),
                                  style: const TextStyle(color: Colors.blue, fontSize: 12.0)),
                            ],
                          ),
                        ),
                        Expanded(child: Column(
                          children: [
                            const Text("Simple Past",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
                            Text(_textEditingController!.text.isNotEmpty
                                ? listSearch[index].simplePast.toString()
                                : listV[index].simplePast.toString(),),

                          ],
                        ),
                        ),
                        Expanded(child: Column(
                          children: [
                            const Text("Third Person",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
                            Text(_textEditingController!.text.isNotEmpty
                                ? listSearch[index].thirdPerson.toString()
                                : listV[index].thirdPerson.toString()),
                          ],
                        ),
                        ),
                        Expanded(child: Column(
                          children: [
                            const Text("Past Participle",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
                            Text(_textEditingController!.text.isNotEmpty
                                ? listSearch[index].pastParticiple.toString()
                                : listV[index].pastParticiple.toString()),
                          ],
                        ),
                        ),
                        Expanded(child: Column(
                          children: [
                            const Text("Gerund",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0)),
                            Text(_textEditingController!.text.isNotEmpty
                                ? listSearch[index].gerund.toString()
                                : listV[index].gerund.toString()),

                          ],
                        ),
                        ),
                          ],
                    ),
                  );

                }
              );
            }else{
              return const Center(child: CircularProgressIndicator(),);
            }
          },
        ),
      ),
    );
  }
}

class VerbsDateModel{
   String? type;
   String? simpleForm;
   String? thirdPerson;
   String? simplePast;
   String? pastParticiple;
   String? gerund;
   String? meaning;


   VerbsDateModel.fromJson(Map<String, dynamic> parsedJson){
        type = parsedJson['TYPE'];
        simpleForm = parsedJson['SIMPLE FORM'];
        thirdPerson = parsedJson['THIRD PERSON'];
        simplePast = parsedJson['SIMPLE PAST'];
        pastParticiple = parsedJson['PAST PARTICIPLE'];
        gerund = parsedJson['GERUND'];
        meaning = parsedJson['MEANING'];
  }
}


