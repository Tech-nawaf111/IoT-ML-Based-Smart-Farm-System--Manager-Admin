
import 'package:cloud_firestore/cloud_firestore.dart';

class userRequests{


  CollectionReference _collectionRef = FirebaseFirestore.instance.collection('Approval');

  // Future<void> getData() async {
  //   // Get docs from collection reference
  //   QuerySnapshot querySnapshot = await _collectionRef.get();
  //
  //   // Get data from docs and convert map to List
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print(allData as dynamic);
  // }


  Future<List<String>?> getData() async{
    String status="null";
    String accountType="null";
    String email ="";
    List a= [];
    await _collectionRef.get().then((dataSnapshot) {
      try {
        for(int i =0;i< dataSnapshot.docs.length;i++){
          status = (dataSnapshot.docs[i] as dynamic)["Status"];
          accountType = (dataSnapshot.docs[i] as dynamic)["AccountType"];
          email = dataSnapshot.docs[i].id;
           a = a+ [status, accountType, email];

        }

        print(a);
        return a;

      } catch (_) {
        return null;
    }});



  }
}

