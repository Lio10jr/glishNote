import 'package:flutter/material.dart';

const LISTA_COLORES = [
  [Color(0xFFEC407A),Color(0xFFE91E63)],
  [Color(0xFFFFEE58),Color(0xFFFFEB3B)],
  [Color(0xFF29B6F6),Color(0xFF03A9F4)],
  [Color(0xFF66BB6A),Color(0xFF4CAF50)],
  [Color(0xFF66BB6A),Color(0xFF4CAF50)],
  [Color(0xFFEC407A),Color(0xFFE91E63)],
  [Color(0xFFFFEE58),Color(0xFFFFEB3B)],
  [Color(0xFF29B6F6),Color(0xFF03A9F4)],
  [Color(0xFF66BB6A),Color(0xFF4CAF50)],
  [Color(0xFF66BB6A),Color(0xFF4CAF50)]
];

class ColorProvider extends ChangeNotifier{
  List<Color> colorSelect=LISTA_COLORES.first;
  changeColors(int index){
    colorSelect = LISTA_COLORES[index];
    notifyListeners();
  }
}