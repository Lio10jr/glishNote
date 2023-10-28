import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:flutter/material.dart';

class titulo extends StatelessWidget {
  final String tema;
  const titulo({
    Key? key, required this.tema
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: 0.85,
      child: Container(
          padding:
              const EdgeInsets.only(left: 40, right: 20, top: 50, bottom: 50),
          child: text_title(
              color: ColorsConsts.primarybackground,
              size: 30,
              fontw: FontWeight.w500,
              titulo: tema)),
    );
  }
}