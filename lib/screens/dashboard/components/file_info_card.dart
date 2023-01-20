import 'package:admin_app/cow_registration/registerCowRepository.dart';
import 'package:flutter/material.dart';
import '../../../breed_detection/breed_detection.dart';
import '../../../constants.dart';
import '../../../cow_registration/register_cow.dart';
import '../../../milkQuality/repository/IoTSensorsRepo.dart';
import '../../../milkQuality/screen/milk_quality_detection_screen.dart';
import '../../../models/MyFiles.dart';
import '../../../user_management/all_users.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
    required this.index,
  }) : super(key: key);

  final CloudStorageInfo info;
  final int index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {

      if(index==0){

       CowRepository cowRepository = new CowRepository(null,null,null,null);
        int currentcow1 = await cowRepository.RetreivePreviousRegCow();


        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  CowRegistration( currentcownum: currentcow1,)),
        );

        print('hello my name is nawaf1');

        }
        else if(index==1){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AllUsers()),
          );

          print('hello my name is nawaf1');
        }else if(index==2){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MilkQualityDetection()),
          );
        }else if(index==3){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  DetectScreen()),
          );
        }
      },
        child:Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: const BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Image(image: AssetImage(info.svgSrc!))
              ),

            ],
          ),
          Text(
            info.title!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ProgressLine(
            color: info.color,
            percentage: info.percentage,
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Text(
          //       "${info.numOfFiles} Files",
          //       style: Theme.of(context)
          //           .textTheme
          //           .caption!
          //           .copyWith(color: Colors.white70),
          //     ),
          //     Text(
          //       info.totalStorage!,
          //       style: Theme.of(context)
          //           .textTheme
          //           .caption!
          //           .copyWith(color: Colors.white),
          //     ),
          //   ],
          // )
        ],
      ),
    ));
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
