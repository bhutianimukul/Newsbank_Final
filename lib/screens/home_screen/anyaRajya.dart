import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:news/dynamic_link.dart';
import 'package:news/provider/apna_ragya_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/home_screen/home_screen.dart';
import 'package:news/screens/news_details/html_news.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/widgets/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

int stChangeApnaRajya = 1;
var homeNewsDataApnaRajya = {};

class AnyaRajya extends StatefulWidget {
  void getInfoAboutRajya() {
    // _AnyaRajyaState().getInfo();
  }
  @override
  _AnyaRajyaState createState() => _AnyaRajyaState();
}

class _AnyaRajyaState extends State<AnyaRajya> with TickerProviderStateMixin {
  late TabController tabController;
  int stid = 0;
  List homeNewsDataList = [];
  bool isLoading = true;
  int skip = 0;
  List ragyaName = [];
  List ragyaId = [];
  ScrollController topbarCoontroller = ScrollController();

  Widget buildProgressIndicator() {
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

  // Future<Map> getHomeNews(String hi) async {
  //   //Get from cache
  //   String fileName = 'getHomeNews$hi.json';
  //   var dir = await getTemporaryDirectory();
  //   File file = File(dir.path + "/" + fileName);
  //
  //   if (file.existsSync() && stChangeApnaRajya==0) {
  //     //   if (!file.existsSync()) {
  //     if (homeNewsDataApnaRajya.length==0) {
  //       print('this was ran part 1');
  //       final url =
  //           "https://ingnewsbank.com/api/home_latest_news?take=25&st_id=$hi&page=1";
  //       print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
  //       final req = await http.get(Uri.parse(url));
  //       final body = req.body;
  //       file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //       final res = jsonDecode(body) as List;
  //       homeNewsDataApnaRajya = res[0] as Map;
  //     }
  //
  //     else
  //       {
  //         // final url =
  //         //     "https://ingnewsbank.com/api/home_latest_news?take=25&st_id=$hi&page=1";
  //         // print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
  //         // final req = await http.get(Uri.parse(url));
  //         // final body = req.body;
  //         // file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //         // final res = jsonDecode(body) as List;
  //         // homeNewsDataApnaRajya = res[0] as Map;
  //         final data = file.readAsStringSync();
  //         final res = jsonDecode(data).toList();
  //         // print('the number is $hi and data is $res');
  //         homeNewsDataApnaRajya = res[0] as Map;
  //       }
  //   }
  //   //
  //   else {
  //     print('this was ran');
  //     final url =
  //         "https://ingnewsbank.com/api/home_latest_news?take=25&st_id=$hi&skip=$skip";
  //     final req = await http.get(Uri.parse(url));
  //     final body = req.body;
  //     file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //     final res = jsonDecode(body) as List;
  //     homeNewsDataApnaRajya = res[0] as Map;
  //   }
  //
  //     // }
  //
  //     // else {
  //     //   final url =
  //     //       "https://ingnewsbank.com/api/home_latest_news?take=45&st_id=$hi&page=$page";
  //     //
  //     //   final req = await http.get(Uri.parse(url));
  //     //
  //     //   if (req.statusCode == 200) {
  //     //     final body = req.body;
  //     //     final res = jsonDecode(body) as List;
  //     //     homeNewsData = res[0] as Map;
  //     //   } else {
  //     //     print('error in recieving data anyarajya ');
  //     //   }
  //     // }
  //   // }
  //   return homeNewsDataApnaRajya;
  // }

  int page = 1;
  @override
  void initState() {
    // ragyaName.clear();
    // ragyaId.clear();
    getInfo();
    super.initState();
    stid = HomeScreen.stId;
    // tabController = new TabController(length: numberOfStates-1, vsync: this);
    // tabController.addListener(() {});
  }

  var topbarCoontrollerMs = new ScrollController();
  // Future<List> getMoreData(String hi, int page) async {
  //   print("get more data");
  //   String fileName = 'getHomeNews$hi.json';
  //   var dir = await getTemporaryDirectory();
  //   File file = File(dir.path + "/" + fileName);
  //   try {
  //     final result = await InternetAddress.lookup('www.google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       if (!isLoading) {
  //         setState(() {
  //           isLoading = true;
  //         });
  //         print("printing page $page");
  //         var request = http.Request(
  //             'GET',
  //             Uri.parse(
  //                 "https://ingnewsbank.com/api/home_latest_news?take=$page&st_id=$hi"));
  //
  //         http.StreamedResponse response = await request.send();
  //         if (response.statusCode == 200) {
  //           final body = await response.stream.bytesToString();
  //
  //           final res = jsonDecode(body);
  //
  //           homeNewsData.add(res[0] as Map);
  //           file.writeAsStringSync(jsonEncode(homeNewsData),
  //               flush: true, mode: FileMode.write);
  //           isLoading = false;
  //
  //           return homeNewsData;
  //         }
  //         return homeNewsData;
  //       }
  //     }
  //   } on SocketException catch (_) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return [];
  //   }
  //   return homeNewsData;
  // }

  int done = 0;

  changePage(int value) {
    Provider.of<ApnaRagyaIndexProvider>(context, listen: false)
        .changePage(value);
  }

  Future<void> getInfo() async {
    // printing all states except current

    String fileName = 'getStateNames.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    var stateList = [];
// 1 changed
// 0 state not changed
    if (file.existsSync() && stChange == 0) {
      final body = file.readAsStringSync();
      final res = jsonDecode(body);
      if (res.length != 0) {
        setState(() {
          stateList = res;
        });
      }
    } else {
      try {
        if (stChangeApnaRajya == 1) {
          final url = "https://ingnewsbank.com/api/get_state";
          print(
              "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
          final req = await http.get(Uri.parse(url));
          final body = req.body;
          file.writeAsStringSync(body, flush: true, mode: FileMode.write);
          stateList = jsonDecode(body);
          stChangeApnaRajya = 0;
          // fetching from web
        } else {
          if (file.existsSync()) {
            // is there or not
            final body = file.readAsStringSync();
            final res = jsonDecode(body);
            if (res.length == 0) {
              final url = "https://ingnewsbank.com/api/get_state";
              print(
                  "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
              final req = await http.get(Uri.parse(url));
              final body = req.body;
              file.writeAsStringSync(body, flush: true, mode: FileMode.write);
              stateList = jsonDecode(body);
              stChangeApnaRajya = 0;
            } else {
              stateList = res;
            }
          } else {
            stateList = [];
            // no data
          }
        }
      } on SocketException catch (_) {
        final body = file.readAsStringSync();
        final res = jsonDecode(body);
        if (res.length == 0)
          stateList = [];
        else
          stateList = res;
      }
    }

    // if (file.existsSync() && stChangeApnaRajya == 0) {
    //   final body = file.readAsStringSync();
    //   res = jsonDecode(body);
    // } else {
    //   final url = "https://ingnewsbank.com/api/get_state";
    //   print(
    //       "get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
    //   final req = await http.get(Uri.parse(url));
    //   final body = req.body;
    //   file.writeAsStringSync(body, flush: true, mode: FileMode.write);
    //   res = jsonDecode(body);
    // }

    for (int i = 0; i < numberOfStates; i++) {
      if (stid != stateList[i]['sid']) {
        ragyaName.add(stateList[i]['title']);
      }

      if (stid != stateList[i]['sid']) {
        ragyaId.add(stateList[i]['sid']);
      }
    }
    print('all ragya id are $ragyaId');
    setState(() {});

    // if (homeNewsDataList.length<=8) {
    //   for (int i = 1; i <= numberOfStates; i++) {
    //     // print('values of i are $i');
    //     if (i!= stid) {
    //       String statesId = i.toString();
    //       await getHomeNews(statesId).then((value){
    //         homeNewsDataList.add(value);
    //         // print('number is $i and data is \n $value');
    //       });
    //       // if (page == 1) {
    //       // }
    //       // else {
    //       //   // String statesId = i.toString();
    //       //   // getHomeNews(statesId).then((value) {
    //       //   //   for (var item in value['news'])
    //       //   //     homeNewsDataList[j]['news'].add(item);
    //       //   // });
    //       //   // j++;
    //       //   // return homeNewsDataList;
    //       // }
    //     }
    //   }
    // }
    // stChangeApnaRajya=0;
    // print('elements are $homeNewsDataList');
    // page++;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // print("State ID from anya rajya $stid");
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    return Container(
        color: dark == 0 ? Colors.white : Colors.black,
        child: ragyaName.length == 0
            ? Container()
            : ListView(
                children: [
                  Container(
                    height: height * 0.05,
                    child: ListView.builder(
                        itemCount: numberOfStates - 1,
                        controller: topbarCoontrollerMs,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, int index) {
                          return GestureDetector(
                            onTap: () {
                              // setState(() {

                              //   topBarIndex = index == 0 ? index : index - 1;
                              // });
                              changePage(index);
                            },
                            child: Container(
                              color: dark == 0 ? Colors.white : Colors.black,
                              height: height * 0.05,
                              width: width * 0.17,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: Center(
                                          child: heading(
                                    text: ragyaName[index].toString(),
                                    color: Provider.of<ApnaRagyaIndexProvider>(
                                                    context)
                                                .pageIndex ==
                                            index
                                        ? Colors.orange
                                        : Colors.blue,
                                  ))),
                                  // Provider.of<ApnaSheherIndexProvider>(
                                  //     context)
                                  //     .pageIndex == 0
                                  //     ? topBarIndex == index ? Colors.orange[900]! : dark == 0
                                  //     ? Colors.blue[900]!
                                  //     : Colors.white
                                  //     : topBarIndex == index - 1
                                  //     ? Colors.orange[900]!
                                  //     : dark == 0
                                  //     ? Colors.blue[900]!
                                  //     : Colors.white))),
                                  Container(
                                    height: 3,
                                    color: Provider.of<ApnaRagyaIndexProvider>(
                                                    context)
                                                .pageIndex ==
                                            index
                                        ? Colors.blue
                                        : Colors.white,

                                    // Provider.of<ApnaSheherIndexProvider>(context)
                                    //     .pageIndex ==
                                    //     0
                                    //     ? topBarIndex == index
                                    //     ? Colors.blue
                                    //     : Colors.white
                                    //     : topBarIndex == (index - 1)
                                    //     ? Colors.blue
                                    //     : Colors.white
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                          );
                          //
                        }),
                  ),
                  // TabBar(
                  //   onTap: (index)
                  //   {
                  //     setState(() {
                  //       pageController.animateToPage(index,duration: Duration(milliseconds: 1000), curve: Curves.easeIn);
                  //     });
                  //   },
                  //   unselectedLabelColor: Colors.blue[900]!,
                  //   labelColor: Colors.orange[900]!,
                  //   controller: tabController,
                  //   isScrollable: true,
                  //   automaticIndicatorColorAdjustment: true,
                  //   tabs: [
                  //     for (int i = 0; i < numberOfStates-1; i++)
                  //       Tab(
                  //         text: homeNewsDataList[i]['category']["title"],
                  //       ),
                  //   ],
                  // ),
                  ///pageview
                  Container(
                    width: width,
                    height: height * 0.9,
                    child: ragyaName.length == 0
                        ? SizedBox()
                        : PageView.builder(
                            itemCount: ragyaName.length,
                            controller:
                                Provider.of<ApnaRagyaIndexProvider>(context)
                                    .pagecontroller,
                            onPageChanged: (value) {
                              if (Provider.of<ApnaRagyaIndexProvider>(context,
                                          listen: false)
                                      .pageIndex <
                                  value) {
                                topbarCoontrollerMs.animateTo(
                                    topbarCoontrollerMs.offset + width * 0.2,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.linear);
                              } else if (Provider.of<ApnaRagyaIndexProvider>(
                                          context,
                                          listen: false)
                                      .pageIndex >
                                  value) {
                                topbarCoontrollerMs.animateTo(
                                    topbarCoontrollerMs.offset - width * 0.2,
                                    duration: Duration(seconds: 1),
                                    curve: Curves.linear);
                              }

                              Provider.of<ApnaRagyaIndexProvider>(context,
                                      listen: false)
                                  .onlychangeIndex(value);
                            },
                            itemBuilder: (context, pageIndex) {
                              return Ragya(id: ragyaId[pageIndex]);
                            },
                          ),
                  ),
                ],
              ));
  }
}

class Ragya extends StatefulWidget {
  final int id;
  Ragya({required this.id});

  @override
  _RagyaState createState() => _RagyaState();
}

class _RagyaState extends State<Ragya> {
  var homeNewsDataList = [];
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();
  late int page;

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

  Future<void> getInfo() async {
    setState(() {
      page = 1;
    });
    String fileName = 'getHomeNews${widget.id}.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      print("reading from cache");
      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      setState(() {
        homeNewsDataList = res;
        //   // catData.addAll(res);
      });
      // print('this is homedata $homeNewsDataList');
      // print(res);

    }

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print("interet");
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          // print(index);
          var request = http.Request(
              'GET',
              Uri.parse(
                  'https://ingnewsbank.com/api/home_latest_news?take=40&st_id=${widget.id}&page=1'));

          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            final body = await response.stream.bytesToString();

            final res = jsonDecode(body);
            homeNewsDataList = res[0]['news'];
            // print(index);
            file.writeAsStringSync(jsonEncode(homeNewsDataList),
                flush: true, mode: FileMode.write);
            setState(() {
              // homeNewsDataList.clear();

              isLoading = false;
              page++;
            });
          } else {}
        }
      } else
        setState(() {});
    } on SocketException catch (_) {
      setState(() {
        isLoading = false;
        Toast.show("आपका इंटरनेट बंद है |", context);
      });
    }
  }

  Future<void> getMoreData() async {
    String fileName = 'getHomeNews${widget.id}.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!isLoading) {
          setState(() {
            isLoading = true;
          });
          // print(index);
          var request = http.Request(
              'GET',
              Uri.parse(
                  'https://ingnewsbank.com/api/home_latest_news?take=40&st_id=${widget.id}&skip=$page'));
          http.StreamedResponse response = await request.send();
          if (response.statusCode == 200) {
            final body = await response.stream.bytesToString();

            final res = jsonDecode(body);

            setState(() {
              homeNewsDataList.addAll(res[0]['news']);
              file.writeAsStringSync(jsonEncode(homeNewsDataList),
                  flush: true, mode: FileMode.write);

              isLoading = false;
              page++;
            });
          } else {}
        }
      }
    } on SocketException catch (_) {
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
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  void initState() {
    // myScroll();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
              _scrollController.position.maxScrollExtent /
                  1.100000000000000001 &&
          _scrollController.position.pixels <=
              _scrollController.position.maxScrollExtent) {
        getMoreData();
      }
    });
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    return homeNewsDataList == null
        ? Center(
            child: Container(),
          )
        : RefreshIndicator(
            onRefresh: () async {
              await getInfo();
              setState(() {});
            },
            child: ListView.builder(
                controller: _scrollController,
                itemCount: homeNewsDataList.length,
                itemBuilder: (context, int index) {
                  return index == homeNewsDataList.length
                      ? _buildProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              if (homeNewsDataList[index]
                                      ["is_open_in_web_view"] ==
                                  0) {
                                final dataNews = {
                                  "newsTitle": homeNewsDataList[index]["title"],
                                  "newsURL": homeNewsDataList[index]
                                      ["imported_news_url"],
                                  "data": homeNewsDataList[index],
                                };
                                Get.to(WebviewScreen(), arguments: dataNews)!
                                    .then((val) async {
                                  final fileName = "readNews.json";
                                  var dir = await getTemporaryDirectory();
                                  File file = File(dir.path + "/" + fileName);
                                  setState(() {
                                    readNews
                                        .add(homeNewsDataList[index]["title"]);
                                    file.writeAsStringSync(jsonEncode(readNews),
                                        flush: true, mode: FileMode.write);
                                  });
                                });
                              }
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => WebviewScreen(
                              //               newsTitle: homeNewsDataList[index]
                              //                   ["title"],
                              //               newsURL: homeNewsDataList[index]
                              //                   ["imported_news_url"],
                              //               data: homeNewsDataList[index],
                              //             ))).then((val) async {
                              //   final fileName = "readNews.json";
                              //   var dir = await getTemporaryDirectory();
                              //   File file = File(dir.path + "/" + fileName);
                              //   setState(() {
                              //     readNews
                              //         .add(homeNewsDataList[index]["title"]);
                              //     file.writeAsStringSync(jsonEncode(readNews),
                              //         flush: true, mode: FileMode.write);
                              //   });
                              // });
                              else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HTMLNews(
                                              newsUrl: homeNewsDataList[index]
                                                  ["imported_news_url"],
                                              news_image:
                                                  homeNewsDataList[index]
                                                      ["main_image"],
                                              newsSource:
                                                  homeNewsDataList[index]
                                                      ["source_website"],
                                              newsTime: homeNewsDataList[index]
                                                  ["publish_date"],
                                              newsTitle: homeNewsDataList[index]
                                                  ["title"],
                                              htmlData: homeNewsDataList[index]
                                                  ["title"],
                                            ))).then((val) async {
                                  final fileName = "readNews.json";
                                  var dir = await getTemporaryDirectory();
                                  File file = File(dir.path + "/" + fileName);
                                  setState(() {
                                    readNews
                                        .add(homeNewsDataList[index]["title"]);
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
                                          homeNewsDataList[index]
                                                      ["main_image_thumb"] ==
                                                  null
                                              ? SizedBox()
                                              : Container(
                                                  height: height * 0.25,
                                                  width: width,
                                                  decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image:
                                                              CachedNetworkImageProvider(
                                                            homeNewsDataList[
                                                                    index][
                                                                "main_image_thumb"],
                                                          ),
                                                          fit: BoxFit.cover)),
                                                ),
                                          // : Container(
                                          //     height: height * 0.25,
                                          //     width: width,
                                          //     decoration: BoxDecoration(
                                          //         image: DecorationImage(
                                          //             image: NetworkImage(
                                          //                 homeNewsDataList[
                                          //                             index]
                                          //                         [
                                          //                         "main_image_thumb"] ??
                                          //                     "https://i.stack.imgur.com/y9DpT.jpg"),
                                          //             fit: BoxFit.cover)),
                                          //   ),
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
                                                        homeNewsDataList[index]
                                                            ["title"])
                                                    ? AutoSizeText(
                                                        homeNewsDataList == null
                                                            ? ''
                                                            : homeNewsDataList[
                                                                index]["title"],
                                                        // widget.cpId.toString(),
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
                                                        homeNewsDataList == null
                                                            ? ''
                                                            : homeNewsDataList[
                                                                index]["title"],
                                                        // widget.cpId.toString(),
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
                                                            text: homeNewsDataList[
                                                                    index][
                                                                "source_website"],
                                                            scale: 0.9,
                                                            color: dark == 0
                                                                ? Colors.black54
                                                                : Colors.white,
                                                            weight: FontWeight
                                                                .w300),
                                                        heading(
                                                          text: " | ",
                                                          color: dark == 0
                                                              ? Colors.black54
                                                              : Colors.white,
                                                        ),
                                                        heading(
                                                            text: homeNewsDataList[
                                                                    index][
                                                                "imported_date"],
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
                                                                        padding:
                                                                            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Container(
                                                                            color: dark != 0
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
                                                                                      homeNewsDataList[index]["title"],
                                                                                      style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 19),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Expanded(
                                                                                  child: TextButton(
                                                                                    onPressed: () async {
                                                                                      final tempMap = homeNewsDataList[index];

                                                                                      tempMap['main_image_cropped'] = '';

                                                                                      final dataNews = {
                                                                                        "newsTitle": homeNewsDataList[index]["title"],
                                                                                        "newsURL": homeNewsDataList[index]["imported_news_url"],
                                                                                        "data": tempMap,
                                                                                      };
                                                                                      String url = '';
                                                                                      await generateUrl(dataNews).then((value) => {
                                                                                            url = value,
                                                                                          });
                                                                                      print('it\'s shared');
                                                                                      final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                      FlutterShare.share(title: "Title", text: title);
                                                                                      // final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                      FlutterShare.share(title: "Title", text: title);
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
                                                                                      for (var k = 0; k < list.items.length; k++) {
                                                                                        if (homeNewsDataList[index]["post_id"].toString() == list.items[k].id) {
                                                                                          alreadyThere = true;
                                                                                        }
                                                                                      }
                                                                                      print(homeNewsDataList[index]["post_id"]);
                                                                                      if (alreadyThere == false) {
                                                                                        final item = Favourite(id: homeNewsDataList[index]["post_id"].toString(), data: homeNewsDataList[index]);
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
                                        homeNewsDataList[index]
                                                    ["main_image_thumb"] ==
                                                null
                                            ? SizedBox()
                                            : Container(
                                                height: height * 0.18,
                                                width: width * 0.4,
                                                decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: CachedNetworkImageProvider(
                                                            homeNewsDataList[
                                                                    index][
                                                                "main_image_thumb"]),
                                                        fit: BoxFit.cover)),
                                                // DecorationImage(
                                                //     image: NetworkImage(
                                                //         homeNewsDataList[
                                                //                     index][
                                                //                 "main_image_thumb"] ??
                                                //             "https://i.stack.imgur.com/y9DpT.jpg"),
                                                //     fit: BoxFit.cover)),
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
                                                        homeNewsDataList[index]
                                                            ["title"])
                                                    ? AutoSizeText(
                                                        homeNewsDataList == null
                                                            ? ''
                                                            : homeNewsDataList[
                                                                index]["title"],
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
                                                        homeNewsDataList == null
                                                            ? ''
                                                            : homeNewsDataList[
                                                                index]["title"],
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
                                                                text: homeNewsDataList[
                                                                        index][
                                                                    "source_website"],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 11,
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
                                                                      text: homeNewsDataList[index]
                                                                              [
                                                                              "imported_date"]
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
                                                                                        homeNewsDataList[index]["title"],
                                                                                        style: TextStyle(color: dark == 0 ? Color(0xFF4D555F) : Colors.white, fontSize: 19),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: TextButton(
                                                                                      onPressed: () async {
                                                                                        final tempMap = homeNewsDataList[index];

                                                                                        tempMap['main_image_cropped'] = '';

                                                                                        final dataNews = {
                                                                                          "newsTitle": homeNewsDataList[index]["title"],
                                                                                          "newsURL": homeNewsDataList[index]["imported_news_url"],
                                                                                          "data": tempMap,
                                                                                        };
                                                                                        String url = '';
                                                                                        await generateUrl(dataNews).then((value) => {
                                                                                              url = value,
                                                                                            });
                                                                                        print('it\'s shared');
                                                                                        final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                        FlutterShare.share(title: "Title", text: title);
                                                                                        //   final title = "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" + Uri.parse(url).toString();
                                                                                        FlutterShare.share(title: "Title", text: title);
                                                                                        //          FlutterShare.share(linkUrl: url, title: "Title", text: "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " + homeNewsDataList[index]["title"], chooserTitle: "इस खबर को शेयर करो...");
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
                                                                                        for (var k = 0; k < list.items.length; k++) {
                                                                                          if (homeNewsDataList[index]["post_id"].toString() == list.items[k].id) {
                                                                                            alreadyThere = true;
                                                                                          }
                                                                                        }
                                                                                        print(homeNewsDataList[index]["post_id"]);
                                                                                        if (alreadyThere == false) {
                                                                                          final item = Favourite(id: homeNewsDataList[index]["post_id"].toString(), data: homeNewsDataList[index]);
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
