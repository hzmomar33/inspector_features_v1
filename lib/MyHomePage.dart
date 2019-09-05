import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:inspector_v1/providers/capture_image.dart';
import 'package:provider/provider.dart';
import './tabs/Camera_tab.dart';
import './tabs/Editor_tab.dart';

class MyHomePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  final String title;
  MyHomePage({Key key, this.title, this.cameras}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: DefaultTabController(
//        length: 2,
//        child: Scaffold(
//          appBar: AppBar(
//            title: Center(child: Text(widget.title)),
//            bottom: TabBar(
//              tabs: <Widget>[
//                Tab(icon: Icon(Icons.camera_alt),),
//                Tab(icon: Icon(Icons.image),)
//              ],
//            ),
//          ),
//          body: TabBarView(
//            children: <Widget>[
//              Camera_tab(cameras: widget.cameras,),
//              Editor_tab(),
//            ],
//          ),
//        ),
//      ),
//    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<CapturedImage>.value(value: CapturedImage(),child: Camera_tab(cameras: widget.cameras,)),
    );
  }
}
