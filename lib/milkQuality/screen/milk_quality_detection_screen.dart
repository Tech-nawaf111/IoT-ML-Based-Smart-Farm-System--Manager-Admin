import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../function.dart';
import 'package:flutter/material.dart';

class MilkQualityDetection extends StatefulWidget {
  const MilkQualityDetection({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<MilkQualityDetection> {
  String ph = "";
  String temp = "";
  String date = "";
  String lectometer = "";

  @override
  void initState() {
    DatabaseReference tempRef =
        FirebaseDatabase.instance.ref('milk_temperature_value');
    tempRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        temp = event.snapshot.value.toString();
      });
    });

    DatabaseReference phRef = FirebaseDatabase.instance.ref('ph_value');
    phRef.onValue.listen((DatabaseEvent event) {
      setState(() {
        ph = event.snapshot.value.toString();
      });
    });
  }

  var data;

  String output = 'Initial Output';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Milk Quality Detection')),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Column(children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 50, 100, 0),
                child: Text(
                  'Milk Quality \n Detection ',
                  style: GoogleFonts.pacifico(
                      textStyle: const TextStyle(fontSize: 42)),
                ),
              ),
              SizedBox(height: 30),
              TextField(
                onChanged: (value) {
                  lectometer = value.toString();
                },
                decoration: const InputDecoration(
                  labelText: 'Lectometer Value',
                  prefixIcon: Icon(
                    Icons.device_thermostat,
                    color: Colors.brown,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.brown, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.brown, width: 2),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 50, 120, 10),
                  child: Column(children: [
                    Text(
                      "Date Today: " + date,
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 16)),
                    ),
                  ])),
              Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Column(children: [
                    Text(
                      "Values Recieved through sensors",
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 20)),
                    ),
                    Text(
                      "ph Value: " + ph,
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 20)),
                    ),
                    Text(
                      "Temperature Value: " + temp,
                      style: GoogleFonts.poppins(
                          textStyle: const TextStyle(fontSize: 20)),
                    ),
                  ])),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () async {
                    String url = 'http://10.0.2.2:5000/api?ph=' +
                        "7.217" +
                        "&temp=" +
                        "18.5" +
                        "&lect=" +
                        "25";
                    print(url);

                    data = await fetchdata(url);
                    var decoded = jsonDecode(data);
                    setState(() {
                      output = decoded['output'];
                    });

                    print("the detected quality of milk is " + output);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            contentPadding: EdgeInsets.all(0.0),
                            backgroundColor: Colors.white,
                            scrollable: true,
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: const Image(
                                    image: AssetImage("assets/images/xyz.png"),
                                  ),
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 35.0),
                                      child: Text(
                                        "Detected Milk Quality is " + output,
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.only(left: 50.0),
                                      child: Text(
                                        "Send it to 215 potensially registered Users?",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                TextButton.icon(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Color(0x00000000))),
                                  onPressed: () {},

                                  //selectedImage = null,
                                  icon: Icon(
                                    Icons.send,
                                    color: Colors.teal[800],
                                  ),
                                  label: Text(
                                    "Save",
                                    style: TextStyle(color: Colors.teal[800]),
                                  ),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  child: const Text(
                    'Upload Quality',
                    style: TextStyle(fontSize: 20),
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
