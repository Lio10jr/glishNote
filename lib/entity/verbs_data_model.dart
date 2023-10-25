class VerbsDateModel {
  String? type;
  String? simpleForm;
  String? thirdPerson;
  String? simplePast;
  String? pastParticiple;
  String? gerund;
  String? meaning;

  
  VerbsDateModel.fromJson(Map<String, dynamic> parsedJson) {

    type = parsedJson['TYPE'];
    simpleForm = parsedJson['SIMPLE FORM'];
    thirdPerson = parsedJson['THIRD PERSON'];
    simplePast = parsedJson['SIMPLE PAST'];
    pastParticiple = parsedJson['PAST PARTICIPLE'];
    gerund = parsedJson['GERUND'];
    meaning = parsedJson['MEANING'];
  }
}