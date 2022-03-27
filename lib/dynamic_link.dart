// ignore_for_file: unused_local_variable
import 'dart:convert';

import 'package:get/get.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/home_screen/search_screen.dart';
import 'package:news/screens/news_details/webiew.dart';

Future<String> generateUrl(data) async {
  //print(data);
  final tempData = data as Map;

  List<String> splittedUrl = data['newsURL'].split('/');
  print(splittedUrl);

  print("dddddddddddddddddddddddddddddddddddd");
  print(tempData['data']['main_image']);
  //print(data['data']['main_image']);
  // Uri image = Uri.parse(data["data"]["main_image"].toString());
  // print(Uri.parse(data["data"]["main_image"].toString()));
  print("helllo" + tempData.toString());
  if (!readNews.contains(data['newsTitle'])) readNews.add(data['newsTitle']);
  final parameters = DynamicLinkParameters(
    uriPrefix: "https://ingnnewsbank.page.link",
    navigationInfoParameters:
        NavigationInfoParameters(forcedRedirectEnabled: false),
    link: Uri.parse(
        "https://ingnnewsbank.page.link?link=${data['newsURL']}&newsTitle=${data['newsTitle']}"),

    //  link: Uri.parse("https://www.google.com/news?data=${jsonEncode(data)}"),
    androidParameters: AndroidParameters(packageName: "com.newsbank.app"),
    // socialMetaTagParameters: SocialMetaTagParameters(
    //   title: data['newsTitle'],
    //   imageUrl: tempData['data']['main_image'] == null
    //       ? Uri.parse(
    //           'https://www.ingnewsbank.com/public/front/images/logo.jpg')
    //       : Uri.parse(data["data"]["main_image"].toString()),
    //   description: splittedUrl[2].toString(),
    // ),
  );

  // final dynamicUrl = await parameters.buildUrl();

  // final shortLink = await parameters.buildShortLink();
  // final shortUrl = shortLink.shortUrl;
  // print("ShortUrl      " + shortUrl.toString());
  // print("ShortUrl path      " + shortUrl.path);

  // return shortUrl.toString();
  final Uri dynamicUrl = await parameters.buildUrl();
  final ShortDynamicLink shortenedLink = await DynamicLinkParameters.shortenUrl(
    dynamicUrl,
    DynamicLinkParametersOptions(
        shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
  );
  final Uri shortUrl = shortenedLink.shortUrl;
  return "https://ingnnewsbank.page.link" + shortUrl.path;
}

Future<void> startDynamicLink() async {
  print("INSIDEEEEEEE");
  await Future.delayed(Duration(seconds: 3));
  var data = await FirebaseDynamicLinks.instance.getInitialLink();
  var deepLink = data.link;

  final url = deepLink.queryParameters['link'];
  final newsTitle = deepLink.queryParameters['newsTitle'];
  final query = {
    'newsURL': url,
    'data': {"imported_news_url": url},
    "newsTitle": newsTitle
  };
  print(query);

  Get.to(WebviewScreen(), arguments: query);
}

Future<void> initDynamicLink() async {
  print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSMukulbhhhhhhhhh");
  // await Future.delayed(Duration(seconds: 3));
  // final data = await FirebaseDynamicLinks.instance.getInitialLink();

  // final deepLink = data.link;

  // print("PaTHHHHH" + deepLink.path);
  // final queryParams = deepLink.queryParameters;
  // // printing query parameter if exist
  // print("INSIDEEEEEEE");
  // await Future.delayed(Duration(seconds: 3));
  // var data = await FirebaseDynamicLinks.instance.getInitialLink();
  // var deepLink = data.link;

  // final query = deepLink.queryParameters['data'];
  // print(query.toString());

  // Get.to(WebviewScreen(), arguments: jsonDecode(query.toString()));
  FirebaseDynamicLinks.instance.onLink(onSuccess: (linkData) async {
    var deepLink = linkData.link;
    print(deepLink.path);
    // final data = deepLink.queryParameters['data'];
    // print("giffj" + data.toString());
    final url = deepLink.queryParameters['link'];
    if (url != null) {
      final newsTitle = deepLink.queryParameters['newsTitle'];
      final query = {
        'newsURL': url,
        'data': {"imported_news_url": url},
        "newsTitle": newsTitle
      };
      Get.to(WebviewScreen(), arguments: query);
      print("Doneeee");
    }
    // final newsTitle = deepLink.queryParameters['newsTitle'];
    // final newsURL = deepLink.queryParameters['newsURL'];

    // final data = Adata as Map;

    //print("dataeeeeeeeee" + data.toString());

    // print("ddddddddddddddddddddddddddddddddddddddddddd");
    try {
      //  print(jsonDecode(data.toString()));
    } catch (er) {
      print(er);
    }
    //   print("ddddddddddddddddddddddddddddddddddddddddddd");
    // print(" fffffffffffffffffffffffffff" + newData);
    // print(jsonDecode(data.toString()));
    // Get.to(WebviewScreen(), arguments: query);

    //   Get.to(SearchScreen());
    // Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => WebviewScreen(
    //         newsTitle: data['newsTitle'],
    //         newsURL: data["newsUrl"],
    //         data: data,
    //       ),
    //     ));
    debugPrint('DYnamic Links onLink $deepLink');
  }, onError: (e) async {
    debugPrint('DYnamic Links error $e');
  });
}
