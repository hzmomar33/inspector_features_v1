import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../Draw.dart';

class Camera_tab extends StatefulWidget {
  @override
  _Camera_tabState createState() => _Camera_tabState();
}

class _Camera_tabState extends State<Camera_tab> {
  List<CameraDescription> cameras;
  CameraController controller;
  List<String> images = [];
  bool isCapturing = false;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    setupCameras();
//    cameras = widget.cameras;
//    controller = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
//    controller.initialize().then((_) {
//      if(!mounted){
//        return;
//      }
//    });
  }

  Future<void> setupCameras() async{
    try {
      cameras = await availableCameras();
      controller = new CameraController(cameras[0], ResolutionPreset.high);
      await controller.initialize();
    }on CameraException catch (_){
      print('Camera Failed');
    }
    setState(() {
      isReady = true;
    });

  }
  @override
  Widget build(BuildContext context) {

    Future<void> _takePicture() async {
      setState(() {
        isCapturing = true;
      });
      String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/Pictures';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${timestamp()}.jpg';

//      if(controller.value.isTakingPicture){
//        return null;
//      }
      try{
        await controller.takePicture(filePath);
//        var result = await ImageGallerySaver.saveFile(filePath);
        setState(() {
          print(filePath);
          images.insert(0, filePath);
          isCapturing = false;
        });
      }on CameraException catch(e){
        print(e);
      }
//      Navigator.push(
//        context,
//          MaterialPageRoute(builder: (context) => Gallery(image: filePath,))
//      );
    }

    return
      isReady ?
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            children: <Widget>[
              CameraPreview(controller),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: images.length > 0 ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      FloatingActionButton(
                        onPressed: _takePicture,
                        backgroundColor: isCapturing ? Colors.grey : Colors.blue,
                        child: isCapturing ? CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          strokeWidth: 1.0,
                        ) : Icon(Icons.camera),
                      ),
                      Padding(
                        padding: EdgeInsets.all(3.0),
                        child: Container(
                          height: 70.0,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:images.length,
                            itemBuilder: (context, index) {
                              return Material(
                                color: Colors.transparent,
                                child: Container(
                                  padding: EdgeInsets.only(left: 2.0, right: 2.0),
                                  child: InkWell(
                                    onTap: () {
//                                      final dataFromDrawPage = await Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) => Draw(imagePath: images[index],capturedImage: images,)
//                                          ),) ;
//                                      setState(() {
//                                        images = dataFromDrawPage;
//                                      });
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Draw(imagePath: images[index],)
                                      ));
                                    },
                                    child: Image.file(File(images[index])),
                                  ),
                                ),
                              );
                            },
                            addAutomaticKeepAlives: true,
                          ),
                        )
                      )
                    ],
                  ) : FloatingActionButton(
                    onPressed: _takePicture,
                    backgroundColor: isCapturing ? Colors.grey : Colors.blue,
                    child: isCapturing ? CircularProgressIndicator(backgroundColor: Colors.white, strokeWidth: 1.0,) : Icon(Icons.camera),
                  ),
                ),
              )
            ],
          )
        ) :
        Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
//                Text('Get Available Cameras..')
              ],
            ),
          ),
        );
  }
}
