
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';


class MilkQuantityPage extends StatefulWidget {

  const MilkQuantityPage({
    Key? key,
  }) : super(key: key);

  @override
  _MilkQuantityPageState createState() => _MilkQuantityPageState();
}


class _MilkQuantityPageState extends State<MilkQuantityPage>{

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          'Milk Quantity',
        ),
        actions: const [],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.33,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  color: const Color(0xFFF5F5F5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(0),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 45, 0, 0),
                    child: SelectionArea(
                        child: GradientText(
                          'Milk Quantity \n Report',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 54,
                            fontWeight: FontWeight.w800,
                          ),
                          colors: const [
                            Color(0xff159DFF),
                            Color(0xff002981),
                          ],
                          gradientDirection: GradientDirection.ltr,
                          gradientType: GradientType.linear,
                        )

                    ),
                  ),
                ),
              ),

              Container(
                child: Image.asset("assets/images/aaaaaa.png",fit: BoxFit.cover,),
                height: 300,
                width: 300,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black),
              ),
              SizedBox(height:10),
              Container(
                alignment: Alignment.center,
                child:   Text("4000 "+"Litres",style: const TextStyle( fontFamily: 'Poppins',
                  fontSize: 54,
                  fontWeight: FontWeight.w800,)),
                height: 100,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xFF54f8cc)),
              ),

              SizedBox(height:10),
              Container(
                padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                alignment: Alignment.center,
                child:   const Text("Note: The Quantity Shown Above Is Directly Coming from Container. \n           All the Conversion from Sensor val "
                    "and dimension done there. \n           Some different may occur",style: TextStyle( fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.w800,)),
                height: 50,
                width: MediaQuery.of(context).size.width,

                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black),
              ),
            ]
                    ) ,),

                ),
              ),);

  }}
