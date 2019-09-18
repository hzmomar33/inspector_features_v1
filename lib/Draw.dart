import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:inspector_v1/Gallery.dart';
import 'package:path_provider/path_provider.dart';
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
  Offset offsetCircle;
  bool showBottomList = false;
  double opacity = 1.0;
  StrokeCap strokeCap = (Platform.isAndroid) ? StrokeCap.butt : StrokeCap.round;
  SelectedMode selectedMode = SelectedMode.StrokeWidth;
  double _sliderValue = 0;

  ui.Image bckImage;
  ui.Image stickerImage;
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
    _loadAssetImage();
  }


  @override
  Widget build(BuildContext context) {
    onChangeSlider(double value){
      setState(() {
        _sliderValue = value;
      });
    }

    List<String> capturedImage = widget.capturedImage;
    return (bckImage != null ) && (stickerImage != null) ?  Scaffold(
      backgroundColor: Colors.white,
//      bottomNavigationBar: Padding(
//        padding: const EdgeInsets.all(5.0),
//        child: Container(
//          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//          decoration: BoxDecoration(
//            borderRadius: BorderRadius.circular(15.0),
//            color: Colors.greenAccent
//          ),
//          child: Padding(
//            padding: const EdgeInsets.all(8.0),
//            child: Column(
//              mainAxisSize: MainAxisSize.min,
//              children: <Widget>[
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//                    IconButton(
//                      icon: Icon(Icons.album,),
//                      onPressed: (){
//                        setState(() {
//                          if(selectedMode == SelectedMode.StrokeWidth){
//                            showBottomList = !showBottomList;
//                          }
//                          selectedMode = SelectedMode.StrokeWidth;
//                        });
//                      },
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.opacity),
//                      onPressed: (){
//                        setState(() {
//                          if(selectedMode == SelectedMode.Opacity){
//                            showBottomList = !showBottomList;
//                          }
//                          selectedMode = SelectedMode.Opacity;
//                        });
//                      },
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.color_lens),
//                      onPressed: (){
//                        setState(() {
//                          if(selectedMode == SelectedMode.Color){
//                            showBottomList = !showBottomList;
//                          }
//                          selectedMode = SelectedMode.Color;
//                        });
//                      },
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.clear),
//                      onPressed: (){
//                        setState(() {
//                          offsetCircle = null;
//                          showBottomList = false;
//                          points.clear();
//                        });
//                      },
//                    ),
//                    IconButton(
//                      icon: Icon(Icons.save_alt),
//                      onPressed: () async{
//                        getImage();
//                      },
//                    )
//                  ],
//                ),
//                Visibility(
//                  child: (selectedMode == SelectedMode.Color)
//                    ? Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: getColorList(),
//                  ) : Slider(
//                    value: (selectedMode == SelectedMode.StrokeWidth) ? strokeWidth : opacity,
//                    max: (selectedMode == SelectedMode.StrokeWidth) ? 50.0 : 1.0,
//                    min: 0.0,
//                    onChanged: (val) {
//                      setState(() {
//                      if(selectedMode == SelectedMode.StrokeWidth){
//                      strokeWidth = val;
//                      }else{
//                      opacity = val;
//                      }
//                      });
//                    }),
//                  visible: showBottomList,
//                )
//              ],
//            ),
//          ),
//        ),
//      ),
      body: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            RenderBox renderBox = context.findRenderObject();
            offsetCircle = renderBox.globalToLocal(details.globalPosition);
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
//            RenderBox renderbox = context.findRenderObject();
//            offsetCircle = renderbox.globalToLocal(details.globalPosition);
//            points.add(DrawingPoints(
//              points: renderbox.globalToLocal(details.globalPosition),
//              paint: Paint()
//                ..strokeCap = strokeCap
//                ..isAntiAlias = true
//                ..color = selectedColor.withOpacity(opacity)
//                ..strokeWidth = strokeWidth
//            ));
          });
        },
        onPanEnd: (details) {
          setState(() {
            points.add(null);
          });
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width.toDouble(),
              height: MediaQuery.of(context).size.height.toDouble(),
              child: Center(
                child: RaisedButton(
                  onPressed: (){
                    getImage();
                  },
                  child: Text('Save'),
                ),
              ),
            ),
            painter: DrawingPainter(pointsList: points, image: bckImage, stickerImage: stickerImage, offsetCircle: offsetCircle, saveImage: false, sliderVal: _sliderValue)
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        width: MediaQuery.of(context).size.width,
        height: 100.0,
        child: Slider(
          min: 0,
          max: 1000,
          inactiveColor: Colors.black,
          value: _sliderValue,
          onChanged: onChangeSlider,
        ),
      )
    ) :
        Container(child: Center(child: CircularProgressIndicator(),),);
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
    
    DrawingPainter _painter = DrawingPainter(pointsList: points, image: bckImage, stickerImage: stickerImage, offsetCircle: offsetCircle, saveImage: true, screenHeight: MediaQuery.of(context).size.height, screenWidth: MediaQuery.of(context).size.width, sliderVal: _sliderValue);

    _painter.paint(Canvas(recorder), Size(bckImage.width.toDouble(), bckImage.height.toDouble()));

    final Size imageSize = new Size(bckImage.width.toDouble(), bckImage.height.toDouble());
    FittedSizes sizes = applyBoxFit(BoxFit.scaleDown, imageSize, Size(bckImage.width.toDouble(), bckImage.height.toDouble()));

    ui.Image _image =  await recorder.endRecording().toImage(bckImage.width, bckImage.height);
    ByteData data = await _image.toByteData(
      format: ui.ImageByteFormat.png
    );
    //TODO- save as file / external file / album
    Directory dir = await getApplicationDocumentsDirectory();
    String filePath = '${dir.path}/Pictures';
    await Directory(filePath).create(recursive: true);
    final String path = '$filePath/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';
    File(path).writeAsBytesSync(data.buffer.asUint8List());
    Navigator.push(context, MaterialPageRoute(builder: (context){ return Gallery(image: path,);}));
