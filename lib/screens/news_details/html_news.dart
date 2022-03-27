import 'package:news/widgets/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

class HTMLNews extends StatelessWidget {
  String htmlData;
  String news_image;
  String newsTitle;
  String newsSource;
  String newsTime;
  String newsUrl;
  HTMLNews(
      {required this.htmlData,
      required this.newsTitle,
      required this.newsUrl,
      required this.news_image,
      required this.newsSource,
      required this.newsTime});

  final controller = ScrollController();

  void _launchURL() async => await canLaunch(newsUrl)
      ? await launch(newsUrl)
      : throw 'Could not launch $newsUrl';

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    Widget html = Html(
      data: htmlData,
    );
    return Scaffold(
        appBar: ScrollAppBar(
          controller: controller,
          backgroundColor: Colors.blue[900],
          title: heading(
              text: newsTitle, color: Colors.white, scale: 0.8, maxLines: 1),
        ),
        body: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              SizedBox(height: height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: heading(
                    text: newsTitle,
                    scale: 1.5,
                    align: TextAlign.left,
                    weight: FontWeight.w700),
              ),
              SizedBox(height: height * 0.01),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    heading(text: newsSource, weight: FontWeight.w400),
                    heading(text: " | "),
                    heading(text: newsTime, color: Colors.blue),
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                child: html,
              ),
              SizedBox(height: height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      _launchURL();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blue),
                          color: Colors.white),
                      child: Center(
                          child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: heading(
                            text: "वेबसाइट पर न्यूज़ पढें", color: Colors.blue),
                      )),
                    ),
                  )
                ],
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ));
  }
}
