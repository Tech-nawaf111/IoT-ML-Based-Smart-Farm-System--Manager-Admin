import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class Chart extends StatelessWidget {
  const Chart({
    Key? key,
  }) : super(key: key);

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
              int total = 0;
              int Available = 0;
              final data = snapshot.data!.docs;
              for(int i = 0 ; i< data.length ; i++) {
                final datax = data[i].data() as Map<String, dynamic>;
                 total+=int.parse(datax["Quantity"]);
                 Available+=int.parse(datax["available"]);
              }

                    return SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 70,
                              startDegreeOffset: -90,
                              sections: paiChartSelectionDatas,
                            ),
                          ),
                          Positioned.fill(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: defaultPadding),
                                Text(
                                   Available.toString()+" Kgs",
                                  style: Theme.of(context).textTheme.headline5!.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    height: 0.5,
                                  ),
                                ),
                                Text("   out of \n"+total.toString()+" Kgs")
                              ],
                            ),
                          ),
                        ],
                      ),
                    );

          }
        });




  }
}

List<PieChartSectionData> paiChartSelectionDatas = [
  PieChartSectionData(
    color: primaryColor,
    value: 25,
    showTitle: false,
    radius: 25,
  ),
  PieChartSectionData(
    color: const Color(0xFF26E5FF),
    value: 20,
    showTitle: false,
    radius: 22,
  ),
  PieChartSectionData(
    color: const Color(0xFFFFCF26),
    value: 10,
    showTitle: false,
    radius: 19,
  ),
  PieChartSectionData(
    color: const Color(0xFFEE2727),
    value: 15,
    showTitle: false,
    radius: 16,
  ),
  PieChartSectionData(
    color: primaryColor.withOpacity(0.1),
    value: 25,
    showTitle: false,
    radius: 13,
  ),
  // PieChartSectionData(
  //   color: const Color(0xFFFE1767),
  //   value: 15,
  //   showTitle: false,
  //   radius: 16,
  // ),
];
