class contTopic{
  String? uso;
  String? affimative;
  String? infoa;
  String? examplea;
  String? negative;
  String? infon;
  String? examplen;
  String? interrogative;
  String? infoi;
  String? examplei;
  contTopic({required this.uso, required this.affimative, required this.infoa,required this.examplea,
    required this.negative, required this.infon, required this.examplen,
    required this.interrogative, required this.infoi, required this.examplei});

  contTopic.fromJson(Map<String, dynamic> json){
    uso = json['USO'];
    affimative = json['AFFIRMATIVE'];
    infoa = json['INFOA'];
    examplea = json['EXAMPLEA'];
    negative = json['NEGATIVE'];
    infon = json['INFON'];
    examplen = json['EXAMPLEN'];
    interrogative = json['INTERROGATIVE'];
    infoi = json['INFOI'];
    examplei = json['EXAMPLEI'];
  }
}