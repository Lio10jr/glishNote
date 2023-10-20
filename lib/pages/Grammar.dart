import 'package:fastenglish/entity/TopicE.dart';
import 'package:fastenglish/pages/all_topic.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;

import '../main.dart';

class Grammar extends StatefulWidget {
  const Grammar({Key? key}) : super(key: key);

  _grammarState createState() => _grammarState();
}

  late List<contTopic> listCT;

class _grammarState extends State<Grammar> {
  late List<contTopic> listCTT = [] as List<contTopic>;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("GRAMMAR"),
          shadowColor: Colors.red,
          backgroundColor: Colors.orange.shade900,
        ),
        body: SizedBox(
          height: Size.infinite.height,
          width: Size.infinite.width,
          child: FutureBuilder(
              future: readJsonDataCT(),
              builder: (context, data) {
                if (data.hasError) {
                  return Center(child: Text("${data.error}"));
                } else if (data.hasData) {
                  var items = data.data as List<contTopic>;
                  listCT = items;
                  return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            Container(
                              width: Size.infinite.width * 0.5,
                              margin: const EdgeInsets.only(top: 30),
                              child: Column(
                                children: [
                                  Container(
                                    height: 20,
                                    width: Size.infinite.width * 0.5,
                                    alignment: Alignment.center,
                                    child: const Text("PAST TENSE",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        )),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        circleButton(context, 'PAST SIMPLE', allTopic(pos: 0, tema:'PAST SIMPLE',)),
                                        const SizedBox(width: 10),
                                        circleButton(context, 'PAST CONTINUOUS', allTopic(pos: 1, tema:'PAST CONTINUOUS',)),
                                        const SizedBox(width: 10),
                                        circleButton(context, 'PAST PERFECT', allTopic(pos: 2, tema:'PAST PERFECT',)),
                                        const SizedBox(width: 10),
                                        circleButton(context, 'PAST PERFECT CONTINUOUS', allTopic(pos: 3, tema:'PAST PERFECT CONTINUOUS',)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: Size.infinite.width * 0.5,
                                    alignment: Alignment.center,
                                    child: const Text("PRESENT TENSE",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        )),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        circleButton(context, 'PRESENT SIMPLE', allTopic(pos: 4, tema:'PRESENT SIMPLE',)),
                                        const SizedBox(width: 10),
                                        circleButton(context, 'PRESENT CONTINUOUS', allTopic(pos: 5, tema:'PRESENT CONTINUOUS',)),
                                        const SizedBox(width: 10),
                                        circleButton(context, 'PRESENT PERFECT', allTopic(pos: 6, tema:'PRESENT PERFECT',)),
                                        const SizedBox(width: 10),
                                        circleButton(context, 'PRESENT PERFECT CONTINUOUS', allTopic(pos: 7, tema:'PRESENT PERFECT CONTINUOUS',)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: Size.infinite.width * 0.5,
                                    alignment: Alignment.center,
                                    child: const Text("FUTURE",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        )),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.all(25),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        circleButton(context, 'SIMPLE FUTURE', allTopic(pos: 8, tema:'SIMPLE FUTURE',)),
                                        const SizedBox(width: 10),
                                        circleButton(context, 'FUTURE CONTINUOUS', allTopic(pos: 9, tema:'FUTURE CONTINUOUS',)),
                                        const SizedBox(width: 10),
                                        circleButton(context, 'FUTURE PERFECT', allTopic(pos: 10, tema:'FUTURE PERFECT',)),
                                        const SizedBox(width: 10),
                                        circleButton(context, 'FUTURE PERFECT CONTINUOUS', allTopic(pos: 11, tema:'FUTURE PERFECT CONTINUOUS',)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ));
  }

  SizedBox circleButton(BuildContext context, String tema, Widget pag) {
    return SizedBox.fromSize(
      size: const Size(120, 120),
      // button width and height
      child: ClipOval(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  end: Alignment
                      .bottomCenter,
                  colors: [
                Colors.orange.shade400
                    .withOpacity(0.4),
                Colors.orange.shade400
              ])), // button color
          child: InkWell(
            splashColor: Colors.lightGreen,
            // splash color
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          pag));
            },
            // button pressed
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: <Widget>[
                const Icon(Icons.article,
                    color: Colors.white,
                    size: 40),
                // icon
                topicText(tema),
                // text
              ],
            ),
          ),
        ),
      ),
      );
  }

  Text topicText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
