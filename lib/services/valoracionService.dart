
import 'package:fastenglish/entity/CalificacionContenido.dart';
import 'package:firebase_database/firebase_database.dart';

class valoracionService {

  Future<List<CalificacionContenido>> getValoracionContenido(String email) async {
    List<CalificacionContenido> list = []; 
    String name = "Valoracion/Contenido";
    try{
      DataSnapshot sna =
          await FirebaseDatabase.instance.ref().child(name).get();

      for(DataSnapshot sn in sna.children){    
        if(email == sn.child('Email').value.toString()){
          CalificacionContenido contenido = CalificacionContenido(
            key: sn.key.toString(),
            email: sn.child('Email').value.toString(),
            tema: sn.child('Tema').value.toString(),
            valoracion: double.parse(sn.child('Calificacion').value.toString()),
            comentario: sn.child('Comentario').value.toString());
            list.add(contenido); 
        }           
      }      
            
      return list;
    } catch (e) {
      return list;
    }
  }
  Future<bool> saveValoracionContenido(String email, String tema, double valoracion, String comentario) async {
    try {
      String name = "Valoracion/Contenido";
        
       await FirebaseDatabase.instance.ref().child(name).push().set({
          'Email': email,
          'Tema': tema,
          'Calificacion': valoracion,
          'Comentario': comentario,
        });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}