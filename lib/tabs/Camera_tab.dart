import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../Draw.dart';

class Camera_tab extends StatefulWidget {
  final List<CameraDescription> cameras;
  Camera_tab({Key key, this.cameras}) : super(key:key);
  @override
  _Camera_tabState createState() => _Camera_tabState();
}

class _Camera_tabState extends State<Camera_tab> {
  List<CameraDescription> cameras;
  CameraController controller;
  List<String> images = ['/data/user/0/com.carsome.inspector_v1/app_flutter/Pictures/inspector/1567498844738.jpg'];
  bool isCapturing = false;

  @override
  void initState() {
    super.initState();
    cameras = widget.cameras;
    controller = CameraController(cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if(!mounted){
        return;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    if(!controller.value.isInitialized){
      return Container();
    }

    Future<void> _takePicture() async {
      setState(() {
        isCapturing = true;
      });
      String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();
      if(!controller.value.isInitialized){
        print(controller.value.isInitialized);
      }
      final Directory extDir = await getExternalStorageDirectory();
      final String dirPath = '${extDir.path}/Pictures';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/${timestamp()}.jpg';

      if(controller.value.isTakingPicture){
        return null;
      }
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
        AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: Stack(
            children: <Widget>[
              CameraPreview(controller),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
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
                                    child: Image.asset(images[index]),
                                  ),
                                ),
                              );
                            },
                            addAutomaticKeepAlives: true,
                          ),
                        )
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        );
  }
}
