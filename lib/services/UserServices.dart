import 'package:fastenglish/entity/ApuntesTopic.dart';
import 'package:fastenglish/entity/ImgCamera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserServices {
  
  Future<bool> saveApuntesTopic(String email, String tema, String contenido) async {
    try {
      String name = "Apuntes_Usuario";
        
       await FirebaseDatabase.instance.ref().child(name).push().set({
          'Email': email,
          'Tema': tema,
          'Contenido': contenido,
        });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<ApuntesTopic>> getApuntesTopic(String email) async {
    List<ApuntesTopic> listt = [];
    String name = "Apuntes_Usuario";
    try{
      DataSnapshot sna =
          await FirebaseDatabase.instance.ref().child(name).get();

      for(DataSnapshot sn in sna.children){    
        if(email == sn.child('Email').value.toString()){
          ApuntesTopic ovn = ApuntesTopic(
            key: sn.key.toString(),
            email: sn.child('Email').value.toString(),
            tema: sn.child('Tema').value.toString(),
            contenido: sn.child('Contenido').value.toString());
            listt.add(ovn);  
        }           
      }      
            
      return listt;
    } catch (e) {
      return listt;
    }
  }

  Future<bool> editarNotas(String key,String tema, String contenido) async{
    try {
      String name = "Apuntes_Usuario";
      Map<String, String> value = {'Tema': tema, 'Contenido': contenido};
      await FirebaseDatabase.instance
          .ref()
          .child(name)
          .child(key)
          .update(value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarApuntes(String key, String email , String tema) async {
    try {
      String name = "Apuntes_Usuario";
      await FirebaseDatabase.instance
          .ref()
          .child(name)
          .child(key)
          .remove();
      return true;
    } catch (e) {
      return false;
    }
  }  

  Future<List<ImgCamera>> getImagenes(String email) async{
    List<ImgCamera> lisCamera= [];
    try{
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('ImgCamera').get();
      if (snapshot.exists) {
        for(DataSnapshot sn in snapshot.children){
          if(email == sn.child('Email').value.toString()){
            ImgCamera ovn = ImgCamera(
              key: sn.key.toString(),
              email: sn.child('Email').value.toString(),
              img: sn.child('Img').value.toString(),
              imgurl: sn.child('ImgUrl').value.toString(),
              fecha: sn.child('Fecha').value.toString(),
              hora: sn.child('Hora').value.toString(),
              nota: sn.child('Nota').value.toString()
            );
            lisCamera.add(ovn); 
          }          
        }
      }
      lisCamera.sort((a, b) {
        DateTime fechaA = DateTime.parse(a.fecha);
        DateTime fechaB = DateTime.parse(b.fecha);

        return fechaB.compareTo(fechaA);
      });
      return lisCamera;
    }catch (e){
      return lisCamera;
    }
  }

  Future saveImagenes(String email, String img, String imgurl, String fecha, String hora, String nota) async{
    try {
      await FirebaseDatabase.instance.ref().child('ImgCamera').push().set({        
          'Email': email,
          'Img': img,
          'ImgUrl': imgurl,
          'Fecha': fecha,
          'Hora': hora +'h',
          'Nota': nota
        });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarImagenes(String email, String fecha) async{
    try {
      List<String> listDeleted= [];
      List<String> listUrl = [];
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('ImgCamera').get();
      if (snapshot.exists) {
        for(DataSnapshot sn in snapshot.children){
          if(email == sn.child('Email').value.toString()){
            if(fecha != sn.child('Fecha').value.toString()){
              listDeleted.add(sn.key.toString());
              listUrl.add(sn.child('Img').value.toString());
            }
          }          
        }
      } 
      for(String key in listDeleted){
        await FirebaseDatabase.instance
          .ref()
          .child('ImgCamera')
          .child(key)
          .remove();
      } 

      for(String img in listUrl){
          await FirebaseStorage.instance.ref().child('ImgCamera').child(img).delete();
      } 

      return true;
    } catch (e) {
      return false;
    }
  }

}




