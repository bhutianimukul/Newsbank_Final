import 'package:flutter/material.dart';

Text heading(
    {String text = "",
    Color color = Colors.black,
    int maxLines = 5,
    TextDecoration textDecoration = TextDecoration.none,
    FontWeight weight = FontWeight.w400,
    TextAlign align = TextAlign.center,
    double scale = 1}) {
  return Text("$text",
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      maxLines: maxLines,
      textScaleFactor: scale,
      style: TextStyle(
          decoration: textDecoration, color: color, fontWeight: weight));
}

PageController controller = PageController(
  initialPage: 0,
);

Widget button1(Widget child, double radius,
    {Color color = Colors.blueAccent, Color borColor = Colors.transparent}) {
  return Container(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: child,
    ),
    decoration: BoxDecoration(
        border: Border.all(color: borColor, width: 0.8),
        borderRadius: BorderRadius.circular(radius),
        color: color),
  );
}

Widget hPadding({required Widget child}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 15),
    child: child,
  );
}

Color hexColor(String color) {
  int c = int.parse("0xff$color");
  return Color(c);
}

Widget aimage(String name, {double scale = 1}) {
  return Image.asset(
    "images/$name.png",
    scale: scale,
  );
}

// var mq = MediaQuery.of(context).size;
// var height = mq.height;
// var width = mq.width;
