import 'package:flutter/material.dart';

class ImageProcessing{

  static Future<String> getImages() async{
    print('waiting processing');
    await Future.delayed(Duration(seconds: 5));
    print('processing');
    return 's';
  }

}