import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
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
// import 'package:share/share.dart';
import 'package:toast/toast.dart';
import '../bookmark_page.dart';
import 'home_screen.dart';

class TopBarCategory extends StatefulWidget {
  int cpId;
  TopBarCategory(this.scrollController, {required this.cpId});
  final ScrollController scrollController;
  @override
  _TopBarCategoryState createState() => _TopBarCategoryState();
}

class _TopBarCategoryState extends State<TopBarCategory> {
  static int page = 1;
  ScrollController _scrollController = ScrollController();
  PageController _controller = PageController(
    initialPage: 0,
  );
  //ScrollController _sc = new ScrollController();
  bool isLoading = false;
  int selectedIndex = 0;
  List catData = [];
  bool isscrollDown = false;

  // void myScroll() async {
  //   _scrollController.addListener(() {
  //     if (_scrollController.position.userScrollDirection ==
  //         ScrollDirection.reverse) {
  //       if (!isscrollDown) {
  //         isscrollDown = true;
  //         showAppBarValue.value = false;
  //         hideBottombar();
  //       }
  //     }
  //     if (_scrollController.position.userScrollDirection ==
  //         ScrollDirection.forward) {
  //       if (isscrollDown) {
  //         isscrollDown = false;
  //         showAppBarValue.value = true;
  //         showBottombar();
  //       }
  //     }
  //   });
  // }

  // void showBottombar() {
  //   showNavBarValue.value = true;
  // }

  // void hideBottombar() {
  //   showNavBarValue.value = false;
  // }

