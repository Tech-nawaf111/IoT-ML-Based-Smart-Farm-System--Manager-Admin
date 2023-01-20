import 'package:flutter/material.dart';
import 'Loading_Widget.dart';

openLoadingDialog(BuildContext context, String text, bool state) {
  if(state == true){
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      insetPadding: EdgeInsets.all(50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(width: 35, height: 35, child: LoadingWidget()),
          const SizedBox(height: 15),
          Text(text + "...")
        ],
      ),
    ),
  );}
  else{
    Navigator.of(context, rootNavigator: true).pop();
  }
}
