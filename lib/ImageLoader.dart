//import 'dart:async';
//import 'dart:ui' as flutterui;
//
//import 'package:flutter/rendering.dart' as ui;
//import 'package:flutter/services.dart' as ui;
//import 'package:flutter/widgets.dart' as ui;
//import 'package:flutter/material.dart' as ui;
//import 'package:flutter/painting.dart' as ui;
//
//class ImageLoader {
//  static ui.AssetBundle getAssetBundle() => (ui.rootBundle != null)
//      ? ui.rootBundle
//      : new ui.NetworkAssetBundle(new Uri.directory(Uri.base.origin));
//
//  static Future<flutterui.Image> load(String url) async {
//    ui.ImageStream stream = new ui.AssetImage(url, bundle: getAssetBundle())
//        .resolve(ui.ImageConfiguration.empty);
//    Completer<flutterui.Image> completer = new Completer<flutterui.Image>();
//    void listener(ui.ImageInfo frame, bool synchronousCall) {
//      final flutterui.Image image = frame.image;
//      completer.complete(image);
//      stream.removeListener(listener);
//    }
//
//    stream.addListener(listener);
//    return completer.future;
//  }
//}