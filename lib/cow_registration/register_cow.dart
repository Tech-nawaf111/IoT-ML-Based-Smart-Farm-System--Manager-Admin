import 'dart:io';
import 'package:admin_app/cow_registration/registerCowRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../completed_dailog/completed_dailog.dart';
import '../screens/QR_generation_page/qr_page.dart';
import '../screens/loadingDailog/loading_dailog.dart';
import 'cow_model.dart';

class CowRegistration extends StatefulWidget {
  int currentcownum;

  CowRegistration({
    Key? key,
    required this.currentcownum,
  }) : super(key: key);

  @override
  _CowRegistrationState createState() => _CowRegistrationState();
}


class _CowRegistrationState extends State<CowRegistration> with SingleTickerProviderStateMixin{
  final TextEditingController _cowpriceController = new TextEditingController();
  final TextEditingController _cowMilkValue = TextEditingController();

  String age = "";
  String isvaccinatedstatus = "";
  String totalcalfs = "";
  String selectedbreed = "";
  DateTime selectedDate = DateTime.now();
  File? imageFile;
  File? croppedFile;
  String verificationID = "";
  late String currentregx;
  List dropdownItemListforage = [];
  List dropdownItemListforcalfs = [];
  List dropdownItemListforVaccinationStatus = [];
  List dropdownItemListforbreeds = [];
  List<String> ages = [
    'less than 1 year',
    '1 Year',
    '2 Years',
    '3 Years',
    '4 years',
    'more than 5 years'
  ];
  List<String> calfs = [
    '1 Calf',
    '2 Calfs',
    '3 Calfs',
    '4 Calfs',
    '5 Calfs',
  ];
  List<String> VaccinationStatus = [
    'Vaccinated',
    'Not Vaccinated',
  ];
  List<String> Breeds = [
    "Black kapila",
   "Sahiwal" ,
    "Girolando",
    "Gyr",
    "Holstein Friesian" ,
    "Aberdeen Angus",
  ];

