
import 'package:flutter/material.dart';

import '../constants.dart';

class CloudStorageInfo {
  final String? svgSrc, title, totalStorage;
  final int? numOfFiles, percentage;
  final Color? color;

  CloudStorageInfo({
    this.svgSrc,
    this.title,
    this.totalStorage,
    this.numOfFiles,
    this.percentage,
    this.color,
  });
}

List demoMyFiles = [
  CloudStorageInfo(
    title: "Register a Cow",
    svgSrc: "assets/images/RegisterCow.png",
    totalStorage: "",
    color: primaryColor,
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Accept Profiles",
    svgSrc: "assets/images/AcceptProfile.png",
    totalStorage: "",
    color: Color(0xFFFFA113),
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "IoT Milk Quality",
    svgSrc: "assets/images/IoTMilk.png",
    totalStorage: "",
    color: Color(0xFFA4CDFF),
    percentage: 100,
  ),
  CloudStorageInfo(
    title: "Cow Breed Detection",
    svgSrc: "assets/images/AllCows.png",
    totalStorage: "",
    color: Color(0xFF007EE5),
    percentage: 100,
  ),
];
