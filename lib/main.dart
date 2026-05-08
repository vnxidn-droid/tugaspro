import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VynTeam(),
    ),

  );
}


class VynTeam extends StatefulWidget{
  @override
  State<VynTeam> createState() => _VynTeamstate();
}

class _VynTeamstate extends State<VynTeam> {
  String status = "Checking permission...";
  @override
  void initState() {
    super.initState();
    requestPermission();
  }
  Future<void> requestPermission() async {
    PermissionStatus permission;
    permission = await Permission.manageExternalStorage.request();
    if (permission.isGranted){
      setState(() {
        status = """[status info]
    ok boskuhh makasih udah kasih akses penyimpanan""";

      });
    }
    else if(permission.isDenied){
      setState(() {
        status = """[status info]
    akses penyimpanan di tolak
    silahkan buka pengaturan""";
 });
      openAppSettings();
    }




  }
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,

        onPressed: () async {
          await Permission.manageExternalStorage.request();
        },

        child: const Icon(Icons.settings),
      ),


      backgroundColor: Colors.black,
      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(status,
            style: TextStyle(
              color: Colors.red,
              fontFamily: "cyber2",
              fontSize: 12,
            ),),

            Text("welcome to",
            style: TextStyle(
              fontFamily: "cyber2",
              fontSize: 33,
              color: Colors.green,
              height: 1,

            ),),

            Text("ME PRO",
              style: TextStyle(
                fontFamily: "cyber2",
                fontSize: 100,
                color: Colors.green,
                height: 1,
              ),

            ),
            Text(
              """aplikasi ini di buat oleh
              mahasiswa universitas islam madura""",
              style: TextStyle(
                fontFamily: "cyber2",
                fontSize: 12,
                color: Colors.green,




            ),
            ),

          ],
        ),
      ),

    );
  }


}