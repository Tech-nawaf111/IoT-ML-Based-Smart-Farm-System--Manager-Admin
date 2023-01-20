import 'package:admin_app/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class AllUsers extends StatelessWidget {
  final db = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: bgColor,

          title: Text('Accept Users Profile'),
        ),
        body:
        Container(
          decoration: BoxDecoration(
            color: Color(0xFF212332),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: db.collection('Approval').where('Status', isEqualTo: "Pending").snapshots(),
            builder: (context, snapshot) {

              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                int i=0;

                return ListView(

                  children: (snapshot.data!).docs.map((doc) {
                   String email = (snapshot.data!).docs[i++].id;
                 //  String title =(snapshot.data! as QuerySnapshot).docs[i++]["AccountType"].toString();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: InkWell(

                      child: Card(
                      elevation: 8.0,
                      color: Colors.white70,
                      shadowColor: Colors.black,
                      shape: RoundedRectangleBorder(
                      side: BorderSide(
                      color: Colors.blue,
                      ),
                      borderRadius:
                      BorderRadius.circular(20.0), //<-- SEE HERE
                    ),
                    margin: new EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 6.0),
                    child:  Row(
                      children: <Widget>[
                        const SizedBox(width: 20.0),
                        const CircleAvatar(
                          radius: 20.0,
                          child: Icon(Icons.account_circle,size: 20.0,),
                        ),
                        const SizedBox(width: 20.0),
                        Container(
                          height: 80.0,
                          width: MediaQuery.of(context).size.width - 200.0,
                          padding: const EdgeInsets.fromLTRB(0.0,30.0,0.0,0.0),
                          child: Text("Account Email:"
                              //(doc.data() as dynamic)['AccountType'] +
                             +email,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14.0,
                            ),
                            maxLines: 2,
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 3.0),
                        Container(
                            height: 30.0,
                            width: 90.0,
                            child:
                            ElevatedButton(
                              key: const Key('loginForm_continue_raisedButton'),
                              style: ElevatedButton.styleFrom(

                                primary: Colors.blue,
                              ),

                              onPressed: (){


                                FirebaseFirestore.instance.collection('Approval').doc(email).update({'Status': 'Approved'});

                              },
                              child: const Text('Approve'),
                            )

                        ),
                      ],
                    ),
                    ),


                        onTap: () {
                          // Navigator.of(context).push(
                          //   MaterialPageRoute(
                          //     builder: (BuildContext context) {
                          //    //   return Details();
                          //     },
                          //   ),
                          // );
                        },
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),
      ),


    );

  }
}






