import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("All Notifications"),),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Notifications')
              .where('status', isEqualTo: "deleivered")
              .snapshots(),
          builder: (context, snapshot) {
            print(snapshot.data);
            print(snapshot.connectionState);
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.active:
              //    return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return Text('No data found');
                }
                if (snapshot.data == null) {
                  return Text('No data found');
                }
                List<String> splitStringByLength( String str, int length)
                {
                  List<String> data = [];

                  data.add( str.substring(0, length) );
                  data.add( str.substring( length) );
                  return data;
                }


                final data = snapshot.data!.docs;
                return Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final row =
                      data[index].data() as Map<String, dynamic>;
                      List<String>body  = splitStringByLength(row["body"],28);
                      return Card(
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
                        child: Container(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading:Icon(Icons.notification_important,color: Colors.blue,),
                            title: Text(
                              row["title"],
                              style:GoogleFonts.poppins(
                                  color: Colors.lightBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
                            subtitle: Column(children: [
                              const SizedBox(
                                height: 30.0,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(body[0]+ " \n "+ body[1],

                                      style: TextStyle(color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ))
                                ],
                              ),


                            ]),

                            // https://console.firebase.google.com/u/2/project/fyp-nawaf-mujeeb/database/fyp-nawaf-mujeeb-default-rtdb/data/~2F

                            trailing: IconButton(
                                icon: Icon(Icons.cancel_outlined,
                                    color: Colors.red, size: 30.0),
                                onPressed: () {
                                  FirebaseFirestore.instance.collection('Notifications').doc(data[index].id).update({'status': 'Cancelled'});
                                }),
                          ),
                        ),
                      );
                    },
                  ),
                );
            }
          }),
    );
  }
}