import 'package:fastenglish/entity/ImgCamera.dart';
import 'package:fastenglish/entity/UserServices.dart';
import 'package:fastenglish/entity/VocabularyNote.dart';
import 'package:fastenglish/entity/ApuntesTopic.dart';
import 'package:flutter/material.dart';



class AppState with ChangeNotifier {
  List<VocabularyNote> _notas = [];
  List<ApuntesTopic> _apuntes = [];
  List<ImgCamera> _ImgsCamera = [];

  
  Future<bool> saveNotas(String s, String text, String text2, String text3) async {
    try {
      bool respuesta = await UserServices().saveNotas(s, text, text2, text3);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    } catch (e) {
      return false;
    }
  }

  Future<List<VocabularyNote>> obtenerNotas(String user) async{
    try{
      _notas = await UserServices().getNotas(user);
      return _notas;
    }catch (e){
      return _notas;
    }
  }

  Future<void> deleteNota(String key) async{
    try{
      bool respuesta = await UserServices().eliminarNotas(key);
      if(respuesta) {
        notifyListeners();
      }
    }catch (e){
      print(e);
    }
  }

  Future<bool> editNota(String key, String tema, String subtema, String contenido) async{
    try{
      
      bool respuesta = await UserServices().editarNotas(key, tema, subtema, contenido);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    }catch (e){
      print(e);
      return false;
    }
  }

  Future<bool> saveApuntes(String s, String text, String text2, String text3 ) async {
    try {
      bool respuesta = await UserServices().saveApuntesTopic(s, text, text2, text3);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteApuntes( String s, String text, String text2 ) async {
    try {
      bool respuesta = await UserServices().eliminarApuntes(s, text, text2);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    } catch (e) {
      return false;
    }
  }

  Future<List<ApuntesTopic>> obtenerApuntes(String user, String tem) async{
    try{
      _apuntes = await UserServices().getApuntesTopic(user, tem);
      return _apuntes;
    }catch (e){
      return _apuntes;
    }
  }

  Future<bool> saveUsers( String username, String email, String imag ) async {
    try {
      bool respuesta = await UserServices().saveUsersSer(username, email, imag);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveImagenes( String email, String img,String imgurl, String fecha, String hora, String nota ) async {
    try {
      bool respuesta = await UserServices().saveImagenes(email, img, imgurl, fecha, hora, nota);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    } catch (e) {
      return false;
    }
  }
  
  
  Future<List<ImgCamera>> obtenerImagenes(String email) async{
    try{
      _ImgsCamera = await UserServices().getImagenes(email);
      return _ImgsCamera;
    }catch (e){
      return _ImgsCamera;
    }
  }

  Future<bool> eliminarImagenes(String email, String fecha) async{
    try {
      bool respuesta = await UserServices().eliminarImagenes(email, fecha);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    } catch (e) {
      return false;
    }
  }
}
