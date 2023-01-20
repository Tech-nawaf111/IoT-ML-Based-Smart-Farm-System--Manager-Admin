import 'package:flutter/material.dart';


class VerticalPlaceItem extends StatelessWidget {
  final List<String>? data;
  VerticalPlaceItem({this.data});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: InkWell(
        child: Container(
          height: 70.0,
          child: Row(
            children: <Widget>[
              const CircleAvatar(
                radius: 20.0,
                child: Icon(Icons.account_circle,size: 20.0,),
              ),
              const SizedBox(width: 20.0),
              Container(
                height: 80.0,
                width: MediaQuery.of(context).size.width - 200.0,
                padding: const EdgeInsets.fromLTRB(0.0,30.0,0.0,0.0),
                child: const Text(
                  "ExampleEmail@gmail.com",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.0,
                  ),
                  maxLines: 2,
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                  height: 30.0,
                  width: 90.0,
                  child:
                  ElevatedButton(
                    key: const Key('loginForm_continue_raisedButton'),
                    style: ElevatedButton.styleFrom(

                      primary: const Color(0xFF292723),
                    ),

                    onPressed: (){},
                    child: const Text('Approve'),
                  )

              ),
            ],
          ),
        ),
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (BuildContext context) {
          //    //   return Details();
          //     },
          //   ),
          // );
        },
      ),
    );
  }
}