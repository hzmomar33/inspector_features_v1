import 'package:flutter/material.dart';

class Gallery extends StatelessWidget {
  final String image;
  Gallery({Key key, this.image}): super(key:key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30.0, left: 0, right: 0),
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: 100,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.transparent,
                        elevation: 0.0,
                        splashColor: Colors.blueAccent,
                        onPressed: (){Navigator.pop(context);},
                        child: Icon(Icons.clear, color: Colors.white,),
                        shape: CircleBorder(),
                      ),
                      RaisedButton(
                        color: Colors.transparent,
                        elevation: 0.0,
                        splashColor: Colors.blueAccent,
                        onPressed: (){},
                        child: Icon(Icons.edit, color: Colors.white,),
                        shape: CircleBorder(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}