  // final homeScaffoldKey = GlobalKey<ScaffoldState>();
  // final searchScaffoldKey = GlobalKey<ScaffoldState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late TickerProvider tick;
  @override
  void initState() {

    currentregx = (widget.currentcownum += 1).toString();

    for (var i = 0; i < ages.length; i++) {
      dropdownItemListforage.add(
        {
          'label': ages[i],
        },
      );
    }

    for (var i = 0; i < calfs.length; i++) {
      dropdownItemListforcalfs.add(
        {
          'label': calfs[i],
        },
      );
    }
    for (var i = 0; i < VaccinationStatus.length; i++) {
      dropdownItemListforVaccinationStatus.add(
        {
          'label': VaccinationStatus[i],
        },
      );
    }
    for (var i = 0; i < Breeds.length; i++) {
      dropdownItemListforbreeds.add(
        {
          'label': Breeds[i],
        },
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mediaTypeSelector() async {
      _getFromGallery() async {
        print('reached here');
        final pickedFile = await ImagePicker().getImage(
          source: ImageSource.gallery,
          maxWidth: 300,
          maxHeight: 300,
        );
        if (pickedFile != null) {
          setState(() {
            print('reached here 2');
            imageFile = File(pickedFile.path);
          });
        }
        // Navigator.of(context).pop();
      }

      /// Get from Camera
      // ignore: always_declare_return_types
      _getFromCamera() async {
        final pickedFile = await ImagePicker().getImage(
          source: ImageSource.camera,
          maxWidth: 300,
          maxHeight: 300,
        );
        if (pickedFile != null) {
          setState(() {
            imageFile = File(pickedFile.path);
          });
        }
      }

      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Choose image source'),
            content: Text(""),
            actions: <Widget>[
              ElevatedButton(
                child: Column(
                  children: const [
                    Icon(Icons.camera_alt_outlined),
                    SizedBox(height: 8),
                    Text("Camera"),
                  ],
                ),
                onPressed: () => _getFromCamera(),
              ),
              ElevatedButton(
                child: Column(
                  children: const [
                    Icon(Icons.browse_gallery_outlined),
                    SizedBox(height: 8),
                    Text("Galary"),
                  ],
                ),
                onPressed: () => _getFromGallery(),
              ),
            ],
          );
        },
      );
    }


    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Color(0xFF292723),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        title: const Text(
          'Register Cow',
        ),
        actions: const [],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 1,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 20,
              ),
              Row(children: [
                SizedBox(width: 10),
                Container(
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        'COW \n REGISTRATION \n  ID',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentregx,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'poppins',
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  //   backgroundColor: Color(0xFF292723),

                  height: 200,
                  width: 100,

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black),
                ),
                SizedBox(width: 10),
                Stack(
                  children: <Widget>[
                    Container(
                      child: imageFile == null
                          ? Image.asset("assets/images/RegisterCow.png")
                          : Image.file(
                              imageFile!,
                              fit: BoxFit.cover,
                            ),

                      //   backgroundColor: Color(0xFF292723),

                      height: 200,
                      width: 300,

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.black),
                    ),
                    Positioned(
                      child: GestureDetector(
                        child: const CircleAvatar(
                          child: Icon(
                            Icons.camera_alt_outlined,
                            color: Color(0xFF292723),
                          ),
                          backgroundColor: Colors.grey,
                        ),
                        onTap: mediaTypeSelector,
                      ),
                      top: 152.0,
                      right: 0.0,
                    )
                  ],
                ),
              ]),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  obscureText: false,
                  style: TextStyle(color: Color(0xFF292723)),
                  controller: _cowpriceController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.drive_file_rename_outline,
                        color: Color(0xFF292723)),
                    labelText: 'Price',
                    hintText: 'Enter Cow Price',
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF292723),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: const TextStyle(
                      color: Color(0xFF292723),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF292723),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Center(
                  child: CoolDropdown(

                    defaultValue: dropdownItemListforage[0],
                    dropdownList: dropdownItemListforage,
                    resultHeight: 74,
                    resultWidth: 394,
                    dropdownWidth: 390,
                    dropdownHeight: 200,
                    resultBD: BoxDecoration(
                      border: Border.all(color: Color(0xFF292723), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onChange: (value) {
                      setState(() {
                        age = value['label'];
                      });
                      print(age);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Center(
                  child: CoolDropdown(
                    defaultValue: dropdownItemListforVaccinationStatus[0],
                    dropdownList: dropdownItemListforVaccinationStatus,
                    resultHeight: 74,
                    resultWidth: 394,
                    dropdownWidth: 390,
                    dropdownHeight: 200,
                    resultBD: BoxDecoration(
                      border: Border.all(color: Color(0xFF292723), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onChange: (value) {
                      setState(() {
                        isvaccinatedstatus = value['label'];
                      });
                      print(isvaccinatedstatus);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Center(
                  child: CoolDropdown(
                    defaultValue: dropdownItemListforcalfs[0],
                    dropdownList: dropdownItemListforcalfs,
                    resultHeight: 74,
                    resultWidth: 394,
                    dropdownWidth: 390,
                    dropdownHeight: 200,
                    resultBD: BoxDecoration(
                      border: Border.all(color: Color(0xFF292723), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onChange: (value) {
                      setState(() {
                        totalcalfs = value['label'];
                      });
                      print(totalcalfs);
                    },
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Center(
                  child: CoolDropdown(
                    defaultValue: dropdownItemListforbreeds[0],
                    dropdownList: dropdownItemListforbreeds,
                    resultHeight: 74,
                    resultWidth: 394,
                    dropdownWidth: 390,
                    dropdownHeight: 200,
                    resultBD: BoxDecoration(
                      border: Border.all(color: Color(0xFF292723), width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    onChange: (value) {
                      setState(() {
                        selectedbreed = value['label'];
                      });
                      print(selectedbreed);
                    },
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: TextFormField(
                  controller: _cowMilkValue,
                  style: TextStyle(color: Color(0xFF292723)),
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Milk Quantity',
                    hintText: 'Enter milk quantity in litres',
                    prefixIcon:
                        const Icon(Icons.liquor, color: Color(0xFF292723)),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0xFF292723),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    labelStyle: const TextStyle(
                      color: Color(0xFF292723),
                    ),

                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF292723),
                        width: 1,
                      ),
                    ),
                    filled: true,
                    // fillColor: FlutterFlowTheme.of(context).darkBackground,
                    contentPadding:
                        EdgeInsetsDirectional.fromSTEB(20, 24, 20, 24),
                  ),
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                  height: 50,
                  width: 340,
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () async {
                      CowModel cowModel = CowModel(
                          currentregx,
                          _cowpriceController.text,
                          age,
                          isvaccinatedstatus,
                          totalcalfs,
                          _cowMilkValue.text,
                          selectedbreed,
                          "",
                          imageFile);

                      openLoadingDialog(context, 'Registering Cow...', true);
                      final FirebaseFirestore _firestore =
                          FirebaseFirestore.instance;
                      final CollectionReference _mainCollection1 =
                          _firestore.collection('Cows');
                      DocumentReference documentReference1 = FirebaseFirestore
                          .instance
                          .collection('Cows')
                          .doc(currentregx);
                      CowRepository cowRepository = CowRepository(_firestore,
                          _mainCollection1, documentReference1, currentregx);
                      await cowRepository.uploadCow(cowModel);
                      await cowRepository.UploadPreviousRegCow(
                          int.parse(currentregx));
                      openLoadingDialog(context, 'Registering Cow...', false);

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  CreateQrPage( currentcow: currentregx,)),
                      );



                    },
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFF292723),
                    ),
                    child: const Text('Register Cow'),
                  )),
            ],
          ),
        ),
      ),
    );
  }

// Future<CowModel> passToRepositoryToCreateProfie() async {
//
//   CowModel uploadProfile = new CowModel(
//       _cowIdController.text,
//       _cowpriceController.text,
//       _cowageValue.text,
//       _vaccinatedController.text,
//       _calfsController.text,
//       _cowMilkValue.text,
//       imageFile);
//
//
//   return uploadProfile;
// }
}
