import 'package:flutter/material.dart';

class CapturedImage extends ChangeNotifier {
  List<String> _images = ['/data/user/0/com.carsome.inspector_v1/app_flutter/Pictures/inspector/1567498844738.jpg'];

  List get images => _images;

  set images(List _a){
    _images = _a;
    notifyListeners();
  }
  removeImage(int index){
    _images.removeAt(index);
    notifyListeners();
  }

  addImage(String i){
    _images.insert(0, i);
    notifyListeners();
  }

}