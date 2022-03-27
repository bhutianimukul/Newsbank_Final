import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clippy_flutter/clippy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/news_details/html_news.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/widgets/styles.dart';
import 'package:path_provider/path_provider.dart';

///
///
///
///
///Not being used anywhere, this was changed to anyaRajya for the new implementation of the said screen
///
///
///
///
///
class AneyRajye extends StatefulWidget {
  AneyRajye(this.scrollController);
  final ScrollController scrollController;
  @override
  _AneyRajyeState createState() => _AneyRajyeState();
}

class _AneyRajyeState extends State<AneyRajye> {
  var homeNewsData;
  Future<void> getHomeNews() async {
    //Get from cache
    // String fileName = 'getHomeNews.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      setState(() {
        homeNewsData = res;
      });
    } else {
      print("reading from internet");
      final url =
          "https://ingnewsbank.com/api/home_latest_news?take=5&st_id=$hi";

      final req = await http.get(Uri.parse(url));

      if (req.statusCode == 200) {
        final body = req.body;

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        final res = jsonDecode(body);
        setState(() {
          homeNewsData = res;
          print("aaaaa");
        });
      } else {
        setState(() {
          homeNewsData = jsonDecode(req.body);
          print("zzzzzz");
        });
      }
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        String fileName = 'getHomeNews.json';
        var dir = await getTemporaryDirectory();

        File file = File(dir.path + "/" + fileName);
        print("reading from internet");
        final url =
            "https://ingnewsbank.com/api/home_latest_news?take=5&st_id=$hi";
        final req = await http.get(Uri.parse(url));

        if (req.statusCode == 200) {
          final body = req.body;

          file.writeAsStringSync(body, flush: true, mode: FileMode.write);
          final res = jsonDecode(body);
          setState(() {
            List x = [];
            x.add(res[0]);
            var gotr = x;
            homeNewsData = gotr;
            print(homeNewsData.length);
            print("yyyyyy");
          });
        } else {
          setState(() {
            homeNewsData = jsonDecode(req.body);
            print("xxxxxx");
          });
        }
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  String hi = "";
  var homeNewsDatas = [];
  int done = 0;
  Future<void> getInfo() async {
    getData().then((String value) {
      setState(() {
        int c = 0;
        for (int i = 1; i <= 8; i++) {
          if (i.toString() != value) {
            c++;
            hi = value;
            getHomeNews();

            print("x");
            if (c == 1) {
              homeNewsDatas = homeNewsData;
              print(homeNewsDatas.toString());
            } else {
              homeNewsDatas.add(homeNewsData);
              print(homeNewsDatas.toString());
            }
            print(" HHH");
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }

// void dispose(){
//    homeNewsData="";
//     super.dispose();
//   }
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    ScrollController sc = new ScrollController();
    if (sc.hasClients)
      sc.animateTo(sc.position.maxScrollExtent,
          duration: Duration(milliseconds: 100000), curve: Curves.linear);
    return RefreshIndicator(
      onRefresh: () => getInfo(),
      child: ListView(
        controller: widget.scrollController,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        children: [
          SizedBox(height: 10),
          if (homeNewsDatas == null)
            Center(child: CircularProgressIndicator())
          else
            ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: homeNewsDatas.length,
                itemBuilder: (context, int index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Transform(
                        transform: Matrix4.translationValues(0.0, 1, 0.0),
                        child: Container(
                            height: 5,
                            width: width,
                            color: dark == 0
                                ? hexColor(
                                    homeNewsDatas[index]["category"]
                                            ["bg_color_code"]
                                        .substring(1, 7),
                                  )
                                : Colors.white),
                      ),
                      Container(
                        height: 30,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 90),
                                        child: heading(
                                            text: homeNewsDatas[index]
                                                ["category"]["title"],
                                            color: dark == 0
                                                ? hexColor(homeNewsDatas[index]
                                                            ["category"]
                                                        ["text_color_code"]
                                                    .substring(1, 7))
                                                : Colors.black,
                                            weight: FontWeight.w800,
                                            scale: 1.1),
                                      ),
                                    ),
                                    width: width * 0.5,
                                    height: 30,
                                    color: dark == 0
                                        ? hexColor(homeNewsDatas[index]
                                                ["category"]["bg_color_code"]
                                            .substring(1, 7))
                                        : Colors.white),
                                Transform(
                                  transform:
                                      Matrix4.translationValues(-1, 0, 0.0),
                                  child: Diagonal(
                                    child: Container(
                                      width: 50,
                                      height: 32,
                                      color: dark == 0
                                          ? hexColor(homeNewsDatas[index]
                                                  ["category"]["bg_color_code"]
                                              .substring(1, 7))
                                          : Colors.white,
                                    ),
                                    clipHeight: 40,
                                    position: DiagonalPosition.BOTTOM_LEFT,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: heading(
                                  scale: 0.9,
                                  text: "और देखें",
                                  color: dark == 0
                                      ? Colors.blue[900]!
                                      : Colors.white,
                                  weight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: homeNewsDatas[index]["news"].length,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, int index2) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 5, top: 5, bottom: 2),
                              child: GestureDetector(
                                onTap: () {
                                  if (homeNewsDatas[index]["news"][index2]
                                          ["is_open_in_web_view"] ==
                                      0) {
                                    final dataNews = {
                                      "newsTitle": homeNewsDatas[index]["news"]
                                          [index2]["title"],
                                      "newsURL": homeNewsDatas[index]["news"]
                                          [index2]["imported_news_url"],
                                      "data": homeNewsDatas[index]["news"]
                                          [index2],
                                    };
                                    Get.to(WebviewScreen(),
                                        arguments: dataNews);
                                  }
                                  // Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => WebviewScreen(
                                  //               newsTitle:
                                  //                   homeNewsDatas[index]
                                  //                           ["news"][index2]
                                  //                       ["title"],
                                  //               newsURL: homeNewsDatas[index]
                                  //                       ["news"][index2]
                                  //                   ["imported_news_url"], data: homeNewsDatas[index]["news"][index2],
                                  //             )));
                                  else {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HTMLNews(
                                                  newsUrl: homeNewsDatas[index]
                                                          ["news"][index2]
                                                      ["imported_news_url"],
                                                  news_image:
                                                      homeNewsDatas[index]
                                                              ["news"][index2]
                                                          ["main_image"],
                                                  newsSource:
                                                      homeNewsDatas[index]
                                                              ["news"][index2]
                                                          ["source_website"],
                                                  newsTime: homeNewsDatas[index]
                                                          ["news"][index2]
                                                      ["imported_date"],
                                                  newsTitle:
                                                      homeNewsDatas[index]
                                                              ["news"][index2]
                                                          ["title"],
                                                  htmlData: homeNewsDatas[index]
                                                      ["news"][index2]["body"],
                                                )));
                                  }
                                },
                                child: Container(
                                  height: 80,
                                  //height * 0.10,
                                  width: width,
                                  decoration: BoxDecoration(
                                      color: Colors.green[50],
                                      borderRadius: BorderRadius.circular(5),
                                      boxShadow: [
                                        BoxShadow(
                                            offset: Offset(3, 3),
                                            color: Colors.black12,
                                            spreadRadius: 0.05)
                                      ]),
                                  child: Row(
                                    children: [
                                      homeNewsDatas[index]["news"][index2]
                                                  ["main_image_thumb"] ==
                                              null
                                          ? SizedBox()
                                          : Container(
                                              height: height * 0.18,
                                              width: width * 0.4,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: CachedNetworkImageProvider(
                                                          homeNewsDatas[index]
                                                                      ["news"]
                                                                  [index2][
                                                              "main_image_thumb"]),
                                                      fit: BoxFit.cover)),
                                            ),
                                      SizedBox(width: 2),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              AutoSizeText(
                                                homeNewsDatas[index]["news"]
                                                    [index2]["title"],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textScaleFactor: 1.0,
                                                maxLines: 3,
                                                minFontSize: 15,
                                                maxFontSize: 29,
                                              ),
                                              // heading(
                                              //     text: homeNewsData[index]
                                              //         ["news"][index2]["title"],
                                              //     maxLines: 3,
                                              //     scale: 1.25,
                                              //     weight: FontWeight.w800,
                                              //     align: TextAlign.left),

                                              Flexible(
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      child: new Container(
                                                          padding:
                                                              new EdgeInsets
                                                                      .only(
                                                                  right: 13.0),
                                                          child: RichText(
                                                            textScaleFactor:
                                                                1.0,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            text: TextSpan(
                                                              text: homeNewsDatas[
                                                                          index]
                                                                      [
                                                                      "news"][index2]
                                                                  [
                                                                  "source_website"],
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors
                                                                      .black54),
                                                              children: <
                                                                  TextSpan>[
                                                                TextSpan(
                                                                    text: ' | ',
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                                TextSpan(
                                                                    text: homeNewsDatas[index]["news"][index2]
                                                                            [
                                                                            "imported_date"]
                                                                        .toString(),
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue))
                                                              ],
                                                            ),
                                                          )),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        FlutterShare.share(
                                                            title: "Title",
                                                            text: homeNewsDatas[
                                                                            index]
                                                                        ["news"]
                                                                    [index2]
                                                                ["title"],
                                                            chooserTitle:
                                                                "इस खबर को शेयर करो...");
                                                      },
                                                      child: Icon(
                                                        Icons.share,
                                                        size: height * 0.02,
                                                        color: Colors.red,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }),
                    ],
                  );
                }),
        ],
      ),
    );
  }
}
