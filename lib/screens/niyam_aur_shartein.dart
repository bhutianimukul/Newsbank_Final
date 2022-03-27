import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart';

class NiyamShartein extends StatelessWidget {
  final String text;

  NiyamShartein({required this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('नियम और शर्तें'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Html(
            data: text,
            defaultTextStyle: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
