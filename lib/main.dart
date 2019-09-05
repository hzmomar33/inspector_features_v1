import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'MyHomePage.dart';
import 'Draw.dart';

List<CameraDescription> cameras;

Future<void> main() async{
  cameras = await availableCameras();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Title',cameras: cameras,);
//  return MaterialApp(
//    debugShowCheckedModeBanner: false,
//    home: Draw(),
//  );
  }
}