import 'package:fastenglish/consts/colors.dart';
import 'package:fastenglish/widgets/text_title.dart';
import 'package:flutter/material.dart';

class titulo_icon extends StatelessWidget {
  final String titulo;
  
  const titulo_icon({
    Key? key, required this.titulo
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
            width: 200,
            padding: const EdgeInsets.only(top: 50, bottom: 50),
            child: text_title(
                color: ColorsConsts.primarybackground,
                size: 30,
                fontw: FontWeight.w500,
                titulo: titulo)),
        Ink(
          decoration: ShapeDecoration(
            color: ColorsConsts.primarybackground,
            shape: const CircleBorder(),
          ),
          child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_sharp,
                color: Colors.white,
                size: 30,
              )),
        )
      ],
    );
  }
}