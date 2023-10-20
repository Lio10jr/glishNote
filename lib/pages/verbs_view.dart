import 'package:fastenglish/pages/verbs.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:fastenglish/main.dart';

class verbsView extends StatefulWidget {
  const verbsView({Key? key}) : super(key: key);

  @override
  _MyverbsViewPageState createState() => _MyverbsViewPageState();
}

String busVerb = "";

class _MyverbsViewPageState extends State<verbsView> {
  late List<VerbsDateModel> listV;
  late List<VerbsDateModel> listSearch = [] as List<VerbsDateModel>;

  final TextEditingController? _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,elevation: 0,
            title: Container(
              decoration: BoxDecoration(
                  color: Colors.amber.shade200,
                  borderRadius: BorderRadius.circular(30)),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    listSearch = listV
                        .where(((element) => element.simpleForm!
                            .toLowerCase()
                            .contains(value.toLowerCase())))
                        .toList();
                  });
                },
                controller: _textEditingController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    hintText: 'Search'),
              ),
            ),
          ),
          body: FutureBuilder(
            future: readJsonData(),
            builder: (context, data) {
              if (data.hasError) {
                return Center(child: Text("${data.error}"));
              } else if (data.hasData) {
                var items = data.data as List<VerbsDateModel>;
                listV = items;
                return ListView.builder(
                    itemCount: _textEditingController!.text.isNotEmpty
                        ? listSearch.length
                        : listV.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 90,
                              width: 50,
                              child: Column(
                                children: [
                                  Text(
                                      _textEditingController!.text.isNotEmpty
                                          ? "\n" +
                                              listSearch[index]
                                                  .simpleForm
                                                  .toString()
                                          : "\n" +
                                              listV[index]
                                                  .simpleForm
                                                  .toString(),
                                      style: const TextStyle(
                                          color: Colors.red,
                                          fontSize: 10.0,
                                          fontWeight: FontWeight.bold)),
                                  Text(
                                      _textEditingController!.text.isNotEmpty
                                          ? "\n" +
                                              listSearch[index]
                                                  .meaning
                                                  .toString()
                                          : listV[index].meaning.toString(),
                                      style: const TextStyle(
                                          color: Colors.blue, fontSize: 10.0)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Simple Past",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0)),
                                  Text(
                                      _textEditingController!.text.isNotEmpty
                                          ? listSearch[index]
                                              .simplePast
                                              .toString()
                                          : listV[index].simplePast.toString(),
                                      style: const TextStyle(
                                          height: 2, fontSize: 10.0)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Third Person",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0)),
                                  Text(
                                      _textEditingController!.text.isNotEmpty
                                          ? listSearch[index]
                                              .thirdPerson
                                              .toString()
                                          : listV[index].thirdPerson.toString(),
                                      style: const TextStyle(
                                          height: 2, fontSize: 10.0)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Past Participle",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0)
                                  ),
                                  Text(
                                      _textEditingController!.text.isNotEmpty
                                          ? listSearch[index]
                                              .pastParticiple
                                              .toString()
                                          : listV[index]
                                              .pastParticiple
                                              .toString(),
                                      style: const TextStyle(
                                          height: 2, fontSize: 10.0)
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const Text("Gerund",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10.0)),
                                  Text(
                                      _textEditingController!.text.isNotEmpty
                                          ? listSearch[index].gerund.toString()
                                          : listV[index].gerund.toString(),
                                      style: const TextStyle(
                                          height: 2, fontSize: 10.0)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        )
    );
  }
}
