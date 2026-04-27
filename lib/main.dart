import 'package:flutter/material.dart';



void main() {
  runApp(new MaterialApp(
    home: new Ui1finn(

    ),
  ));
}


class Ui1finn extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
    body:
        new Center(
          child: Column(

             mainAxisAlignment: MainAxisAlignment.center,
              children: const[

                Text(
                  "welcome to",
                  style: TextStyle(
                    fontFamily: "cyber2",
                    fontSize: 33,
                  ),
                ),

                Text(
                  "me pro",
                  style: TextStyle(
                    fontFamily: "cyber2",
                    fontSize: 66,
                  ),
                ),

                Text(
                  "by finn",
                  style: TextStyle(
                    fontFamily: "cyber2",
                    fontSize: 33,
                  ),

                )

              ],
          ),





          ),


    );
  }

}