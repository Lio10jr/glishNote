import 'package:fastenglish/entity/CalificacionContenido.dart';
import 'package:fastenglish/entity/ImgCamera.dart';
import 'package:fastenglish/services/UserServices.dart';
import 'package:fastenglish/services/valoracionService.dart';
import 'package:fastenglish/services/vocabularioService.dart';
import 'package:fastenglish/entity/VocabularyNote.dart';
import 'package:fastenglish/entity/ApuntesTopic.dart';
import 'package:flutter/material.dart';

class AppState with ChangeNotifier {
  List<VocabularyNote> _vocabularioList = [];
  List<CalificacionContenido> _calificacionList = [];
  List<ApuntesTopic> _apuntes = [];
  List<ImgCamera> _ImgsCamera = [];
  
  Future<bool> saveVocabulario(String s, String text, String text2, String text3) async {
    try {
      bool respuesta = await vocabularioService().saveVocabulario(s, text, text2, text3);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    } catch (e) {
      return false;
    }
  }

  Future<List<VocabularyNote>> obtenerVocabulario(String user) async{
    try{
      _vocabularioList = await vocabularioService().getVocabulario(user);
      return _vocabularioList;
    }catch (e){
      return _vocabularioList;
    }
  }

  Future<void> deleteVocabulario(String key) async{
    try{
      bool respuesta = await vocabularioService().eliminarVocabulario(key);
      if(respuesta) {
        notifyListeners();
      }
    } catch (e) {
      
    }
  }

  Future<bool> editVocabulario(String key, String user, String ingles, String spanish, String pronunciacion) async{
    try{
      
      bool respuesta = await vocabularioService().editarVocabulario(key, user, ingles, spanish, pronunciacion);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    }catch (e){
      return false;
    }
  }

  Future<bool> editNota(String key, String tema, String contenido) async{
    try{
      
      bool respuesta = await UserServices().editarNotas(key, tema, contenido);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    }catch (e){
      return false;
    }
  }

  Future<bool> saveApuntes(String s, String text, String text2) async {
    try {
      bool respuesta = await UserServices().saveApuntesTopic(s, text, text2);
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

  Future<List<ApuntesTopic>> obtenerApuntes(String user) async{
    try{
      _apuntes = await UserServices().getApuntesTopic(user);
      return _apuntes;
    }catch (e){
      return _apuntes;
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

  Future<bool> saveCalificacionContenido(String text, String text2, double valor, String text3) async {
    try {
      bool respuesta = await valoracionService().saveValoracionContenido(text, text2, valor, text3);
      if(respuesta) {
        notifyListeners();
      }
      return respuesta;
    } catch (e) {
      return false;
    }
  }

  Future<List<CalificacionContenido>> obtenerValoracionContenido(String user) async{
    try{
      _calificacionList = await valoracionService().getValoracionContenido(user);
      return _calificacionList;
    }catch (e){
      return _calificacionList;
    }
  }


}
