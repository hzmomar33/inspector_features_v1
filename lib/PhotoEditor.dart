import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import 'package:inspector_v1/Draw.dart';
import 'package:inspector_v1/model/DrawingPoints.dart';

enum SelectedMode {StrokeWidth, Color}
class PhotoEditor extends StatefulWidget {
  final String imagePath;
  PhotoEditor({Key key, this.imagePath}): super(key : key);
  @override
  _PhotoEditorState createState() => _PhotoEditorState();
}

class _PhotoEditorState extends State<PhotoEditor> {
  ui.Image bckImage;
  List<DrawingPoints> points = List();
  double strokeWidth = 5.0;
  bool _changeMode = false;
  List pointsIndexList = List();
  Color selectedColor = Colors.black;
  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blueAccent,
    Colors.amber,
    Colors.black
  ];
  SelectedMode selectedMode = SelectedMode.StrokeWidth;

  @override
  void initState() {
    super.initState();
    _loadImage(File(widget.imagePath));
  }
  void _loadImage(File file) async {
    final data = await file.readAsBytes();
    ui.Image _images  =  await decodeImageFromList(data);
    setState(() {
      bckImage = _images;
    });
  }

  addPointer(Offset gestureOffset){
    points.add(DrawingPoints(
        points: gestureOffset,
        paint: Paint()
          ..color = selectedColor
          ..strokeWidth = strokeWidth
          ..isAntiAlias = true
          ..strokeCap = StrokeCap.round
    ));
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
  getColorList() {
    List<Widget> listWidget = List();
    for(Color color in colors){
      listWidget.add(colorCircle(color));
    }

    return listWidget;
  }

  @override
  Widget build(BuildContext context) {
    Offset gestureOffset;
    return Scaffold(
      backgroundColor: Colors.black,
      body: (bckImage != null) ?
      Stack(
        children: <Widget>[
          GestureDetector(
            onPanEnd: (details) {
              setState(() {
                points.add(null);
              });
            },
            onPanStart: (details){
              points.length > 0 ?
                pointsIndexList.add(points.length - 1) :
                pointsIndexList.add(0);
              setState(() {
                  RenderBox renderBox = context.findRenderObject();
                  gestureOffset = renderBox.globalToLocal(details.globalPosition);
                  addPointer(gestureOffset);
              });
            },
            onPanUpdate: (details){
              setState(() {
                RenderBox renderBox = context.findRenderObject();
                gestureOffset = renderBox.globalToLocal(details.globalPosition);
                addPointer(gestureOffset);
              });
            },
            child: FittedBox(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: CustomPaint(
                  child: Container(
                    width: bckImage.width.toDouble(),
                    height: bckImage.height.toDouble(),
                  ),
                  painter: DrawingPainter(image: bckImage, pointList: points),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 35, right: 8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.close, color: Colors.white, size: 25,),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blueAccent
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.white,),
                          onPressed: (){
                            setState(() {
                              selectedMode = SelectedMode.StrokeWidth;
                              _changeMode = !_changeMode;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.color_lens, color: Colors.white,),
                          onPressed: (){
                            setState(() {
                              selectedMode = SelectedMode.Color;
                              _changeMode = !_changeMode;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.undo, color: Colors.white,),
                          onPressed: (){
                            setState(() {
                              points.removeRange(pointsIndexList[pointsIndexList.length - 1], points.length - 1);
                              pointsIndexList.removeLast();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.refresh, color: Colors.white,),
                          onPressed: (){
                            setState(() {
                              points.clear();
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.save, color: Colors.white,),
                          onPressed: (){},
                        ),
                      ],
                    ),
                    Visibility(
                      visible: _changeMode,
                      child: selectedMode == SelectedMode.StrokeWidth ?
                      Slider(
                        divisions: 10,
                        inactiveColor: Colors.white,
                        label: strokeWidth.toInt().toString(),
                        activeColor: Colors.black,
                        min: 5,
                        max: 50,
                        value: strokeWidth,
                        onChanged: (value){
                          setState(() {
                            strokeWidth = value;
                          });
                        },
                      ) :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: getColorList(),
                      ),
                    )
                  ],
                )
              ),
            ),
          )
        ],
      ) :
      Container(
        child: Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.image, this.pointList});
  ui.Image image;
  List<DrawingPoints> pointList;
  Offset dottedOffset;
  List<Offset> offsetPoints = List();
  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = Offset.zero & size;
    final Size imageSize = new Size(image.width.toDouble(), image.height.toDouble());
    FittedSizes  sizes = applyBoxFit(BoxFit.fitWidth, imageSize, size);
    final Rect inputSubrect = Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubRect = Alignment.center.inscribe(sizes.destination, rect);
    canvas.drawImageRect(image, inputSubrect, outputSubRect, Paint());

    if(pointList != null){
      for(int i=0; i<pointList.length -1; i++){
        if(pointList[i] != null && pointList[i+1] != null){
          canvas.drawLine(pointList[i].points, pointList[i+1].points, pointList[i].paint);
        }else if(pointList[i] != null && pointList[i+1] == null){
          offsetPoints.clear();
          offsetPoints.add(pointList[i].points);
          offsetPoints.add(Offset(
            pointList[i].points.dx + 1,
            pointList[i].points.dy + 1
          ));
          canvas.drawPoints(ui.PointMode.polygon, offsetPoints, pointList[i].paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}
