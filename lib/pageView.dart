import 'package:flutter/material.dart';

class PagesView extends StatefulWidget {
  @override
  _PagesViewState createState() => _PagesViewState();
}

class _PagesViewState extends State<PagesView> {
  final controller = PageController(
    initialPage: 1,
    keepPage: true,
    viewportFraction: 12.0
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(itemBuilder: null)
    );
  }
}

class WidgetOne extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text('Page 1'),),);
  }
}

class WidgetTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(child: Center(child: Text('page 2'),),);
  }
}


