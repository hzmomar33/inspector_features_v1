import 'dart:isolate';

import 'package:background_fetch/background_fetch.dart';
import 'package:inspector_v1/ImageProcessing.dart';
import 'package:flutter/material.dart';

class IsolatePage extends StatefulWidget {
  @override
  _IsolatePageState createState() => _IsolatePageState();
}

class _IsolatePageState extends State<IsolatePage> {
  bool _enabled = true;
  int _status = 0;
  List<DateTime> _events = [];

  @override
  void initState() {
    super.initState();
//    BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
    initPlatformState();
  }

  Future<void> initPlatformState() async{
    BackgroundFetch.configure(BackgroundFetchConfig(
      minimumFetchInterval: 15,
      stopOnTerminate: false,
      enableHeadless: true
    ), () async{
      print('[BackgroundFetch] Event received');
      setState(() {
        _events.insert(0, new DateTime.now());
      });
      BackgroundFetch.finish();
    }).then((int status){
      print('[BackgroundFetch] SUCCESS: $status');
      setState(() {
        _status = status;
      });
    }).catchError((e){
      print('[BackgroundFetch] ERROR: $e');
      setState(() {
        _status = e;
      });
    });

    int status = await BackgroundFetch.status;
    setState(() {
      _status = status;
    });

    if(!mounted) return;
  }

  void _onClickStatus() async{
    int status = await BackgroundFetch.status;
    print('[BackgroundFetch] status: $status');
    setState(() {
      _status = status;
    });
  }

  void _onClickEnable(enabled){
    setState(() {
      _enabled = enabled;
    });
    if(enabled){
      BackgroundFetch.start().then((int status){
        print('[BackgroundFetch] start success: $status');
      }).catchError((e){
        print('[BackgroundFetch] start FAILURE: $e');
      });
    }else{
      BackgroundFetch.stop().then((int status){
        print('[BackgroundFetch] stop success: $status');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
//    ImageProcessing.getImages();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Background'),
          actions: <Widget>[
            Switch(value: _enabled, onChanged: _onClickEnable,)
          ],
        ),
        body: Container(
          color: Colors.black,
          child: ListView.builder(
            itemCount: _events.length,
            itemBuilder: (context, index){
              DateTime timestamp = _events[index];
              return InputDecorator(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10.0, top: 10.0),
                  labelStyle: TextStyle(color: Colors.amberAccent, fontSize: 20.0 ),
                  labelText: "[background fetch event]"
                ),
                child: Text(timestamp.toString(), style: TextStyle(color: Colors.white, fontSize: 16.0),),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            children: <Widget>[
              RaisedButton(onPressed: _onClickStatus, child: Text('Status'),),
              Container(child: Text('$_status'),margin: EdgeInsets.only(left: 20.0),)
            ],
          ),
        ),
      ),
    );
  }
}
