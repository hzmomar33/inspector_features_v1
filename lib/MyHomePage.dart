import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:inspector_v1/pageView.dart';
import 'package:inspector_v1/providers/capture_image.dart';
import 'package:provider/provider.dart';
import './tabs/Camera_tab.dart';
import './tabs/Editor_tab.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Camera_tab()
    );

//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      home: PagesView(),
//    );
  }
}
