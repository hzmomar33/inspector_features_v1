import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import './model/DrawingPoints.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Draw extends StatefulWidget {
//  final GlobalKey<_DrawState> key = GlobalKey();
  Draw({Key key, this.imagePath, this.capturedImage}): super(key : key);
  final String imagePath;
  final List capturedImage;
  @override
  _DrawState createState() => _DrawState();
}


class _DrawState extends State<Draw> {
  Color selectedColor = Colors.black;
  Color pickerColor = Colors.black;
  double strokeWidth = 3.0;
  List<DrawingPoints> points = List();
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;

  ui.Image bckImage;
  bool isImageLoaded = false;

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blueAccent,
    Colors.amber,
    Colors.black
  ];

  @override
  void initState() {
    super.initState();
    File myFile = File(widget.imagePath);
    _loadImage(myFile);
  }

  @override
  Widget build(BuildContext context) {
    List<String> capturedImage = widget.capturedImage;
    return bckImage != null ?  Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.greenAccent
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.album,),
                      onPressed: (){
                        setState(() {
                          if(selectedMode == SelectedMode.StrokeWidth){
                            showBottomList = !showBottomList;
                          }
                          selectedMode = SelectedMode.StrokeWidth;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.opacity),
                      onPressed: (){
                        setState(() {
                          if(selectedMode == SelectedMode.Opacity){
                            showBottomList = !showBottomList;
                          }
                          selectedMode = SelectedMode.Opacity;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.color_lens),
                      onPressed: (){
                        setState(() {
                          if(selectedMode == SelectedMode.Color){
                            showBottomList = !showBottomList;
                          }
                          selectedMode = SelectedMode.Color;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: (){
                        setState(() {
                          showBottomList = false;
                          points.clear();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.save_alt),
                      onPressed: () async{
                        getImage();
                      },
                    )
                  ],
                ),
                Visibility(
                  child: (selectedMode == SelectedMode.Color)
                    ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: getColorList(),
                  ) : Slider(
                    value: (selectedMode == SelectedMode.StrokeWidth) ? strokeWidth : opacity,
                    max: (selectedMode == SelectedMode.StrokeWidth) ? 50.0 : 1.0,
                    min: 0.0,
                    onChanged: (val) {
                      setState(() {
                      if(selectedMode == SelectedMode.StrokeWidth){
                      strokeWidth = val;
                      }else{
                      opacity = val;
                      }
                      });
                    }),
                  visible: showBottomList,
                )
              ],
            ),
          ),
        ),
      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            points.add(DrawingPoints(
              points: renderBox.globalToLocal(details.globalPosition),
              paint: Paint()
                ..strokeCap = strokeCap
                ..isAntiAlias = true
                ..color = selectedColor.withOpacity(opacity)
                ..strokeWidth = strokeWidth
            ));
          });
        },
        onPanStart: (details) {
          setState(() {
            RenderBox renderbox = context.findRenderObject();
            points.add(DrawingPoints(
              points: renderbox.globalToLocal(details.globalPosition),
              paint: Paint()
                ..strokeCap = strokeCap
                ..isAntiAlias = true
                ..color = selectedColor.withOpacity(opacity)
                ..strokeWidth = strokeWidth
            ));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },

        child: SizedBox(
          width: bckImage.width.toDouble(),
          height: bckImage.height.toDouble(),
          child: CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 500),
            painter: DrawingPainter(pointsList: points, image: bckImage)
          ),
        ),
      ),
    ) :
        Container(child: Center(child: CircularProgressIndicator(),),);
//    return bckImage != null ?
//        WillPopScope(
//          onWillPop: () async => false,
//          child: Stack(
//            children: <Widget>[
//              FittedBox(
//                child: SizedBox(
//                  width: bckImage.width.toDouble(),
//                  height: bckImage.height.toDouble(),
//                  child: CustomPaint(
//                    painter: DrawingPainter(pointsList: points, image: bckImage),
//                  ),
//                ),
//              ),
//              Center(
//                child: RaisedButton(
//                  onPressed: () {
//                    getImage();
////                    capturedImage = ['/data/user/0/com.carsome.inspector_v1/app_flutter/Pictures/inspector/1567498844738.jpg'];
////                    Navigator.pop(context, capturedImage);
//                  },
//                  child: Text('Test'),
//                ),
//              )
//            ],
//          ),
//        )
//     : Container(child: Center(child: CircularProgressIndicator(),),);
  }

  getColorList(){
    List<Widget> listWidget = List();
    for(Color color in colors) {
      listWidget.add(colorCircle(color));
    }

    Widget colorPicker = GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: (color) {
                    pickerColor = color;
                  },
                  enableLabel: true,
                  pickerAreaHeightPercent:  0.8,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Save'),
                  onPressed: () {
                    setState(() {
                      selectedColor = pickerColor;
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.green, Colors.blue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
            )
          ),
        ),
      ),
    );

    listWidget.add(colorPicker);
    return listWidget;
  }

  Widget colorCircle(Color color){
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedColor = color;
        });
      },
      child: ClipOval(
        child: Container(
          padding: const EdgeInsets.only(bottom: 16.0),
          height: 36,
          width: 36,
          color: color,
        ),
      ),
    );
  }

  void getImage() async{
    ui.PictureRecorder recorder = ui.PictureRecorder();
    DrawingPainter _painter = DrawingPainter(pointsList: points, image: bckImage);
    _painter.paint(Canvas(recorder), Size(10, 10));

    ui.Image _image =  await recorder.endRecording().toImage(context.size.width.floor(), context.size.height.floor());
    ByteData data = await _image.toByteData(
      format: ui.ImageByteFormat.png
    );
//    debugPrint(data.buffer.asUint8List().toString());
    //TODO- save as file / external file / album
//    File('dskoad/dsa').writeAsBytesSync(data.buffer.asUint8List());
    showDialog(context: context,
    builder: (context) {
      return AlertDialog(
        content: Image.memory(Uint8List.view(data.buffer)),
      );
    });
  }

  void _loadImage(File file) async {
    final data = await file.readAsBytes();
    ui.Image _images  =  await decodeImageFromList(data);
    setState(() {
      bckImage = _images;
    });
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList, this.image});
  List<DrawingPoints> pointsList;
  ui.Image image;
  List<Offset> offsetPoints = List();
  @override
  void paint(Canvas canvas, Size size) {
//    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
//    final FittedSizes sizes = applyBoxFit(BoxFit.fitWidth, imageSize, Rect)
    canvas.drawImage(image, Offset(0.0, 0.0), Paint());
    for(int i=0; i<pointsList.length -1; i++){
      if(pointsList[i] != null && pointsList[i + 1] != null){
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points, pointsList[i].paint );
      }else if(pointsList[i] != null && pointsList[i + 1] == null){
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
          pointsList[i].points.dx + 0.1,
          pointsList[i].points.dy + 0.1
        ));
        canvas.drawPoints(ui.PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}

enum SelectedMode {StrokeWidth,Opacity, Color}