//    showDialog(context: context,
//    builder: (context) {
//      return AlertDialog(
//        content: Image.memory(Uint8List.view(data.buffer)),
//      );
//    });


  }

  void _loadImage(File file) async {
    final data = await file.readAsBytes();
    ui.Image _images  =  await decodeImageFromList(data);
    setState(() {
      bckImage = _images;
    });
  }

  void _loadAssetImage() async{
    File file = await getImageFileFromAssets('user-male.png');
    final data = await file.readAsBytes();
    ui.Image _images = await decodeImageFromList(data);
    setState(() {
      stickerImage = _images;
    });
  }

  Future<File> getImageFileFromAssets(String path) async {
    final byteData = await rootBundle.load('lib/assets/$path');
    final file = File('${(await getTemporaryDirectory()).path}/$path');
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }
}

class DrawingPainter extends CustomPainter {
  DrawingPainter({this.pointsList, this.image, this.stickerImage, this.offsetCircle, this.saveImage, this.screenWidth, this.screenHeight, this.sliderVal});
  double screenWidth;
  double screenHeight;
  List<DrawingPoints> pointsList;
  double sliderVal;
  Offset offsetCircle;
  ui.Image image;
  ui.Image stickerImage;
  bool saveImage;
  List<Offset> offsetPoints = List();
  @override
  void paint(Canvas canvas, Size size) {

    final Rect rect = Offset.zero & size;
    final Size imageSize = new Size(image.width.toDouble(), image.height.toDouble());
    FittedSizes sizes = applyBoxFit(BoxFit.scaleDown, imageSize, size);
    final Rect inputSubrect = Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect = Alignment.center.inscribe(sizes.destination , rect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect , Paint());
//    if(offsetCircle != null){
//      if(saveImage){
//        double mtpWidth = image.width / screenWidth;
//        double mtpHeight = image.height / screenHeight;
//        Offset _newOffset = Offset((offsetCircle.dx * mtpWidth), (offsetCircle.dy * mtpHeight));
//        double _newRadius = ((image.width) / (screenWidth)) * 50;
//        canvas.drawCircle(_newOffset, _newRadius , Paint());
//      }else{
//        canvas.drawCircle(offsetCircle, 50 , Paint());
//      }
//    }

    if(stickerImage != null){
      if(saveImage){
        double mtpWidth = image.width / screenWidth;
        double mtpHeight = image.height/ screenHeight;
        print(mtpHeight);
        Size stickerSize = Size(stickerImage.width.toDouble(), stickerImage.height.toDouble());
        if(offsetCircle != null){
          Offset _newDragOffset = Offset(offsetCircle.dx - (stickerSize.width / 2), offsetCircle.dy - (stickerSize.height/2));
          Offset _newOffset = Offset((_newDragOffset.dx * mtpWidth), (_newDragOffset.dy * mtpHeight));
          canvas.drawImageNine(stickerImage, Offset.zero & stickerSize, _newOffset & Size(mtpWidth * 150, mtpHeight * 150), Paint());
        }
      }else{
        Size stickerSize = Size(stickerImage.width.toDouble(), stickerImage.height.toDouble());
        if(offsetCircle != null && sliderVal != null){
          Offset _newDragOffset = Offset(offsetCircle.dx - (stickerImage.width / 2), offsetCircle.dy - (stickerImage.height/2));
          canvas.drawImageNine(stickerImage, Offset.zero & stickerSize, _newDragOffset & Size(150 ,150), Paint());
        }
//        canvas.drawImage(stickerImage, offsetCircle, Paint());
      }
    }

//    for(int i=0; i<pointsList.length -1; i++){
//      if(pointsList[i] != null && pointsList[i + 1] != null){
//        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points, pointsList[i].paint );
//      }else if(pointsList[i] != null && pointsList[i + 1] == null){
//        offsetPoints.clear();
//        offsetPoints.add(pointsList[i].points);
//        offsetPoints.add(Offset(
//          pointsList[i].points.dx + 0.1,
//          pointsList[i].points.dy + 0.1
//        ));
//        canvas.drawPoints(ui.PointMode.points, offsetPoints, pointsList[i].paint);
//      }
//    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

}

enum SelectedMode {StrokeWidth,Opacity, Color}