  Future<dynamic> getData(int index) async {
    if (!mounted) return;
    setState(() {
      index = 1;
      page = 1;
    });
    print("get data");
    String fileName = 'getTopBarCategoryData${widget.cpId.toString()}_13.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);
    if (!mounted) return;

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      if (!mounted) return;

      setState(() {
        catData.clear();
        isLoading = false;
        catData.addAll(res);
      });
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("internet from topbar categories");
        if (!mounted) return;

        // if (!isLoading) {
        print(widget.cpId);
        var request = http.Request(
          'GET',
          Uri.parse(
            'https://ingnewsbank.com/api/home_top_bar_news_of_category?cp_id=${widget.cpId}&page=${page.toString()}',
          ),
        );

        http.StreamedResponse response = await request.send();
        print("status code " + response.statusCode.toString());
        if (response.statusCode == 200) {
          final body = await response.stream.bytesToString();

          final res = jsonDecode(body);
          print("before setState");
          if (!mounted) return;

          setState(() {
            catData.clear();
            catData.addAll(res["data"]);
            print(index);
            print(catData);
            file.writeAsStringSync(jsonEncode(catData),
                flush: true, mode: FileMode.write);

            isLoading = false;
            page++;
          });
        } else {}
        // }
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        Toast.show("आपका इंटरनेट बंद है |", context);
      });
    } catch (e) {
      print(e);
    }
    print("after catch");
  }

  Future<void> getMoreData(int index) async {
    print("get more data");
    String fileName = 'getTopBarCategoryData${widget.cpId.toString()}_13.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!mounted) return;

        // if (!isLoading) {
        // setState(() {
        //   isLoading = true;
        // });
        print(index);
        var request = http.Request(
            'GET',
            Uri.parse(
                'https://ingnewsbank.com/api/home_top_bar_news_of_category?cp_id=${widget.cpId}&page=${page.toString()}'));

        http.StreamedResponse response = await request.send();
        if (response.statusCode == 200) {
          final body = await response.stream.bytesToString();
          if (!mounted) return;

          final res = jsonDecode(body);
          if (!mounted) return;

          setState(() {
            catData.addAll(res["data"]);
            file.writeAsStringSync(jsonEncode(catData),
                flush: true, mode: FileMode.write);

            isLoading = false;
            page++;
          });
        } else {}
        // }
      }
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;

        Toast.show("आपका इंटरनेट बंद है |", context);
      });
    } catch (e) {
      print(e);
    }
  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.only(bottom: 55.0, top: 10),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void initState() {
    isLoading = true;
    print("init state in topbar categories");
    print("cpid is " + widget.cpId.toString());
    // myScroll();
    super.initState();

    getData(page).then((value) {
      setState(() {
        isLoading = false;
      });
    });
    _controller.addListener(() {
      setState(() {
        selectedIndex = _controller.page!.toInt();
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent
          // /
          //         1.100000000000000001 &&
          // _scrollController.position.pixels <=
          //     _scrollController.position.maxScrollExtent
          ) {
        getMoreData(page);
      }
    });

    // widget.scrollController.addListener(() {
    //   if (widget.scrollController.position.pixels >
    //           widget.scrollController.position.maxScrollExtent /
    //               1.100000000000000001 &&
    //       widget.scrollController.position.pixels <=
    //           widget.scrollController.position.maxScrollExtent) {
    //     getMoreData(page);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    return isLoading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              setState(() {
                isLoading = true;
              });
              getData(page);
            },
            child: ListView.builder(
                itemCount: catData.length,
                controller: _scrollController,
                itemBuilder: (context, int index) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
                    child: GestureDetector(
                      onTap: () {
                        if (catData[index]["is_open_in_web_view"] == 0) {
                          final dataNews = {
                            "newsTitle": catData[index]["title"],
                            "newsURL": catData[index]["imported_news_url"],
                            "data": catData[index],
                          };
                          Get.to(WebviewScreen(), arguments: dataNews)!
                              .then((val) async {
                            final fileName = "readNews.json";
                            var dir = await getTemporaryDirectory();
                            File file = File(dir.path + "/" + fileName);
                            setState(() {
                              readNews.add(catData[index]["title"]);
                              file.writeAsStringSync(jsonEncode(readNews),
                                  flush: true, mode: FileMode.write);
                            });
                          });
                        }
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => WebviewScreen(
                        //       newsTitle: catData[index]["title"],
                        //       newsURL: catData[index]["imported_news_url"],
                        //       data: catData[index],
                        //     ),
                        //   ),
                        // ).then((val) async {
                        //   final fileName = "readNews.json";
                        //   var dir = await getTemporaryDirectory();
                        //   File file = File(dir.path + "/" + fileName);
                        //   setState(() {
                        //     readNews.add(catData[index]["title"]);
                        //     file.writeAsStringSync(jsonEncode(readNews),
                        //         flush: true, mode: FileMode.write);
                        //   });
                        // });
                        else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HTMLNews(
                                newsUrl: catData[index]["imported_news_url"],
                                news_image: catData[index]["main_image"],
                                newsSource: catData[index]["source_website"],
                                newsTime: catData[index]["imported_date"],
                                newsTitle: catData[index]["title"],
                                htmlData: catData[index]["body"],
                              ),
                            ),
                          ).then((c) async {
                            final fileName = "readNews.json";
                            var dir = await getTemporaryDirectory();
                            File file = File(dir.path + "/" + fileName);
                            setState(() {
                              readNews.add(catData[index]["title"]);
                              file.writeAsStringSync(jsonEncode(readNews),
                                  flush: true, mode: FileMode.write);
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
                                  borderRadius: BorderRadius.circular(5),
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
                                    catData[index]["main_image_thumb"] == null
                                        ? SizedBox()
                                        : Container(
                                            height: height * 0.25,
                                            width: width,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: CachedNetworkImageProvider(
                                                        catData[index][
                                                            "main_image_thumb"]),
                                                    fit: BoxFit.cover)),
                                          ),
                                    SizedBox(width: 10),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 8.0, right: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          readNews.contains(
                                                  catData[index]['title'])
                                              ? AutoSizeText(
                                                  catData[index]["title"],
                                                  // widget.cpId.toString(),
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: dark == 0
                                                        ? Colors.black
                                                            .withOpacity(.5)
                                                        : Colors.white
                                                            .withOpacity(.5),
                                                  ),
                                                  maxLines: 2,
                                                  minFontSize: 16,
                                                  maxFontSize: 30,
                                                )
                                              : AutoSizeText(
                                                  catData[index]["title"],
                                                  // widget.cpId.toString(),
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  heading(
                                                      text: catData[index]
                                                          ["source_website"],
                                                      scale: 0.9,
                                                      color: dark == 0
                                                          ? Colors.black54
                                                          : Colors.white,
                                                      weight: FontWeight.w300),
                                                  heading(
                                                    text: " | ",
                                                    color: dark == 0
                                                        ? Colors.black54
                                                        : Colors.white,
                                                  ),
                                                  heading(
                                                      text: catData[index]
                                                          ["imported_date"],
                                                      color: Colors.blue,
                                                      scale: 0.9)
                                                ],
                                              ),
                                              Spacer(),
                                              GestureDetector(
                                                  onTap: () {
                                                    showModalBottomSheet(
                                                        isScrollControlled:
                                                            true,
                                                        context: context,
                                                        builder:
                                                            (context) =>
                                                                Padding(
                                                                  padding: EdgeInsets.only(
                                                                      bottom: MediaQuery.of(
                                                                              context)
                                                                          .viewInsets
                                                                          .bottom),
                                                                  child:
                                                                      SingleChildScrollView(
                                                                    child:
                                                                        Container(
                                                                      color: dark !=
                                                                              0
                                                                          ? Color(
                                                                              0xFF4D555F)
                                                                          : Colors
                                                                              .white,
                                                                      height:
                                                                          200,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsets.fromLTRB(
                                                                                10,
                                                                                20,
                                                                                10,
                                                                                10),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                catData[index]["title"],
                                                                                style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 19),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                TextButton(
                                                                              onPressed: () async {
                                                                                final tempMap = catData[index];

                                                                                tempMap['main_image_cropped'] = '';

                                                                                final newsData = {
                                                                                  "newsTitle": catData[index]["title"],
                                                                                  "newsURL": catData[index]["imported_news_url"],
                                                                                  "data": tempMap
                                                                                };
//! adding logic for dynamic url

                                                                                String url = '';
                                                                                await generateUrl(newsData).then((value) => {
                                                                                      url = value,
                                                                                    });

                                                                                print('it\'s shared');
                                                                                final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                FlutterShare.share(title: "Title", text: title);
                                                                                //      FlutterShare.share(title: "Title", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " + catData[index]["title"], chooserTitle: "इस खबर को शेयर करो...", linkUrl: url);
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
                                                                            child:
                                                                                TextButton(
                                                                              onPressed: () {
                                                                                bool alreadyThere = false;
                                                                                for (var i = 0; i < list.items.length; i++) {
                                                                                  if (catData[index]["post_id"].toString().toString() == list.items[i].id) {
                                                                                    alreadyThere = true;
                                                                                  }
                                                                                }

                                                                                if (alreadyThere == false) {
                                                                                  final item = Favourite(id: catData[index]["post_id"].toString(), data: catData[index]);
                                                                                  print('2');
                                                                                  list.items.add(item);
                                                                                  storage.setItem('favourite_news', list.toJSONEncodable());
                                                                                }
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
                                              SizedBox(width: 10)
                                              // Container(
                                              //   width: 40,
                                              //   child: DropdownButton<IconData>(
                                              //     isExpanded:true,
                                              //     underline: SizedBox(),
                                              //     icon: Icon(Icons.share,size: 15,color: Colors.red),
                                              //     items: <IconData>[Icons.share, Icons.bookmark].map((IconData value) {
                                              //       return DropdownMenuItem<IconData>(
                                              //         value: value,
                                              //         child: value==Icons.share?
                                              //         Row(
                                              //           children: [
                                              //             Icon(Icons.share),
                                              //             SizedBox(width: 20,),
                                              //             Text('शेयर करें'),
                                              //           ],
                                              //         ):
                                              //         Row(
                                              //           children: [
                                              //             Icon(Icons.bookmark),
                                              //             SizedBox(width: 20,),
                                              //             Text('बुकमार्क करें'),
                                              //           ],
                                              //         ),
                                              //       );
                                              //     }).toList(),
                                              //     onChanged: (newValue) {
                                              //       if((newValue)==Icons.share)
                                              //       {
                                              //         print('it\'s shared');
                                              //         FlutterShare.share(
                                              //             title: "Title",
                                              //             text: catData[index]
                                              //             ["title"],
                                              //             chooserTitle:
                                              //             "इस खबर को शेयर करो...");
                                              //       }
                                              //       else
                                              //       {
                                              //         favourites.add(P);
                                              //         ScaffoldMessenger.of(context).showSnackBar(
                                              //           SnackBar(
                                              //               content: Text('बुकमार्क सुरक्षित हो गया',
                                              //                 style: TextStyle(
                                              //                   fontSize:17,
                                              //                   color: dark == 0 ? Colors.black : Colors.white,
                                              //                 ),
                                              //               ),
                                              //               action: SnackBarAction(onPressed: () {}, label: 'Close',
                                              //                 textColor: dark == 0 ? Colors.black : Colors.white,
                                              //               ),
                                              //               duration: Duration(seconds: 3)
                                              //           ),
                                              //         );
                                              //         print('it\'s bookmarked');
                                              //       }
                                              //     },
                                              //   ),
                                              // )
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
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(3, 3),
                                        color: Colors.black12,
                                        spreadRadius: 0.05)
                                  ]),
                              child: Row(
                                children: [
                                  catData[index]["main_image_thumb"] == null
                                      ? SizedBox()
                                      : Container(
                                          height: height * 0.18,
                                          width: width * 0.4,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: CachedNetworkImageProvider(
                                                      catData[index]
                                                          ["main_image_thumb"]),
                                                  fit: BoxFit.cover)),
                                        ),
                                  SizedBox(width: 2),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          readNews.contains(
                                                  catData[index]["title"])
                                              ? AutoSizeText(
                                                  catData[index]["title"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: dark == 0
                                                        ? Colors.black
                                                            .withOpacity(.5)
                                                        : Colors.white
                                                            .withOpacity(.5),
                                                  ),
                                                  textScaleFactor: 1.0,
                                                  maxLines: 3,
                                                  minFontSize: 15,
                                                  maxFontSize: 29,
                                                )
                                              : AutoSizeText(
                                                  catData[index]["title"],
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
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
                                                          new EdgeInsets.only(
                                                              right: 13.0),
                                                      child: RichText(
                                                        textScaleFactor: 1.0,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        text: TextSpan(
                                                          text: catData[index][
                                                              "source_website"],
                                                          style: TextStyle(
                                                            fontSize: 11,
                                                            color: dark == 0
                                                                ? Colors.black54
                                                                : Colors.white,
                                                          ),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: ' | ',
                                                                style: TextStyle(
                                                                    color: dark ==
                                                                            0
                                                                        ? Colors
                                                                            .black
                                                                        : Colors
                                                                            .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            TextSpan(
                                                                text: catData[
                                                                            index]
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
                                                      showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          context: context,
                                                          builder:
                                                              (context) =>
                                                                  Padding(
                                                                    padding: EdgeInsets.only(
                                                                        bottom: MediaQuery.of(context)
                                                                            .viewInsets
                                                                            .bottom),
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Container(
                                                                        color: dark !=
                                                                                0
                                                                            ? Color(0xFF4D555F)
                                                                            : Colors.white,
                                                                        height:
                                                                            200,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  catData[index]["title"],
                                                                                  style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 19),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Expanded(
                                                                              child: TextButton(
                                                                                onPressed: () async {
                                                                                  final tempMap = catData[index];

                                                                                  tempMap['main_image_cropped'] = '';

                                                                                  final newsData = {
                                                                                    "newsTitle": catData[index]["title"],
                                                                                    "newsURL": catData[index]["imported_news_url"],
                                                                                    "data": tempMap
                                                                                  };
//! adding logic for dynamic url

                                                                                  String url = '';
                                                                                  await generateUrl(newsData).then((value) => {
                                                                                        url = value,
                                                                                      });

                                                                                  print('it\'s shared');
                                                                                  final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                  FlutterShare.share(title: "Title", text: title);
                                                                                  //         FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳");
                                                                                  //     FlutterShare.share(title: "Title", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " + catData[index]["title"], chooserTitle: "इस खबर को शेयर करो...", linkUrl: url);
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
                                                                                    if (catData[index]["post_id"].toString().toString() == list.items[i].id) {
                                                                                      alreadyThere = true;
                                                                                    }
                                                                                  }

                                                                                  if (alreadyThere == false) {
                                                                                    final item = Favourite(id: catData[index]["post_id"].toString(), data: catData[index]);
                                                                                    print('2');
                                                                                    list.items.add(item);
                                                                                    storage.setItem('favourite_news', list.toJSONEncodable());
                                                                                  }
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
                                                SizedBox(width: 10)
                                                // Container(
                                                //   width: 40,
                                                //   child: DropdownButton<IconData>(
                                                //     underline: SizedBox(),
                                                //     isExpanded:true,
                                                //     icon: Icon(Icons.share,size: 15,color: Colors.red),
                                                //     items: <IconData>[Icons.share, Icons.bookmark].map((IconData value) {
                                                //       return DropdownMenuItem<IconData>(
                                                //         value: value,
                                                //         child: value==Icons.share?
                                                //         Row(
                                                //           children: [
                                                //             Icon(Icons.share),
                                                //             SizedBox(width: 20,),
                                                //             Text('शेयर करें'),
                                                //           ],
                                                //         ):
                                                //         Row(
                                                //           children: [
                                                //             Icon(Icons.bookmark),
                                                //             SizedBox(width: 20,),
                                                //             Text('बुकमार्क करें'),
                                                //           ],
                                                //         ),
                                                //       );
                                                //     }).toList(),
                                                //     onChanged: (newValue) {
                                                //       if((newValue)==Icons.share)
                                                //       {
                                                //         print('it\'s shared');
                                                //         FlutterShare.share(
                                                //             title: "Title",
                                                //             text: catData[index]
                                                //             ["title"],
                                                //             chooserTitle:
                                                //             "इस खबर को शेयर करो...");
                                                //       }
                                                //       else
                                                //       {
                                                //         ScaffoldMessenger.of(context).showSnackBar(
                                                //           SnackBar(
                                                //               content: Text('बुकमार्क सुरक्षित हो गया',
                                                //                 style: TextStyle(
                                                //                   fontSize:17,
                                                //                   color:Colors.white,
                                                //                 ),
                                                //               ),
                                                //               action: SnackBarAction(onPressed: () {}, label: 'Close',
                                                //                 textColor:Colors.white,
                                                //               ),
                                                //               duration: Duration(seconds: 3)
                                                //           ),
                                                //         );
                                                //         favourites.add(P);
                                                //         print('it\'s bookmarked');
                                                //       }
                                                //     },
                                                //   ),
                                                // ),
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
          );
  }
}
