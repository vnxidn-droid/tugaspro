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
              children: [

                Text(
                  "welcome to",
                  style: TextStyle(
                    fontFamily: "cyber2",
                    fontSize: 33,
                    color: Colors.blue
                  ),
                ),

                SizedBox( height: 60,),

                Text(
                  "mepro",
                  style: TextStyle(
                    fontFamily: "cyber2",
                    fontSize: 88,
                  ),
                ),





                ElevatedButton(
                  onPressed: () {
                    print("test");
                  },

                  child: Text("test"),


                ),


              ],

          ),





          ),


    );
  }

}