import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:news/dynamic_link.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/news_details/html_news.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/widgets/styles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

class TrendingNews extends StatefulWidget {
  final int tId;
  TrendingNews(this.tId);

  @override
  _TrendingNewsState createState() => _TrendingNewsState();
}

class _TrendingNewsState extends State<TrendingNews> {
  static int skip = 1;
  static int take = 40;
  ScrollController sc = ScrollController();
  bool isLoading = false;
  List tData = [];

  Future<dynamic> getData() async {
    setState(() {
      skip = 1;
      take = 40;
    });

//tid     china

//file
//dir
//file read
//data
//empty tid fetch
//empty not  data[tid]?read: fetch url
    String fileName = 'getTrendingNewsData${widget.tId.toString()}.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    print("get data");
    if (file.existsSync()) {
      // print("reading from cache");
      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      setState(() {
        tData.clear();
        tData.addAll(res);
      });
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("internet");
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          var request = http.Request(
              'GET',
              Uri.parse(
                  'https://ingnewsbank.com/api/get_latest_news_by_tags?skip=0&take=$take&t_id=${widget.tId.toString()}'));

          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            final body = await response.stream.bytesToString();

            final res = jsonDecode(body);
            setState(() {
              tData.clear();
              tData.addAll(res["news"]);
              file.writeAsStringSync(jsonEncode(tData),
                  flush: true, mode: FileMode.write);

              isLoading = false;
            });
          } else {
            if (file.existsSync()) {
              print("reading from cache");
              final data = file.readAsStringSync();
              final res = jsonDecode(data);
              if (res.length != 0) {
                tData.clear();
                tData.addAll(res);
              } else {
                tData = [];
                setState(() {
                  isLoading = false;
                  Toast.show("आपका इंटरनेट बंद है |", context);
                });
              }
              setState(() {
                isLoading = false;
                Toast.show("आपका इंटरनेट बंद है |", context);
              });
            }
          }
        }
      }
    } on SocketException catch (_) {
      print("In GetData");
      if (file.existsSync()) {
        print("reading from cache");
        final data = file.readAsStringSync();
        final res = jsonDecode(data);
        if (res.length != 0) {
          tData.addAll(res);
        } else {
          tData = [];
          setState(() {
            isLoading = false;
            Toast.show("आपका इंटरनेट बंद है |", context);
          });
        }
      }
    }
  }

  Future<void> getMoreData() async {
    print("get more data $skip");
    String fileName = 'getTrendingNewsData${widget.tId.toString()}.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });

          var request = http.Request(
              'GET',
              Uri.parse(
                  'https://ingnewsbank.com/api/get_latest_news_by_tags?skip=$skip&take=$take&t_id=${widget.tId.toString()}'));

          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            final body = await response.stream.bytesToString();

            final res = jsonDecode(body);
            print(body);
            setState(() {
              tData.addAll(res["news"]);
              file.writeAsStringSync(jsonEncode(tData),
                  flush: true, mode: FileMode.write);

              isLoading = false;
              skip = skip + 1;
              // take = take + 25;
            });
          } else {}
        }
      }
    } on SocketException catch (_) {
      print("InSide GetMore Data");
      setState(() {
        isLoading = false;
        Toast.show("आपका इंटरनेट बंद है |", context);
      });
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 55.0, top: 10),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new Container(),
        ),
      ),
    );
  }

  @override
  void initState() {
    print('tt id is ${widget.tId}');
    super.initState();
    getData().then((value) {
      setState(() {});
    });

    sc.addListener(() {
      if (sc.position.pixels >
              sc.position.maxScrollExtent / 1.100000000000000001 &&
          sc.position.pixels <= sc.position.maxScrollExtent) {
        // skip = skip + 1;
        print('more data coming');
        getMoreData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    return tData == null
        ? Center(child: Container())
        : Container(
            color: dark == 1 ? Colors.black : Colors.white,
            child: RefreshIndicator(
              onRefresh: () async {
                await getData();
                setState(() {});
              },
              child: ListView.builder(
                  itemCount: tData.length,
                  controller: sc,
                  itemBuilder: (context, int index) {
                    return index == tData.length
                        ? _buildProgressIndicator()
                        : Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 3, horizontal: 2),
                            child: GestureDetector(
                              onTap: () {
                                if (tData[index]["is_open_in_web_view"] == 0) {
                                  final dataNews = {
                                    "newsTitle": tData[index]["title"],
                                    "newsURL": tData[index]
                                        ["imported_news_url"],
                                    "data": tData[index]
                                  };
                                  Get.to(WebviewScreen(), arguments: dataNews)!
                                      .then((c) async {
                                    final fileName = "readNews.json";
                                    var dir = await getTemporaryDirectory();
                                    File file = File(dir.path + "/" + fileName);
                                    setState(() {
                                      readNews.add(tData[index]["title"]);
                                      file.writeAsStringSync(
                                          jsonEncode(readNews),
                                          flush: true,
                                          mode: FileMode.write);
                                    });
                                  });
                                  ;
                                }

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => WebviewScreen(
                                //       newsTitle: tData[index]["title"],
                                //       newsURL: tData[index]
                                //           ["imported_news_url"],
                                //       data: tData[index],
                                //     ),
                                //   ),
                                // ).then((c) async {
                                //   final fileName = "readNews.json";
                                //   var dir = await getTemporaryDirectory();
                                //   File file = File(dir.path + "/" + fileName);
                                //   setState(() {
                                //     readNews.add(tData[index]["title"]);
                                //     file.writeAsStringSync(
                                //         jsonEncode(readNews),
                                //         flush: true,
                                //         mode: FileMode.write);
                                //   });
                                // });
                                else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HTMLNews(
                                        newsUrl: tData[index]
                                            ["imported_news_url"],
                                        news_image: tData[index]["main_image"],
                                        newsSource: tData[index]
                                            ["source_website"],
                                        newsTime: tData[index]["imported_date"],
                                        newsTitle: tData[index]["title"],
                                        htmlData: tData[index]["body"],
                                      ),
                                    ),
                                  ).then((c) async {
                                    final fileName = "readNews.json";
                                    var dir = await getTemporaryDirectory();
                                    File file = File(dir.path + "/" + fileName);
                                    setState(() {
                                      readNews.add(tData[index]["title"]);
                                      file.writeAsStringSync(
                                          jsonEncode(readNews),
                                          flush: true,
                                          mode: FileMode.write);
                                    });
                                  });
                                }
                              },
                              child: index == 0
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: dark == 0
                                              ? Colors.green[50]
                                              : Colors.white10,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(3, 3),
                                                color: Colors.black12,
                                                spreadRadius: 0.05)
                                          ]),
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          children: [
                                            tData[index]["main_image_thumb"] ==
                                                    null
                                                ? SizedBox()
                                                : Container(
                                                    height: height * 0.25,
                                                    width: width,
                                                    decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: CachedNetworkImageProvider(
                                                                tData[index][
                                                                    "main_image_thumb"]),
                                                            fit: BoxFit.cover)),
                                                  ),
                                            SizedBox(width: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0,
                                                  left: 8.0,
                                                  right: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  readNews.contains(
                                                          tData[index]["title"])
                                                      ? AutoSizeText(
                                                          tData[index]["title"],
                                                          // widget.tId.toString(),
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: dark == 0
                                                                ? Colors.black
                                                                    .withOpacity(
                                                                        .5)
                                                                : Colors.white
                                                                    .withOpacity(
                                                                        .5),
                                                          ),
                                                          maxLines: 2,
                                                          minFontSize: 16,
                                                          maxFontSize: 30,
                                                        )
                                                      : AutoSizeText(
                                                          tData[index]["title"],
                                                          // widget.tId.toString(),
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: dark == 0
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                          maxLines: 2,
                                                          minFontSize: 16,
                                                          maxFontSize: 30,
                                                        ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          heading(
                                                              text: tData[index]
                                                                  [
                                                                  "source_website"],
                                                              scale: 0.9,
                                                              color: dark == 0
                                                                  ? Colors
                                                                      .black54
                                                                  : Colors
                                                                      .white,
                                                              weight: FontWeight
                                                                  .w300),
                                                          heading(
                                                            text: " | ",
                                                            color: dark == 0
                                                                ? Colors.black54
                                                                : Colors.white,
                                                          ),
                                                          heading(
                                                              text: tData[index]
                                                                  [
                                                                  "imported_date"],
                                                              color:
                                                                  Colors.blue,
                                                              scale: 0.9)
                                                        ],
                                                      ),
                                                      Spacer(),
                                                      GestureDetector(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                                isScrollControlled:
                                                                    true,
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (context) =>
                                                                        Padding(
                                                                          padding:
                                                                              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Container(
                                                                              color: dark != 0 ? Color(0xFF4D555F) : Colors.white,
                                                                              height: 200,
                                                                              child: Column(
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        tData[index]["title"],
                                                                                        style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 19),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: TextButton(
                                                                                      onPressed: () async {
                                                                                        //  final tempMap = homeNewsData[index]["news"][index2];

                                                                                        final tempMap = tData[index];

                                                                                        tempMap['main_image_cropped'] = '';

                                                                                        final dataNews = {
                                                                                          "newsTitle": tData[index]["title"],
                                                                                          "newsURL": tData[index]["imported_news_url"],
                                                                                          "data": tempMap
                                                                                        };
                                                                                        String url = '';
                                                                                        await generateUrl(dataNews).then((value) => {
                                                                                              url = value,
                                                                                            });
                                                                                        print('it\'s shared');
                                                                                        final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                        FlutterShare.share(title: "Title", text: title);
                                                                                        //  FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳");
                                                                                        //     FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " + tData[index]["title"], chooserTitle: "इस खबर को शेयर करो...");
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Padding(
                                                                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                              child: Icon(
                                                                                                Icons.share,
                                                                                                size: 25,
                                                                                                color: dark == 0 ? Color(0xFF4D555F) : Colors.white,
                                                                                              )),
                                                                                          Text(
                                                                                            'शेयर करें',
                                                                                            style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: TextButton(
                                                                                      onPressed: () {
                                                                                        bool alreadyThere = false;
                                                                                        for (var i = 0; i < list.items.length; i++) {
                                                                                          if (tData[index]["post_id"].toString().toString() == list.items[i].id) {
                                                                                            alreadyThere = true;
                                                                                          }
                                                                                        }

                                                                                        if (alreadyThere == false) {
                                                                                          final item = Favourite(id: tData[index]["post_id"].toString(), data: tData[index]);
                                                                                          print('2');
                                                                                          list.items.add(item);
                                                                                        }
                                                                                        storage.setItem('favourite_news', list.toJSONEncodable());
                                                                                        print('it\'s bookmarked');
                                                                                        Navigator.pop(context);
                                                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                                                          SnackBar(
                                                                                              content: Text(
                                                                                                'बुकमार्क सुरक्षित हो गया',
                                                                                                style: TextStyle(
                                                                                                  fontSize: 17,
                                                                                                  color: Colors.white,
                                                                                                ),
                                                                                              ),
                                                                                              action: SnackBarAction(
                                                                                                onPressed: () {},
                                                                                                label: 'Close',
                                                                                                textColor: Colors.white,
                                                                                              ),
                                                                                              duration: Duration(seconds: 3)),
                                                                                        );
                                                                                      },
                                                                                      child: Row(
                                                                                        children: [
                                                                                          Padding(
                                                                                              padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                              child: Icon(
                                                                                                Icons.bookmark,
                                                                                                size: 25,
                                                                                                color: dark == 0 ? Color(0xFF4D555F) : Colors.white,
                                                                                              )),
                                                                                          Text(
                                                                                            'बुकमार्क करेंं',
                                                                                            style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ));
                                                          },
                                                          child: Icon(
                                                            Icons.share,
                                                            size: 15,
                                                            color: dark == 0
                                                                ? Colors.red
                                                                : Colors.white,
                                                          )),
                                                      SizedBox(width: 10),
                                                      // DropdownButton<IconData>(
                                                      //   underline: SizedBox(),
                                                      //   icon: Icon(Icons.share,size: 15,color: Colors.red),
                                                      //   items: <IconData>[Icons.share, Icons.bookmark].map((IconData value) {
                                                      //     return DropdownMenuItem<IconData>(
                                                      //       value: value,
                                                      //       child: value==Icons.share?
                                                      //       Row(
                                                      //         children: [
                                                      //           Icon(Icons.share),
                                                      //           SizedBox(width: 20,),
                                                      //           Text('शेयर करें'),
                                                      //         ],
                                                      //       ):
                                                      //       Row(
                                                      //         children: [
                                                      //           Icon(Icons.bookmark),
                                                      //           SizedBox(width: 20,),
                                                      //           Text('बुकमार्क करें'),
                                                      //         ],
                                                      //       ),
                                                      //     );
                                                      //   }).toList(),
                                                      //   onChanged: (newValue) {
                                                      //     if((newValue)==Icons.share)
                                                      //     {
                                                      //       print('it\'s shared');
                                                      //       FlutterShare.share(
                                                      //           title: "Title",
                                                      //           text: tData[index]
                                                      //           ["title"],
                                                      //           chooserTitle:
                                                      //           "इस खबर को शेयर करो...");
                                                      //     }
                                                      //     else
                                                      //     {
                                                      //       favourites.add(P);
                                                      //       print('it\'s bookmarked');
                                                      //     }
                                                      //   },
                                                      // ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 80,
                                      decoration: BoxDecoration(
                                          color: dark == 0
                                              ? Colors.green[50]
                                              : Colors.white10,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(3, 3),
                                                color: Colors.black12,
                                                spreadRadius: 0.05)
                                          ]),
                                      child: Row(
                                        children: [
                                          tData[index]["main_image_thumb"] ==
                                                  null
                                              ? SizedBox()
                                              : Container(
                                                  height: height * 0.18,
                                                  width: width * 0.4,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: CachedNetworkImageProvider(
                                                              tData[index][
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
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  readNews.contains(
                                                          tData[index]["title"])
                                                      ? AutoSizeText(
                                                          tData[index]["title"],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: dark == 0
                                                                ? Colors.black
                                                                    .withOpacity(
                                                                        .5)
                                                                : Colors.white
                                                                    .withOpacity(
                                                                        .5),
                                                          ),
                                                          textScaleFactor: 1.0,
                                                          maxLines: 3,
                                                          minFontSize: 15,
                                                          maxFontSize: 29,
                                                        )
                                                      : AutoSizeText(
                                                          tData[index]["title"],
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: dark == 0
                                                                ? Colors.black
                                                                : Colors.white,
                                                          ),
                                                          textScaleFactor: 1.0,
                                                          maxLines: 3,
                                                          minFontSize: 15,
                                                          maxFontSize: 29,
                                                        ),
                                                  Flexible(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: new Container(
                                                              padding:
                                                                  new EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          13.0),
                                                              child: RichText(
                                                                textScaleFactor:
                                                                    1.0,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                text: TextSpan(
                                                                  text: tData[
                                                                          index]
                                                                      [
                                                                      "source_website"],
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        11,
                                                                    color: dark ==
                                                                            0
                                                                        ? Colors
                                                                            .black54
                                                                        : Colors
                                                                            .white,
                                                                  ),
                                                                  children: <
                                                                      TextSpan>[
                                                                    TextSpan(
                                                                        text:
                                                                            ' | ',
                                                                        style: TextStyle(
                                                                            color: dark == 0
                                                                                ? Colors.black
                                                                                : Colors.white,
                                                                            fontWeight: FontWeight.bold)),
                                                                    TextSpan(
                                                                        text: tData[index]["imported_date"]
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.blue))
                                                                  ],
                                                                ),
                                                              )),
                                                        ),
                                                        GestureDetector(
                                                            onTap: () {
                                                              showModalBottomSheet(
                                                                  isScrollControlled:
                                                                      true,
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) =>
                                                                          Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                            child:
                                                                                SingleChildScrollView(
                                                                              child: Container(
                                                                                color: dark != 0 ? Color(0xFF4D555F) : Colors.white,
                                                                                height: 200,
                                                                                child: Column(
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                                                                      child: Center(
                                                                                        child: Text(
                                                                                          tData[index]["title"],
                                                                                          style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 19),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: TextButton(
                                                                                        onPressed: () async {
                                                                                          final tempMap = tData[index];

                                                                                          tempMap['main_image_cropped'] = '';
                                                                                          final dataNews = {
                                                                                            "newsTitle": tData[index]["title"],
                                                                                            "newsURL": tData[index]["imported_news_url"],
                                                                                            "data": tempMap
                                                                                          };
                                                                                          String url = '';
                                                                                          await generateUrl(dataNews).then((value) => {
                                                                                                url = value,
                                                                                              });
                                                                                          print('it\'s shared');
                                                                                          final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                          FlutterShare.share(title: "Title", text: title);
                                                                                          //        FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳");
                                                                                          //   FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " + tData[index]["title"], chooserTitle: "इस खबर को शेयर करो...");
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Padding(
                                                                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                                child: Icon(
                                                                                                  Icons.share,
                                                                                                  size: 25,
                                                                                                  color: dark == 0 ? Color(0xFF4D555F) : Colors.white,
                                                                                                )),
                                                                                            Text(
                                                                                              'शेयर करें',
                                                                                              style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: TextButton(
                                                                                        onPressed: () {
                                                                                          bool alreadyThere = false;
                                                                                          for (var i = 0; i < list.items.length; i++) {
                                                                                            if (tData[index]["post_id"].toString() == list.items[i].id) {
                                                                                              alreadyThere = true;
                                                                                            }
                                                                                          }

                                                                                          if (alreadyThere == false) {
                                                                                            final item = Favourite(id: tData[index]["post_id"].toString(), data: tData[index]);
                                                                                            print('2');
                                                                                            list.items.add(item);
                                                                                          }
                                                                                          storage.setItem('favourite_news', list.toJSONEncodable());
                                                                                          print('it\'s bookmarked');
                                                                                          Navigator.pop(context);
                                                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                                                            SnackBar(
                                                                                                content: Text(
                                                                                                  'बुकमार्क सुरक्षित हो गया',
                                                                                                  style: TextStyle(
                                                                                                    fontSize: 17,
                                                                                                    color: Colors.white,
                                                                                                  ),
                                                                                                ),
                                                                                                action: SnackBarAction(
                                                                                                  onPressed: () {},
                                                                                                  label: 'Close',
                                                                                                  textColor: Colors.white,
                                                                                                ),
                                                                                                duration: Duration(seconds: 3)),
                                                                                          );
                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Padding(
                                                                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                                                                child: Icon(
                                                                                                  Icons.bookmark,
                                                                                                  size: 25,
                                                                                                  color: dark == 0 ? Color(0xFF4D555F) : Colors.white,
                                                                                                )),
                                                                                            Text(
                                                                                              'बुकमार्क करेंं',
                                                                                              style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 18),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ));
                                                            },
                                                            child: Icon(
                                                              Icons.share,
                                                              size: 15,
                                                              color: dark == 0
                                                                  ? Colors.red
                                                                  : Colors
                                                                      .white,
                                                            )),
                                                        SizedBox(width: 10),
                                                        // DropdownButton<IconData>(
                                                        //   underline: SizedBox(),
                                                        //   icon: Icon(Icons.share,size: 15,color: Colors.red),
                                                        //   items: <IconData>[Icons.share, Icons.bookmark].map((IconData value) {
                                                        //     return DropdownMenuItem<IconData>(
                                                        //       value: value,
                                                        //       child: value==Icons.share?
                                                        //       Row(
                                                        //         children: [
                                                        //           Icon(Icons.share),
                                                        //           SizedBox(width: 20,),
                                                        //           Text('शेयर करें'),
                                                        //         ],
                                                        //       ):
                                                        //       Row(
                                                        //         children: [
                                                        //           Icon(Icons.bookmark),
                                                        //           SizedBox(width: 20,),
                                                        //           Text('बुकमार्क करें'),
                                                        //         ],
                                                        //       ),
                                                        //     );
                                                        //   }).toList(),
                                                        //   onChanged: (newValue) {
                                                        //     if((newValue)==Icons.share)
                                                        //     {
                                                        //       print('it\'s shared');
                                                        //       FlutterShare.share(
                                                        //           title: "Title",
                                                        //           text: tData[index]
                                                        //           ["title"],
                                                        //           chooserTitle:
                                                        //           "इस खबर को शेयर करो...");
                                                        //     }
                                                        //     else
                                                        //     {
                                                        //       favourites.add(P);
                                                        //       print('it\'s bookmarked');
                                                        //     }
                                                        //   },
                                                        // )
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
            ),
          );
  }
}
