import 'package:admin_app/feed_stocks/feed_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:flutter/material.dart';
import '../../../constants.dart';
import '../../../feed_stocks/feed_repository.dart';
import '../../loadingDailog/loading_dailog.dart';
import 'chart.dart';
import 'storage_info_card.dart';

class FeedDetails extends StatefulWidget {
  const FeedDetails({
    Key? key,
  }) : super(key: key);

  @override
  FeedScreenState createState() => FeedScreenState();
}


class FeedScreenState extends State<FeedDetails> {
  final TextEditingController _feedpriceController = TextEditingController();
  // ignore: non_constant_identifier_names
  final TextEditingController _QuantityController = new TextEditingController();
  final TextEditingController _PerDayController = new TextEditingController();
  List dropdownItemListoffeeds = [];
  String feed = "";
  List<String> feeds =
  [
    'Maize',
    'Wheat middlings',
    'Plant Protein',
    'Roughages',
  ];

  @override
  void initState() {

    for (var i = 0; i < feeds.length; i++) {
      dropdownItemListoffeeds.add(
        {
          'label': feeds[i],
        },
      );
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Feed Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: defaultPadding),
          Chart(),

          AvailableQuantity(),
          
          // StorageInfoCard(
          //   svgSrc: "assets/icons/Documents.svg",
          //   title: "Milk Sale",
          //   amountOfFiles: "19 Million",
          //   numOfFiles: 1328,
          // ),
          // StorageInfoCard(
          //   svgSrc: "assets/icons/Documents.svg",
          //   title: "Feed Expenses",
          //   amountOfFiles: "8 Million",
          //   numOfFiles: 1328,
          // ),
          // StorageInfoCard(
          //   svgSrc: "assets/icons/Documents.svg",
          //   title: "Health Expenses",
          //   amountOfFiles: "500K",
          //   numOfFiles: 1328,
          // ),
          // StorageInfoCard(
          //   svgSrc: "assets/icons/Documents.svg",
          //   title: "Others",
          //   amountOfFiles: "2 Million",
          //   numOfFiles: 140,
          // ),
    SizedBox(height: 15),
    Container(
    height: 50,
    width: 340,
    margin: const EdgeInsets.fromLTRB(15, 0, 0, 0),
    child:
          ElevatedButton(onPressed:(){


          showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
          topLeft: const Radius.circular(25.0),
          topRight: const Radius.circular(25.0),
          ),
          ),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
          const Text('Add Treatment for Cow',style: TextStyle(fontSize: 20),),
          Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
          child: Center(
          child: CoolDropdown(

          defaultValue: dropdownItemListoffeeds[0],
          dropdownList: dropdownItemListoffeeds,
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
          feed = value['label'];
          });
          print(feed);
          },
          ),
          ),
          ),
          const SizedBox(height:20),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: TextFormField(
                obscureText: false,
                style: TextStyle(color: Color(0xFF292723)),
                controller: _feedpriceController,
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
                child: TextFormField(
                  obscureText: false,
                  style: TextStyle(color: Color(0xFF292723)),
                  controller: _QuantityController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.drive_file_rename_outline,
                        color: Color(0xFF292723)),
                    labelText: 'Quantity',
                    hintText: 'Enter Quantity',
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
              padding: EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
              child: TextFormField(
                obscureText: false,
                style: TextStyle(color: Color(0xFF292723)),
                controller: _PerDayController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.drive_file_rename_outline,
                      color: Color(0xFF292723)),
                  labelText: 'Enter Quantity Per Cow per Day',
                  hintText: 'Enter Quantity Per Cow per Day',
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
          ElevatedButton(
          child: const Text('Confirm'),
          onPressed: () async {

            openLoadingDialog(context, 'Adding Feed Details', true);
            FeedModel feedModel = FeedModel(
                feed,
                _feedpriceController.text
                ,_QuantityController.text,
                _PerDayController.text);

            final FirebaseFirestore _firestore =
                FirebaseFirestore.instance;
            final CollectionReference _mainCollection1 =
            _firestore.collection('feed');
            DocumentReference documentReference1 = FirebaseFirestore
                .instance
                .collection('feed')
                .doc(feed);
            FeedRespository feedRepo = FeedRespository(_firestore,
                _mainCollection1, documentReference1, feed);
            await feedRepo.uploadFeed(feedModel);
            openLoadingDialog(context, 'Registering Cow...', false);

          },
          ),
          ElevatedButton(
          child: const Text('Close BottomSheet'),
          onPressed: () => Navigator.pop(context),
          ),

          ],
          ),
          ),
          );


          }
          ,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
    ),
    child: const Text('Add Feed Record'),)),
        ],
      ),
    );
  }

}
class AvailableQuantity extends StatelessWidget {
  const AvailableQuantity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('feed')
            .snapshots(),
        builder: (context, snapshot) {
          print('NNNN');
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
              final data = snapshot.data!.docs;
              return Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final row = data[index].data() as Map<String, dynamic>;
                 //   final id = data[index].id;
                    return  FeedInfoCard(
                      svgSrc: "assets/icons/crops.svg",
                      title: row["Name"],
                      price: row["Price"],
                      Quantity: row["Quantity"],
                    );
                  },
                ),
              );
          }
        });
  }
}
