import 'package:admin_app/feed_stocks/feed_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FeedRespository{
  String? cowID;
  FirebaseFirestore firestore;
  CollectionReference _mainCollection;
  DocumentReference documentReference;

  FeedRespository(
      this.firestore, this._mainCollection, this.documentReference,this.cowID);


  Future<void> uploadFeed(FeedModel feedModel) async{
    String MainQuantity ="";
    String AvailQuantity ="";

    await documentReference.get().then((dataSnapshot) {
      print(documentReference);
      try {
        MainQuantity = (dataSnapshot.data() as dynamic)["Quantity"];
        AvailQuantity = (dataSnapshot.data() as dynamic)["available"];
        print("data recieved successfully");
      } catch (_) {
        print("nothing recieved");
      }
    });

    int newQuantity = int.parse(MainQuantity)+int.parse(feedModel.Quantity);
    int newAvailableQuantity = int.parse(AvailQuantity)+int.parse(feedModel.Quantity);

    Map<String, dynamic> data = <String, dynamic>{
      "Name": feedModel.Name,
      "Price": feedModel.Price,
      "Quantity": newQuantity.toString(),
      "available": newAvailableQuantity.toString(),
      "perday": feedModel.PerDay,
    };
    DocumentReference documentReferencer =
    _mainCollection.doc(cowID);
    print(cowID);
    await documentReferencer
        .set(data)
        .whenComplete(() =>
        print("Notes item added to the database"))
        .catchError((e) => print(e));

  }


  Future<List<String>> RetreiveFeed() async{
    String Name ="";
    String Price="";
    String Quantity ="";
    await documentReference.get().then((dataSnapshot) {
      print(documentReference);
      try {

        Name = (dataSnapshot.data() as dynamic)["Name"];
        Price = (dataSnapshot.data() as dynamic)["Price"];
        Quantity = (dataSnapshot.data() as dynamic)["Quantity"];
        print("data recieved successfully");
      } catch (_) {
        print("nothing recieved");
      }
    });
    print("Data Retreived");
    return [Name, Price, Quantity];
    ;


  }







}