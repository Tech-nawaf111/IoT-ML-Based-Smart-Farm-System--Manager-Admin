import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/IoT_sensors_model.dart';

class IoTDataRepo{
  IoTDataRepo();




  DocumentReference documentReference =
  FirebaseFirestore.instance.collection('IoTSensorsValues').doc("08-10-2022");


  // ignore: non_constant_identifier_names
  Future<List<String>> RetreiveSensorsData() async{
    String Rcolor = "";
    String Gcolor= "";
    String Bcolor="";
    String Ph = "";
    String Datetoday= "";
    String  Temperature = "";

    await documentReference.get().then((dataSnapshot) {
      print(documentReference);

        Rcolor = (dataSnapshot.data() as dynamic)["Rcolor"];
        Gcolor = (dataSnapshot.data() as dynamic)["Gcolor"];
        Bcolor = (dataSnapshot.data() as dynamic)["Bcolor"];
        Ph = (dataSnapshot.data() as dynamic)["ph"];
        Temperature = (dataSnapshot.data() as dynamic)["Temperature"];
        Datetoday = (dataSnapshot.data() as dynamic)["DateToday"];
        print("data recieved successfully");
        print(Rcolor);
        print(Gcolor);
        print(Bcolor);
        print(Ph);
        print(Temperature);
        print(Datetoday);


    });
    print("Data Retreived");
    return [Rcolor, Gcolor, Bcolor,Ph,Temperature,Datetoday];



  }






}