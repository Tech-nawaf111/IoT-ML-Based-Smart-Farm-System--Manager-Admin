
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'cow_model.dart';

/// CreateProfile repository is used for performing backend operatings
/// required for profile handling.

class CowRepository{
  String? cowid;
  FirebaseFirestore? firestore;
  CollectionReference? _mainCollection;
  DocumentReference? documentReference;

  static final _firebaseStorage = FirebaseStorage.instance;

  CowRepository(this.firestore, this._mainCollection, this.documentReference,
      this.cowid);


  DocumentReference documentReferenceforCowNumber =
  FirebaseFirestore.instance.collection('CurrentCow').doc("CurrentCow");





  Future<void> uploadCow(CowModel cowModel) async {
    String url = await uploadFile(cowModel.imageFile?.path);
    Map<String, dynamic> data = <String, dynamic>{
      "CowID": cowModel.CowId,
      "Price": cowModel.Price,
      "Age": cowModel.Age,
      "Vaccinated": cowModel.Vaccinated,
      "Calfs": cowModel.Calfs,
      "MilkQuantity": cowModel.MilkQuantity,
      "Breed":cowModel.Breed,
      "Temperature": cowModel.Temperature,
     "profilePhotoURL": url,
    };
    DocumentReference<Object?>? documentReferencer =
    _mainCollection?.doc(cowid);
    print(cowid);
    await documentReferencer
        ?.set(data)
        .whenComplete(() =>
        print("Notes item added to the database"))
        .catchError((e) => print(e));
  }


  /// upload photo to firebase Cloud Storage and return its URL

  static Future<String> uploadFile(String? path) async {
    try {
      final _fileName = DateTime.now().toIso8601String();
      final _reference = _firebaseStorage.ref().child(_fileName);
      final _task = await _reference.putFile(File(path!));
      return await _task.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  /// RetreiveProfile from firebase realtime database and photo from Cloud storage

  Future<List<String>> RetreiveCow() async {
    String CowId = "";
    String Price = "";
    String Age = "";
    String Vaccinated = "";
    String Calfs = "";
    String MilkQuantity = "";
    String Breed = "";
    String imageFileurl = "";
    String Temperature = "";


    await documentReference?.get().then((dataSnapshot) {
      print(documentReference);
      try {
        CowId = (dataSnapshot.data() as dynamic)["CowID"];
        Price = (dataSnapshot.data() as dynamic)["Price"];
        Age = (dataSnapshot.data() as dynamic)["Age"];
        Vaccinated = (dataSnapshot.data() as dynamic)["Vaccinated"];
        Calfs = (dataSnapshot.data() as dynamic)["Calfs"];
        MilkQuantity = (dataSnapshot.data() as dynamic)["MilkQuantity"];
        Breed = (dataSnapshot.data() as dynamic)["Breed"];
        Temperature = (dataSnapshot.data() as dynamic)["Temperature"];
        imageFileurl = (dataSnapshot.data() as dynamic)["profilePhotoURL"];
        print("data recieved successfully");
      } catch (_) {
        print("nothing recieved");
      }
    });
    print("Data Retreived");
    return [CowId, Price, Age, Vaccinated, Calfs, MilkQuantity,Breed,Temperature, imageFileurl];
  }


  Future<int> RetreivePreviousRegCow() async{
    int  CurrentCow = 0;
    await documentReferenceforCowNumber.get().then((dataSnapshot) {
      CurrentCow = (dataSnapshot.data() as dynamic)["CurrentCow"];
    });
    print("Data Retreived");
    return CurrentCow;
  }


  Future<void> UploadPreviousRegCow(int CurrentCow) async {
    FirebaseFirestore.instance.collection('CurrentCow').doc("CurrentCow").update({'CurrentCow': CurrentCow});
  }






}
