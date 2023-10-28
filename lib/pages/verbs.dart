import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/entity/verbs_data_model.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:fastenglish/widgets/titulo_icon.dart';
import 'package:flutter/material.dart';
import 'package:fastenglish/main.dart';

class verbs extends StatefulWidget {
  const verbs({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

String busVerb = "";

class _MyHomePageState extends State<verbs> {
  late List<VerbsDateModel> listV;
  late List<VerbsDateModel> listSearch = [];

  final TextEditingController? _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(300.0),
          child: titulo_icon(titulo: "Aquí puedes ver una lista de Verbos que te ayudarán!",),
        ),
        body: Stack(children: [
          Container(
            margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: ColorsConsts.primarybackground),
            child: TextField(
              controller: _textEditingController,
              onChanged: (val) {
                setState(() {
                  listSearch = listV.where((element) {
                    final simpleForm = element.simpleForm!
                        .toLowerCase()
                        .contains(val.toLowerCase());
                    final simplePast = element.simplePast!
                        .toLowerCase()
                        .contains(val.toLowerCase());
                    final thirdPerson = element.thirdPerson!
                        .toLowerCase()
                        .contains(val.toLowerCase());
                    final pastParticiple = element.pastParticiple!
                        .toLowerCase()
                        .contains(val.toLowerCase());
                    final gerund = element.gerund!
                        .toLowerCase()
                        .contains(val.toLowerCase());
                    final meaning = element.meaning!
                        .toLowerCase()
                        .contains(val.toLowerCase());
                    return simpleForm ||
                        simplePast ||
                        thirdPerson ||
                        pastParticiple ||
                        gerund || meaning;
                  }).toList();
                });
              },
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _textEditingController!.clear();
                      });
                    },
                  ),
                  border: InputBorder.none,
                  errorBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.all(15),
                  hintText: 'Search'),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            padding: const EdgeInsets.only(right: 10, left: 10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(30),
              ),
              color: Colors.grey[200],
            ),
            child: FutureBuilder(
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
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: text_title(
                                      color: ColorsConsts.primarybackground,
                                      size: 12.0,
                                      fontw: FontWeight.w800,
                                      titulo: _textEditingController!
                                              .text.isNotEmpty
                                          ? listSearch[index]
                                              .simpleForm
                                              .toString()
                                          : listV[index].simpleForm.toString()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: text_title(
                                      color: ColorsConsts.endColor,
                                      size: 12.0,
                                      fontw: FontWeight.w800,
                                      titulo: _textEditingController!
                                              .text.isNotEmpty
                                          ? listSearch[index].meaning.toString()
                                          : listV[index].meaning.toString()),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: text_title(
                                                color: ColorsConsts.black,
                                                size: 12.0,
                                                fontw: FontWeight.w800,
                                                titulo: "Simple Past"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: text_title(
                                                color: ColorsConsts.black,
                                                size: 12.0,
                                                fontw: FontWeight.w300,
                                                titulo: _textEditingController!
                                                        .text.isNotEmpty
                                                    ? listSearch[index]
                                                        .simplePast
                                                        .toString()
                                                    : listV[index]
                                                        .simplePast
                                                        .toString()),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: text_title(
                                                color: ColorsConsts.black,
                                                size: 12.0,
                                                fontw: FontWeight.w800,
                                                titulo: "Third Person"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: text_title(
                                                color: ColorsConsts.black,
                                                size: 12.0,
                                                fontw: FontWeight.w300,
                                                titulo: _textEditingController!
                                                        .text.isNotEmpty
                                                    ? listSearch[index]
                                                        .thirdPerson
                                                        .toString()
                                                    : listV[index]
                                                        .thirdPerson
                                                        .toString()),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: text_title(
                                                color: ColorsConsts.black,
                                                size: 12.0,
                                                fontw: FontWeight.w800,
                                                titulo: "Past Participle"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: text_title(
                                                color: ColorsConsts.black,
                                                size: 12.0,
                                                fontw: FontWeight.w300,
                                                titulo: _textEditingController!
                                                        .text.isNotEmpty
                                                    ? listSearch[index]
                                                        .pastParticiple
                                                        .toString()
                                                    : listV[index]
                                                        .pastParticiple
                                                        .toString()),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: text_title(
                                                color: ColorsConsts.black,
                                                size: 12.0,
                                                fontw: FontWeight.w800,
                                                titulo: "Gerund"),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5.0),
                                            child: text_title(
                                                color: ColorsConsts.black,
                                                size: 12.0,
                                                fontw: FontWeight.w300,
                                                titulo: _textEditingController!
                                                        .text.isNotEmpty
                                                    ? listSearch[index]
                                                        .gerund
                                                        .toString()
                                                    : listV[index]
                                                        .gerund
                                                        .toString()),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
          ),
        ]),
      ),
    );
  }
}
