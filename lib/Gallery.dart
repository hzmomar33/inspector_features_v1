import 'dart:io';

import 'package:flutter/material.dart';

class Gallery extends StatelessWidget {
  final String image;
  Gallery({Key key, this.image}): super(key:key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
            child: Image.file(File(image),fit: BoxFit.fitWidth,)
        ),
      ),
    );

  }
}
