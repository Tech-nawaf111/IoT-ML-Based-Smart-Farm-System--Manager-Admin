import 'dart:convert';
import 'dart:io';
import 'package:admin_app/constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


class DetectScreen extends StatefulWidget {
  DetectScreen();

  @override
  DetectScreenState createState() => new DetectScreenState();
}

class DetectScreenState extends State<DetectScreen> {
  File? selectedImage;
  File? second_Image;
  List<dynamic>? message;
  String? bg_image = "";

 List<String> breed = ["Gyr","Sahiwal","Holstein Friesian","KonKan Kapila","Australian common","Aberdeen Angus"];
 int breednum = 0;
  // Web scrapping data for animals


  uploadImage() async{


    final request = http.MultipartRequest(
        "POST" , Uri.parse("https://d37c-103-255-6-74.ap.ngrok.io/upload")
    );
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile('image',
        selectedImage!.readAsBytes().asStream(),
        selectedImage!.lengthSync(),
        filename: selectedImage!.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    message = resJson['message'];

    print('i receive the following method');
    print(res);
    final doubbList;
      doubbList = message?.map((element) => double.parse(element)).toList();
     breednum = checker(doubbList);
print(breednum);
    second_Image = selectedImage;
    setState(() {
      selectedImage = null;
    });
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
            contentPadding: EdgeInsets.all(0.0),
            backgroundColor: Colors.white,
            scrollable: true,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.file(second_Image! ,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "breed: "+breed[breednum],
                        style: TextStyle(
                            color: Colors.cyan[800], fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10,),


              ],
            ),
          );
        });
  }

  Future pickImage(ImageSource source) async {

    final pickedImage =
    await ImagePicker().getImage(source: source , imageQuality: 100);
    selectedImage = File(pickedImage!.path);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:bgColor,
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Stack(children: [
                    selectedImage == null?
                    Container(


                    ):Container(
                      color: Colors.black,
                    ),


                    SingleChildScrollView(
                      child: Column(

                          children:[
                            SizedBox(
                              height: MediaQuery.of(context).size.height *0.2,
                            ),
                            selectedImage == null
                                ? const Text("Please pick an Image to Upload" , style: TextStyle(
                                color: Colors.white
                            ),)
                            // : Image.file(selectedImage!),
                                :Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                              width: 160,
                              height: 160,
                            ),

                            SizedBox(height: MediaQuery.of(context).size.height *0.1,),

                            SizedBox(height: MediaQuery.of(context).size.height *0.04,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                Material(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.white , width: 2)
                                  ),
                                  elevation: 5,
                                  color: Color(0x00000000),
                                  child: MaterialButton(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    onPressed: () {
                                      pickImage(ImageSource.camera);
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(
                                          Icons.camera,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                        Text(" Camera",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),),
                                      ],
                                    ),
                                  ),
                                ),
                                Material(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(color: Colors.white , width: 2)
                                  ),
                                  elevation: 5,
                                  color: Color(0x00000000),
                                  child: MaterialButton(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                    onPressed: () {
                                      pickImage(ImageSource.gallery);
                                    },
                                    child: Column(
                                      children: const [
                                        Icon(
                                          Icons.browse_gallery,
                                          color: Colors.white,
                                          size: 30.0,
                                        ),
                                        Text(" Gallery",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal),),
                                      ],
                                    ),
                                  ),
                                ),


                              ],
                            ),
                            SizedBox(height: 60),
                            ElevatedButton(
                                onPressed: uploadImage,
                                child: const Text(
                                  'Check Breed',
                                  style: TextStyle(fontSize: 20),
                                )
                            )
                          ]
                      ),

                    ),
                  ]),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
int checker(List<double> arr){
  List<double> temp = [];
  int index = -1;
  for(int i=0; i<arr.length; i++){
    if (arr[i] != 0){
      temp.add(arr[i]);
    }
  }
  double minValue = temp[0];
  for(int i=1; i<temp.length; i++){
    if (temp[i] < minValue){
      minValue = temp[i];
    }
  }
  for(int i=0; i<arr.length; i++){
    if(arr[i] == minValue){
      index = i;
    }
  }
  return index;
}