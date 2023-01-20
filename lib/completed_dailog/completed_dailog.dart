import 'package:animated_check/animated_check.dart';
import 'package:flutter/material.dart';


openCompletedDialog(BuildContext context, String text,) {

    return showDialog(

      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        insetPadding: EdgeInsets.all(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 15),
            Text(text)
          ],
        ),
      ),
    );
}
