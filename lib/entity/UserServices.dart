import 'package:fastenglish/entity/ApuntesTopic.dart';
import 'package:fastenglish/entity/ImgCamera.dart';
import 'package:fastenglish/entity/VocabularyNote.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserServices {
  
  Future<List<VocabularyNote>> getNotas(String email) async {
    List<VocabularyNote> list = []; 
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child('VocabularyNote').get();
      if (snapshot.exists) {
        for(DataSnapshot sn in snapshot.children){    
          if(email == sn.child('email').value.toString()){
            VocabularyNote ovn = VocabularyNote(
              key: sn.key.toString(),
              user: sn.child('email').value.toString(),
              espanish: sn.child('spanish').value.toString(),
              ingles: sn.child('ingles').value.toString(),
              pronunciacion: sn.child('pronunciacion').value.toString());
              list.add(ovn);  
          }  
        }
      } else {
        print('Error al retornar la lista.');
      }
      return list;
    } catch (e) {
      return list;
    }
  }

  Future<bool> saveNotas(String user, String ingles, String spanish, String pronunciacion) async {
    try {
      await FirebaseDatabase.instance.ref().child("VocabularyNote").push().set({
        'email': user,
        'ingles': ingles,
        'spanish': spanish,
        'pronunciacion': pronunciacion
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> eliminarNotas(String key) async {
    try {
      await FirebaseDatabase.instance
          .ref()
          .child('VocabularyNote')
          .child(key)
          .remove();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveApuntesTopic(String email, String tema,String subTema, String contenido) async {
    try {
      String name = "TopicNote/" + tema;
        
       await FirebaseDatabase.instance.ref().child(name).push().set({
          'Email': email,
          'Tema': tema,
          'SubTema': subTema,
          'Contenido': contenido,
        });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<ApuntesTopic>> getApuntesTopic(String email, topic) async {
    List<ApuntesTopic> listt = [];
    String name = "TopicNote/" + topic;
    try{
      DataSnapshot sna =
          await FirebaseDatabase.instance.ref().child(name).get();

      for(DataSnapshot sn in sna.children){    
        if(email == sn.child('Email').value.toString()){
          ApuntesTopic ovn = ApuntesTopic(
            key: sn.key.toString(),
            email: sn.child('Email').value.toString(),
            tema: sn.child('Tema').value.toString(),
            subTema: sn.child('SubTema').value.toString(),
            contenido: sn.child('Contenido').value.toString());
            listt.add(ovn);  
        }           
      }      
            
      return listt;
    } catch (e) {
      return listt;
    }
  }

  Future<bool> editarNotas(String key,String tema,String subtema, String contenido) async{
    try {
      String name = "TopicNote/" + tema;
      Map<String, String> value = {'SubTema': subtema, 'Contenido': contenido};
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
      String name = "TopicNote/" + tema;
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

  Future saveUsersSer(String username, String email, String imag) async {
    try {
      String name = "Users";
      bool resul = false;

      DatabaseReference ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child(name).get();
      if (!snapshot.exists) {
        await FirebaseDatabase.instance
            .ref()
            .child("Users")
            .push()
            .set({'UserName': username, 'Email': email, 'ImagenUrl': imag});
      } else {
        await getUser(email).then((value) {
          resul = value;
        });
        if (!resul) {
          await FirebaseDatabase.instance
              .ref()
              .child("Users")
              .push()
              .set({'UserName': username, 'Email': email, 'ImagenUrl': imag});
        }
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> getUser(String email) async {
    String name = "Users";
    bool result = false;
    try {
      DatabaseReference ref = FirebaseDatabase.instance.ref();
      final snapshot = await ref.child(name).get();

      if (snapshot.exists) {
        for(DataSnapshot sn in snapshot.children){
          if(email ==sn.child('Email').value){
            return result = true;
          }      
        }
      } 
      return result;
    } catch (e) {
      return result;
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




