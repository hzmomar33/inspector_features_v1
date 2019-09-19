import 'package:background_fetch/background_fetch.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inspector_v1/IsolatePage.dart';
import 'MyHomePage.dart';
import 'Draw.dart';

void main(){
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MyHomePage(title: 'Title',);
//  return MaterialApp(
//    debugShowCheckedModeBanner: false,
//    home: Draw(),
//  );

//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: IsolatePage(),
//    );
  }
}