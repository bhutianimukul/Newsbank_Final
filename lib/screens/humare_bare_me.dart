import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class HumareBareMe extends StatelessWidget {
  final String? text;
  HumareBareMe({required this.text});

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
        title: Text('हमारे बारे में'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Html(
            data: text.toString(),
            defaultTextStyle: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
