import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingWidget extends Center {
  LoadingWidget()
      : super(
    child: const SizedBox(
      width: 45,
      height: 45,
      child: SpinKitFoldingCube(color: Color(0xffff1616)),
    ),
  );
}
