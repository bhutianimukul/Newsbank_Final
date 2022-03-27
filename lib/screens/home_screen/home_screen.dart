import 'dart:convert';
import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:news/provider/homePageIndex_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/provider/world_provider.dart';
import 'package:news/screens/bookmark_page.dart';
import 'package:news/screens/feedback_form.dart';
import 'package:news/screens/home_screen/anyaRajya.dart';
import 'package:news/screens/home_screen/news_gallery.dart';
import 'package:news/screens/home_screen/search_screen.dart';
import 'package:news/screens/home_screen/states_screen.dart';
import 'package:news/screens/home_screen/top_news.dart';
import 'package:news/screens/home_screen/topbar_categories.dart';
import 'package:news/screens/home_screen/trendingScreen.dart';
import 'package:news/screens/humare_bare_me.dart';
import 'package:news/screens/liveTV/liveTV_screen.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:news/screens/niyam_aur_shartein.dart';
import 'package:news/screens/radio/radio_screen.dart';
import 'package:news/widgets/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'mera_sheher.dart';

// GlobalKey<_HomeScreenState> _homeScreenStateKey = GlobalKey<_HomeScreenState>();
///okay
ValueNotifier<bool> showAppBarValue = ValueNotifier(true);
ValueNotifier<bool> showNavBarValue = ValueNotifier(true);

class HomeScreen extends StatefulWidget {
  // void showAppBar(bool value) {
  //   showAppBarValue.value = value;
  // }

  // void showBottomBar() {
  //   _HomeScreenState().showBottombar();
  // }

  // void hideBottomBar() {
  //   _HomeScreenState().hideBottombar();
  // }

  static int stId = 0;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  void turnLightMode() {
    setState(() {
      // if (dark == 1) {
      dark = 0;
      // putColor("0");
      // }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    });
  }

  void turnDarkMode() {
    setState(() {
      // if (dark == 0) {
      dark = 1;
      // putColor("1");
      // }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
          (route) => false);
    });
  }

  void automaticSunset() {
    putColor('3');
    DateTime now = DateTime.now();
    if (now.hour > 6 && now.hour < 18) {
      turnLightMode();
    } else {
      turnDarkMode();
    }
  }

  int topBarIndex = 0;
  int topWBarIndex = 0;
  List<dynamic> topBarData = [];
  List<dynamic> topWBarData = [];
  List<dynamic> topAnyaBarData = [];

  var topbarCoontroller = new ScrollController();
  var arCoontroller = new ScrollController();
  var wCoontroller = new ScrollController();
//var cCoontroller = new ScrollController();

  // category of states news
  Future<void> getTopBarData() async {
    String fileName = 'getTopBarData.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);
    var res = [];
    if (stChange == 1) {
      print(
          "get home news reading from internet because FILE DOES NOT EXIST or State changed");
      final url =
          "https://ingnewsbank.com/api/home_top_bar_news_category?st_id=$state_id";
      final req = await http.get(Uri.parse(url));

      if (req.statusCode == 200) {
        print("in status 200 home news");
        final body = req.body;
        res = jsonDecode(body);
        try {
          await file.writeAsString(body, flush: true, mode: FileMode.write);
          print("FILE CREATED AND WRITTEN");
        } on Exception catch (e) {
          print("$e");
        }
        topBarData = res;
      }
    } else if (file.existsSync()) {
      print('this is running bro');
      final data = file.readAsStringSync();
      res = jsonDecode(data);
      if (res.length == 0) {
        print("get home news reading from internet FILE EXIST and DATA is []");
        final url =
            "https://ingnewsbank.com/api/home_top_bar_news_category?st_id=$state_id";
        final req = await http.get(Uri.parse(url));
        if (req.statusCode == 200) {
          print("in status 200 home news");
          final body = req.body;
          final res = jsonDecode(body);
          try {
            file.writeAsStringSync(body, flush: true, mode: FileMode.write);
            // print("data written in cache = $res");
          } on Exception catch (e) {
            print("$e");
          }
          topBarData = res;
        } else {
          print('file is empty and internet not connected');
        }
      } else {
        topBarData = res;
      }
    } else {
      print("get home news reading from internet because FILE DOES NOT EXIST ");
      final url =
          "https://ingnewsbank.com/api/home_top_bar_news_category?st_id=$state_id";
      final req = await http.get(Uri.parse(url));

      if (req.statusCode == 200) {
        print("in status 200 home news");
        final body = req.body;
        res = jsonDecode(body);
        try {
          await file.writeAsString(body, flush: true, mode: FileMode.write);
          print("FILE CREATED AND WRITTEN");
        } on Exception catch (e) {
          print("$e");
        }
        topBarData = res;
      }
    }

    // if (file.existsSync()) {
    //   print("reading from the topbar data cache file");

    //   final data = file.readAsStringSync();
    //   final res = jsonDecode(data);

    //   topBarData = res;
    // }

    // try {
    //   final result = await InternetAddress.lookup('www.google.com');

    //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    //     print('Internet connected');
    //     // print(result[0].rawAddress);
    //     String fileName = 'getTopBarData.json';
    //     var dir = await getTemporaryDirectory();

    //     File file = File(dir.path + "/" + fileName);
    //     print("reading from internet");
    //     //final url = "https://ingnewsbank.com/api/home_top_bar_news_category";
    //     final url =
    //         "https://ingnewsbank.com/api/home_top_bar_news_category?st_id=$state_id";
    //     final req = await http.get(Uri.parse(url));

    //     if (req.statusCode == 200) {
    //       final body = req.body;
    //       print(body);
    //       file.writeAsStringSync(body, flush: true, mode: FileMode.write);
    //       final res = jsonDecode(body);

    //       topBarData = res;
    //     } else {}
    //   }
    // } on SocketException catch (_) {
    //   print('not connected top data');
    // }

    // var request = http.Request('GET',
    //     Uri.parse('https://ingnewsbank.com/api/home_top_bar_news_category'));
    //
    // http.StreamedResponse response = await request.send();
    //
    // if (response.statusCode == 200) {
    //   var res = jsonDecode(await response.stream.bytesToString());
    //   setState(() {
    //     topBarData = res;
    //   });
    // } else {
    //   print(response.reasonPhrase);
    // }
  }

// var request = http.Request('GET', Uri.parse('https://ingnewsbank.com/api/get_news_world'));

// http.StreamedResponse response = await request.send();

// if (response.statusCode == 200) {
//   print(await response.stream.bytesToString());
// }
// else {
//   print(response.reasonPhrase);
// }

  List<dynamic> topBarNewsData = [];
  String districtName = "";

  // Future<void> getTopBarNewsData() async {
  //   String fileName = 'getTopBarNewsDataScrolling.json';
  //   var dir = await getTemporaryDirectory();
  //
  //   File file = File(dir.path + "/" + fileName);
  //
  //   if (file.existsSync()) {
  //     print("reading from cache");
  //     final data = file.readAsStringSync();
  //     final res = jsonDecode(data);
  //
  //     setState(() {
  //       topBarNewsData = res["news"]["sourcedata"];
  //       districtName = res["district"]["title"];
  //       // scrollingDistrict=res;
  //     });
  //   } else {
  //     // print("reading from internet");
  //     // var request = http.Request(
  //     //     'GET',
  //     //     Uri.parse(
  //     //         'https://ingnewsbank.com/api/get_latest_news_by_district?page=1&did=8'));
  //     //
  //     // http.StreamedResponse response = await request.send();
  //     //
  //     // if (response.statusCode == 200) {
  //     //   final body = await response.stream.bytesToString();
  //     //
  //     //   file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //     //   final res = jsonDecode(body);
  //     //
  //     //   topBarNewsData = res["news"]["data"];
  //     //   districtName = res["district"]["title"];
  //     // } else {}
  //     try {
  //       final result = await InternetAddress.lookup('www.google.com');
  //       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //         print('connected');
  //         String fileName = 'getTopBarNewsDataScrolling.json';
  //         var dir = await getTemporaryDirectory();
  //         File file = File(dir.path + "/" + fileName);
  //         print("reading from internet");
  //         final url =
  //             "https://ingnewsbank.com/api/get_latest_news_by_district?page=1&did=8";
  //         final req = await http.get(Uri.parse(url));
  //         if (req.statusCode == 200) {
  //           final body = req.body;
  //           file.writeAsStringSync(body, flush: true, mode: FileMode.write);
  //           final res = jsonDecode(body);
  //           // scrollingDistrict=res;
  //           setState(() {
  //             topBarNewsData = res["news"]["data"];
  //             districtName = res["district"]["title"];
  //           });
  //         } else {}
  //       }
  //     } on SocketException catch (_) {
  //       print('not connected getTopBarNewsData');
  //     }
  //   }
  //
  //
  //
  // }

  int yy = 1;
  Future<void> getInfo() async {
    await getTopBarData();
    // getTopBarNewsData();
    getworld().then((value) {
      yy = getallworld.length;
    });
  }

  // Future<void> getrun() async {
  //   setState(() {});
  // }

  changePage(int value) {
    Provider.of<HomePageIndexProvider>(context, listen: false)
        .changePage(value);
  }

  changePageWorld(int value) {
    Provider.of<WorldIndexProvider>(context, listen: false).changePage(value);
  }

  // id of current state
  String state_id = "";

  @override
  void didChangeDependencies() {
    // topbarCoontroller = new ScrollController();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    // AnyaRajya().getInfoAboutRajya();
    getData().then((String value) {
      print('then is running after getdata in init');
      // setState(() {
      //  isOpen(o)?dark=1:dark=0;
      //  if(dark==1){putColor("1");}else {putColor("0");}
      state_id = value;
      HomeScreen.stId = int.parse(state_id);
      AnyaRajya().getInfoAboutRajya();

      print("State $state_id");
      stChangeApnaRajya = 1;
      getInfo();
      // changePage(0);
      // myScroll();
      getColor().then((value) {
        if (!mounted) return;

        setState(() {
          if (value == '3') {
            automatic = true;
            DateTime now = DateTime.now();
            if (now.hour > 6 && now.hour < 18) {
              turnLightMode();
            } else {
              turnDarkMode();
            }
          } else {
            dark = value == "0" ? 0 : 1;
          }
        });
        // });
      });
    });
    getReadNews();
  }

  void getReadNews() async {
    final fileName = "readNews.json";
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    print("reading readNews.json");
    if (file.existsSync()) {
      final body = file.readAsStringSync();
      final res = jsonDecode(body);
      setState(() {
        readNews = res;
      });
      print("readNews file " + readNews.toString());
    }
  }

  List<TimeOfDay> o = [
    TimeOfDay(hour: 20, minute: 00),
    TimeOfDay(hour: 8, minute: 00)
  ];
  bool isOpen(List<TimeOfDay> open) {
    TimeOfDay now = TimeOfDay.now();
    return (now.hour >= open[0].hour &&
            now.minute >= open[0].minute &&
            now.hour <= open[1].hour &&
            now.minute <= open[1].minute) ||
        (now.hour > open[0].hour &&
            now.hour <= open[1].hour &&
            now.minute <= open[1].minute);
  }

  void dispose() {
    super.dispose();
  }

  // void showBottombar() {
  //   showNavBarValue.value = true;
  // }

  // void hideBottombar() {
  //   showNavBarValue.value = false;
  // }

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

  int c = 0;
  List s = [];
  var getallworld;
// Future<dynamic> getworld() async {
//     var request = http.Request('GET', Uri.parse('https://ingnewsbank.com/api/get_news_world'));
//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var responseString = await response.stream.bytesToString();

//    //   print(responseString);
//     var  decode = jsonDecode(responseString);
//     getallworld=decode;

//     } else {

//       var responseString = await response.stream.bytesToString();
// print("world");
//       print(responseString);
//     }
//   }
  Future<void> getworld() async {
    String fileName = 'getWorldData.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      if (!mounted) return;

      final res = jsonDecode(data);

      setState(() {
        getallworld = res;
      });
    } else {
      print("reading from internet");
      var request = http.Request(
          'GET', Uri.parse('https://ingnewsbank.com/api/get_news_world'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        final res = jsonDecode(body);
        if (!mounted) return;

        setState(() {
          getallworld = res;
        });
      } else {}
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        String fileName = 'getWorldData.json';
        var dir = await getTemporaryDirectory();

        File file = File(dir.path + "/" + fileName);
        print("reading from internet");
        //final url = "https://ingnewsbank.com/api/home_top_bar_news_category";
        final url = "https://ingnewsbank.com/api/get_news_world";
        final req = await http.get(Uri.parse(url));

        if (req.statusCode == 200) {
          final body = req.body;

          file.writeAsStringSync(body, flush: true, mode: FileMode.write);
          final res = jsonDecode(body);
          setState(() {
            getallworld = res;
          });
        } else {}
      }
    } on SocketException catch (_) {
      print('not connected world');
    }
  }

  var getallState;
// Future<dynamic> getstate() async {
//     var request = http.Request('GET', Uri.parse('https://ingnewsbank.com/api/get_state'));
//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var responseString = await response.stream.bytesToString();

//    //   print(responseString);
//     var  decode = jsonDecode(responseString);
//     getallState=decode;
//       c=getallState.length;
// print("state");
//     } else {

//       var responseString = await response.stream.bytesToString();
// print("state");
//       print(responseString);
//     }
//   }

  Future<bool?> cancelDialog(context, _scaffoldKey) async {
    if (_scaffoldKey.currentState != null &&
        _scaffoldKey.currentState!.isDrawerOpen == true) {
      _scaffoldKey.currentState!.openEndDrawer();
    } else {
      return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: Text('News Bank',
                    style: TextStyle(
                        color: dark == 0 ? Colors.black : Colors.white)),
                backgroundColor: dark == 1 ? Color(0xFF4D555F) : Colors.white,
                content: Text('क्या आप ऐप बंद करना चाहते हैं?',
                    style: TextStyle(
                        fontSize: 22,
                        color: dark == 0 ? Colors.black : Colors.white)),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            InkWell(
                                onTap: () {
                                  try {
                                    launch("market://details?id=" +
                                        'com.newsbank.app');
                                  } on PlatformException catch (_) {
                                    launch(
                                        "https://play.google.com/store/apps/details?id=" +
                                            'com.newsbank.app');
                                  } finally {
                                    launch(
                                        "https://play.google.com/store/apps/details?id=" +
                                            'com.newsbank.app');
                                  }
                                  // _launchURL(
                                  //     'https://play.google.com/store/apps/details?id=com.newsbank.app');
                                },
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .20,
                                    height:
                                        MediaQuery.of(context).size.width * .12,
                                    // color: Colors.blue,
                                    child: Center(
                                      child: Text('रेटिंग दें',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.blue,
                                          )),
                                    ))),
                          ],
                        ),
                        // SizedBox(
                        //   width: 20,
                        // ),
                        // InkWell(
                        //     onTap: () {
                        //       try {
                        //         launch("market://details?id=" +
                        //             'com.newsbank.app');
                        //       } on PlatformException catch (_) {
                        //         launch(
                        //             "https://play.google.com/store/apps/details?id=" +
                        //                 'com.newsbank.app');
                        //       } finally {
                        //         launch(
                        //             "https://play.google.com/store/apps/details?id=" +
                        //                 'com.newsbank.app');
                        //       }
                        //       // _launchURL(
                        //       //     'https://play.google.com/store/apps/details?id=com.newsbank.app');
                        //     },
                        //     child: Container(
                        //         width: MediaQuery.of(context).size.width * .15,
                        //         height: MediaQuery.of(context).size.width * .08,
                        //         // color: Colors.blue,
                        //         child: Text('रेटिंग दें',
                        //             style: TextStyle(color: Colors.blue)))),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                                onTap: () => Navigator.pop(context, false),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .20,
                                    height:
                                        MediaQuery.of(context).size.width * .12,
                                    child: Center(
                                      child: Text('नहीं',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue)),
                                    ))),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                                onTap: () => SystemChannels.platform
                                    .invokeMethod('SystemNavigator.pop'),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * .20,
                                    height:
                                        MediaQuery.of(context).size.width * .12,
                                    child: Center(
                                      child: Text('बंद करें',
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue)),
                                    ))),
                          ],
                        ),

                        // InkWell(
                        //     onTap: () => Navigator.pop(context, false),
                        //     child: Container(
                        //         width: MediaQuery.of(context).size.width * .15,
                        //         height: MediaQuery.of(context).size.width * .08,
                        //         child: Text('नहीं',
                        //             style: TextStyle(color: Colors.blue)))),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        // InkWell(
                        //     onTap: () => SystemChannels.platform
                        //         .invokeMethod('SystemNavigator.pop'),
                        //     child: Container(
                        //         width: MediaQuery.of(context).size.width * .15,
                        //         height: MediaQuery.of(context).size.width * .08,
                        //         child: Text('बंद करें',
                        //             style: TextStyle(color: Colors.blue)))),
                      ],
                    ),
                  ),
                ],
              ));
    }
    return false;
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> getstate() async {
    String fileName = 'getStatesData.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      setState(() {
        getallState = res;
        c = getallState.length;
      });
    } else {
      //   print("reading from internet");
      //   var request = http.Request(
      //       'GET', Uri.parse('https://ingnewsbank.com/api/get_state'));

      //   http.StreamedResponse response = await request.send();

      //   if (response.statusCode == 200) {
      //     final body = await response.stream.bytesToString();

      //     file.writeAsStringSync(body, flush: true, mode: FileMode.write);
      //     final res = jsonDecode(body);
      //     setState(() {
      //       getallState = res;
      //       c = getallState.length;
      //     });
      //   } else {}
      // }

      // try {
      //   final result = await InternetAddress.lookup('www.google.com');
      //   if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      //     print('connected');
      //     String fileName = 'getStatesData.json';
      //     var dir = await getTemporaryDirectory();

      //     File file = File(dir.path + "/" + fileName);
      //     print("reading from internet");
      //     //final url = "https://ingnewsbank.com/api/home_top_bar_news_category";
      //     final url = "https://ingnewsbank.com/api/get_state";
      //     final req = await http.get(Uri.parse(url));

      //     if (req.statusCode == 200) {
      //       final body = req.body;

      //       file.writeAsStringSync(body, flush: true, mode: FileMode.write);
      //       final res = jsonDecode(body);
      //       setState(() {
      //         getallState = res;
      //         c = getallState.length;
      //       });
      //     } else {}
      //   }
      // } on SocketException catch (_) {
      //   print('not connected get state');
      // }
    }
  }

  Future<bool> _onBack() async {
    // await storage.clear();
    //
    // setState(() {
    //   list.items = storage.getItem('favourite_news') ?? [];
    // });

    // var items = storage.getItem('favourite_news');
    //
    // if (items != null) {
    //   list.items = List<Favourite>.from(
    //     (items as List).map(
    //           (item) => Favourite(
    //             api: item['api'],
    //             id: item['id'],
    //       ),
    //     ),
    //   );
    //   List<String> fav=list.items.map((item) {
    //     return item.id;
    //   }).toList();
    //   print('these are the $fav');
    //   // print(list.items[0]);
    // }
    // print(s);
    print("On back method");
    if ((_scaffoldKey.currentState!.isDrawerOpen == true)) {
      // print("if clicked");
      setState(() {
        _scaffoldKey.currentState!.openEndDrawer();
      });
      return Future.value(false);
    } else {
      print(
        "Scaffold" + _scaffoldKey.currentState.toString(),
      );

      return await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: Text('News Bank',
                    style: TextStyle(
                        color: dark == 0 ? Colors.black : Colors.white)),
                backgroundColor: dark == 1 ? Color(0xFF4D555F) : Colors.white,
                content: Text('क्या आप ऐप बंद करना चाहते हैं?',
                    style: TextStyle(
                        color: dark == 0 ? Colors.black : Colors.white)),
                actions: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                            onTap: () {
                              try {
                                launch("market://details?id=" +
                                    'com.newsbank.app');
                              } on PlatformException catch (_) {
                                launch(
                                    "https://play.google.com/store/apps/details?id=" +
                                        'com.newsbank.app');
                              } finally {
                                launch(
                                    "https://play.google.com/store/apps/details?id=" +
                                        'com.newsbank.app');
                              }
                              // _launchURL(
                              //     'https://play.google.com/store/apps/details?id=com.newsbank.app');
                            },
                            child: Container(
                                child: Text('रेटिंग दें',
                                    style: TextStyle(color: Colors.blue)))),
                        SizedBox(
                          width: 120,
                        ),
                        InkWell(
                            onTap: () => Navigator.pop(context, false),
                            child: Container(
                                child: Text('नहीं',
                                    style: TextStyle(color: Colors.blue)))),
                        SizedBox(
                          width: 30,
                        ),
                        InkWell(
                            onTap: () => SystemChannels.platform
                                .invokeMethod('SystemNavigator.pop'),
                            child: Container(
                                child: Text('बंद करें',
                                    style: TextStyle(color: Colors.blue)))),
                      ],
                    ),
                  ),
                ],
              ));
    }
  }

  ScrollController _scrollController = ScrollController();

  final _controller = ScrollController();
  bool isscrollDown = false;
  // static bool _show = true;
  double bottomBarHei = 60;
  // static bool _showAppbar = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  _handle() {
    _scaffoldKey.currentState!.openDrawer();
  }

  int lastPage = 0;
  int _index = 0;
  int backClicked = 0;
  int lastHomeIndex = 0;
  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;

    Widget World() {
      return RefreshIndicator(
        onRefresh: () => getInfo(),
        child: ListView(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          children: [
            Container(
                height: 1.0,
                width: MediaQuery.of(context).size.width * 1,
                color: dark == 0 ? Colors.blue[900]! : Colors.white),
            Container(
              height: height * 0.05,
              child: ListView.builder(
                itemCount: yy == 1 ? 4 : getallworld.length,
                controller: wCoontroller,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, int index) {
                  int ind = index == 0 ? 0 : index - 1;
                  return InkWell(
                    onTap: () {
                      // setState(() {

                      //   topBarIndex = index == 0 ? index : index - 1;
                      // });
                      changePageWorld(index);
                    },
                    child: Container(
                      color: dark == 0 ? Colors.white : Colors.black,
                      height: height * 0.05,
                      width: width * 0.25,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Center(
                              child: heading(
                                  text: getallworld[index]["category"]["title"]
                                      .toString(),
                                  color: topWBarIndex == index
                                      ? Colors.orange[900]!
                                      : dark == 0
                                          ? Colors.blue[900]!
                                          : Colors.white),
                            ),
                          ),
                          Container(
                              height: 3,
                              color: topWBarIndex == index
                                  ? Colors.blue[900]!
                                  : dark != 0
                                      ? Colors.blue[900]!
                                      : Colors.white),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  );
                  //
                },
              ),
            ),
            Container(
              width: width,
              height: height * 0.9,
              color: dark == 0 ? Colors.white : Colors.black,
              child: PageView.builder(
                  controller:
                      Provider.of<WorldIndexProvider>(context).pagecontroller,
                  onPageChanged: (value) {
                    if (Provider.of<WorldIndexProvider>(context, listen: false)
                            .pageIndex <
                        value) {
                      wCoontroller.animateTo(wCoontroller.offset + width * 0.2,
                          duration: Duration(seconds: 1), curve: Curves.easeIn);
                    } else if (Provider.of<WorldIndexProvider>(context,
                                listen: false)
                            .pageIndex >
                        value) {
                      wCoontroller.animateTo(wCoontroller.offset - width * 0.2,
                          duration: Duration(seconds: 1), curve: Curves.easeIn);
                    }

                    Provider.of<WorldIndexProvider>(context, listen: false)
                        .onlychangeIndex(value);
                    setState(() {
                      topWBarIndex = value;
                    });
                  },
                  physics: ScrollPhysics(),
                  itemCount: yy == 1 ? 4 : getallworld.length,
                  itemBuilder: (context, int pageindex) {
                    int ch = getallworld[pageindex]["news_world"].length;
                    var h = (getallworld[pageindex]["news_world"].length / 3)
                        .toInt();
                    return Container(
                      height: MediaQuery.of(context).size.width * 0.30 * h,
                      child: ListView.builder(
                          itemCount:
                              getallworld[pageindex]["news_world"].length % 3 ==
                                      0
                                  ? h
                                  : h + 1,
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, int index) {
                            int ind = index == 0 ? 0 : index - 1;
                            return Container(
                              color: dark == 0 ? Colors.white : Colors.black,
                              height: getallworld[pageindex]["news_world"]
                                              .length %
                                          3 !=
                                      0
                                  ? MediaQuery.of(context).size.width *
                                          0.30 *
                                          (h) +
                                      5
                                  : pageindex == 3
                                      ? MediaQuery.of(context).size.width *
                                              0.30 *
                                              (h - 3) +
                                          5
                                      : MediaQuery.of(context).size.width *
                                              0.30 *
                                              (h - 1) +
                                          5,
                              width: width * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 2.0),
                                    child: Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            final dataNews = {
                                              "newsTitle":
                                                  getallworld[pageindex]
                                                          ["news_world"]
                                                      [(index * 3)]['title'],
                                              "newsURL": getallworld[pageindex]
                                                      ["news_world"]
                                                  [(index * 3)]["source_url"],
                                              "data": getallworld[pageindex]
                                                  ["news_world"][(index * 3)],
                                            };
                                            Get.to(WebviewScreen(),
                                                arguments: dataNews);

                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder: (context) =>
                                            //             WebviewScreen(
                                            //               newsTitle: getallworld[
                                            //                           pageindex]
                                            //                       ["news_world"]
                                            //                   [(index *
                                            //                       3)]['title'],
                                            //               newsURL: getallworld[
                                            //                           pageindex]
                                            //                       ["news_world"]
                                            //                   [(index *
                                            //                       3)]["source_url"],
                                            //               data: getallworld[
                                            //                           pageindex]
                                            //                       ["news_world"]
                                            //                   [(index * 3)],
                                            //             )));
                                          },
                                          child: Container(
                                              alignment: Alignment.bottomCenter,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.30,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8.0,
                                                    bottom: 8.0),
                                                child: Column(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0,
                                                              bottom: 10.0),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.27,
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.17,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: CachedNetworkImageProvider(
                                                                  getallworld[pageindex]
                                                                          [
                                                                          "news_world"]
                                                                      [(index *
                                                                          3)]["logo"]),
                                                              fit: BoxFit.fill),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 3),
                                                    Text(
                                                        getallworld[pageindex][
                                                                    "news_world"]
                                                                [(index *
                                                                    3)]["title"]
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize:
                                                                pageindex == 2
                                                                    ? 10
                                                                    : 13,
                                                            color: Colors.red)),
                                                  ],
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6.0),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(2, 2),
                                                      color: Colors.grey,
                                                      spreadRadius: 0.05)
                                                ],
                                              )),
                                        ),
                                        SizedBox(width: 4.0),
                                        (ch <= ((index * 3) + 1))
                                            ? SizedBox()
                                            : InkWell(
                                                onTap: () {
                                                  final dataNews = {
                                                    "newsTitle": getallworld[
                                                                    pageindex]
                                                                ["news_world"]
                                                            [(index * 3) + 1]
                                                        ['title'],
                                                    "newsURL": getallworld[
                                                                    pageindex]
                                                                ["news_world"]
                                                            [(index * 3) + 1]
                                                        ["source_url"],
                                                    "data":
                                                        getallworld[pageindex]
                                                                ["news_world"]
                                                            [(index * 3) + 1],
                                                  };
                                                  Get.to(WebviewScreen(),
                                                      arguments: dataNews);

                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             WebviewScreen(
                                                  //               newsTitle: getallworld[
                                                  //                       pageindex]
                                                  //                   [
                                                  //                   "news_world"][(index *
                                                  //                       3) +
                                                  //                   1]['title'],
                                                  //               newsURL: getallworld[
                                                  //                       pageindex]
                                                  //                   [
                                                  //                   "news_world"][(index *
                                                  //                       3) +
                                                  //                   1]["source_url"],
                                                  //               data: getallworld[
                                                  //                           pageindex]
                                                  //                       [
                                                  //                       "news_world"]
                                                  //                   [(index *
                                                  //                           3) +
                                                  //                       1],
                                                  //             )));
                                                },
                                                child: Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.30,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.30,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0,
                                                              bottom: 8.0),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0,
                                                                    bottom:
                                                                        10.0),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.27,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.17,
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6.0),
                                                                image: DecorationImage(
                                                                    image: CachedNetworkImageProvider(getallworld[
                                                                            pageindex]
                                                                        [
                                                                        "news_world"][(index *
                                                                            3) +
                                                                        1]["logo"]),
                                                                    fit: BoxFit.fill),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 3),
                                                          Text(
                                                              getallworld[pageindex]
                                                                              [
                                                                              "news_world"]
                                                                          [
                                                                          (index *
                                                                                  3) +
                                                                              1]
                                                                      ["title"]
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red,
                                                                  fontSize:
                                                                      pageindex ==
                                                                              2
                                                                          ? 10
                                                                          : 13)),
                                                        ],
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                Offset(2, 2),
                                                            color: Colors.grey,
                                                            spreadRadius: 0.05)
                                                      ],
                                                    )),
                                              ),
                                        SizedBox(width: 4.0),
                                        (ch <= ((index * 3) + 2))
                                            ? SizedBox()
                                            : InkWell(
                                                onTap: () {
                                                  final dataNews = {
                                                    "newsTitle": getallworld[
                                                                    pageindex]
                                                                ["news_world"]
                                                            [(index * 3) + 2]
                                                        ['title'],
                                                    "newsURL": getallworld[
                                                                    pageindex]
                                                                ["news_world"]
                                                            [(index * 3) + 2]
                                                        ["source_url"],
                                                    "data":
                                                        getallworld[pageindex]
                                                                ["news_world"]
                                                            [(index * 3) + 2],
                                                  };
                                                  Get.to(WebviewScreen(),
                                                      arguments: dataNews);
                                                  // Navigator.push(
                                                  //     context,
                                                  //     MaterialPageRoute(
                                                  //         builder: (context) =>
                                                  //             WebviewScreen(
                                                  //               newsTitle: getallworld[
                                                  //                       pageindex]
                                                  //                   [
                                                  //                   "news_world"][(index *
                                                  //                       3) +
                                                  //                   2]['title'],
                                                  //               newsURL: getallworld[
                                                  //                       pageindex]
                                                  //                   [
                                                  //                   "news_world"][(index *
                                                  //                       3) +
                                                  //                   2]["source_url"],
                                                  //               data: getallworld[
                                                  //                           pageindex]
                                                  //                       [
                                                  //                       "news_world"]
                                                  //                   [(index *
                                                  //                           3) +
                                                  //                       2],
                                                  //             )));
                                                },
                                                child: Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.30,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.30,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0,
                                                              right: 8.0,
                                                              bottom: 8.0),
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0,
                                                                    bottom:
                                                                        10.0),
                                                            child: Container(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.27,
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.17,
                                                              decoration:
                                                                  BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: CachedNetworkImageProvider(getallworld[
                                                                            pageindex]
                                                                        [
                                                                        "news_world"][(index *
                                                                            3) +
                                                                        2]["logo"]),
                                                                    fit: BoxFit.fill),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 20),
                                                          Text(
                                                            getallworld[pageindex]
                                                                        [
                                                                        "news_world"]
                                                                    [(index *
                                                                            3) +
                                                                        2]["title"]
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                    pageindex ==
                                                                            2
                                                                        ? 10
                                                                        : 13,
                                                                color:
                                                                    Colors.red),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6.0),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          offset: Offset(2, 2),
                                                          color: Colors.grey,
                                                          spreadRadius: 0.05,
                                                        )
                                                      ],
                                                    )),
                                              ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                ],
                              ),
                            );
                            //
                          }),
                    );
                  }),
            ),
          ],
        ),
      );
    }

    Widget Home() {
      return RefreshIndicator(
        onRefresh: () => getInfo(),
        child: ListView(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          children: [
            Container(
                height: 1.0,
                width: MediaQuery.of(context).size.width * 1,
                color: dark == 0 ? Colors.blue[900]! : Colors.white),
            Container(
              height: height * 0.05,
              child: ListView.builder(
                itemCount: topBarData.length + 1,
                controller: topbarCoontroller,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, int index) {
                  int ind = index == 0 ? 0 : index - 1;
                  return InkWell(
                    onTap: () {
                      changePage(index);
                    },
                    // printing sliding heading bar
                    child: Container(
                      color: dark == 0 ? Colors.white : Colors.black,
                      height: height * 0.05,
                      width: width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: Center(
                              child: heading(
                                text: index > 0
                                    ? topBarData[ind]["title"]
                                    : "टॉप न्यूज़",
                                color:
                                    Provider.of<HomePageIndexProvider>(context)
                                                .pageIndex ==
                                            0
                                        ? topBarIndex == index
                                            ? Colors.orange[900]!
                                            : dark == 0
                                                ? Colors.blue[900]!
                                                : Colors.white
                                        : topBarIndex == index - 1
                                            ? Colors.orange[900]!
                                            : dark == 0
                                                ? Colors.blue[900]!
                                                : Colors.white,
                              ),
                            ),
                          ),
                          // highlighting the selected feature like top news
                          Container(
                            height: 3,
                            color: Provider.of<HomePageIndexProvider>(context)
                                        .pageIndex ==
                                    0
                                ? topBarIndex == index
                                    ? Colors.blue
                                    : Colors.white
                                : topBarIndex == (index - 1)
                                    ? Colors.blue
                                    : Colors.white,
                          )
                        ],
                      ),
                    ),
                  );
                  //
                },
              ),
            ),
            Container(
              width: width,
              height: height * 0.9,
              color: dark == 0 ? Colors.white : Colors.black,
              child: PageView.builder(
                controller:
                    Provider.of<HomePageIndexProvider>(context).pagecontroller,
                onPageChanged: (value) {
                  print(value.toString() + " dsadasd");
                  if (Provider.of<HomePageIndexProvider>(context, listen: false)
                          .pageIndex <
                      value) {
                    topbarCoontroller.animateTo(
                      topbarCoontroller.offset + width * 0.2,
                      duration: Duration(seconds: 2),
                      curve: Curves.easeIn,
                    );
                  } else if (Provider.of<HomePageIndexProvider>(context,
                              listen: false)
                          .pageIndex >
                      value) {
                    topbarCoontroller.animateTo(
                      topbarCoontroller.offset - width * 0.2,
                      duration: Duration(seconds: 1),
                      curve: Curves.easeIn,
                    );
                  }

                  Provider.of<HomePageIndexProvider>(context, listen: false)
                      .onlychangeIndex(value);
                  setState(() {
                    topBarIndex = value == 0 ? value : value - 1;
                  });
                },
                // physics: BouncingScrollPhysics(),
                itemCount: topBarData.length + 1,
                itemBuilder: (context, int pageindex) {
                  print("printing page index $pageindex");
                  print(
                      "printing page index from provider ${Provider.of<HomePageIndexProvider>(context).pageIndex}");
                  print("printing page topbarindex $topBarIndex");
                  try {
                    if (pageindex - 1 == -1) {
                      print("pageIndexxxxxxxxxxxx 1");
                      Future.delayed(Duration(milliseconds: 2000));
                    }
                    if (Provider.of<HomePageIndexProvider>(context).pageIndex ==
                        0) {
                      print("pageIndexxxxxxxxxxxx  2");

                      return TopNews(_scrollController);
                    } else if (pageindex == 0) {
                      print("pageIndexxxxxxxxxxxx  3");

                      return TopBarCategory(_scrollController,
                          cpId: topBarData[lastHomeIndex - 1]["cp_id"]);
                    } else {
                      print("pageIndexxxxxxxxxxxx 4");

                      lastHomeIndex = pageindex;
                      return TopBarCategory(_scrollController,
                          cpId: topBarData[pageindex - 1]["cp_id"]);
                    }
                  } catch (e) {
                    print(e);
                  }
                  print("After catch homescreen");
                  return TopNews(_scrollController);

                  // Provider.of<HomePageIndexProvider>(context)
                  //               .pageIndex ==
                  //           0 &&
                  //       pageindex == 0
                  //   ? TopNews(_scrollController)
                  //   :
                },
              ),
            ),
            // Container(
            //   width: width,
            //   height: height * 0.9,
            //   color: dark == 0 ? Colors.white : Colors.black,
            //   child: PageView.builder(
            //       controller: Provider.of<HomePageIndexProvider>(context)
            //           .pagecontroller,
            //       onPageChanged: (value) {
            //         if (Provider.of<HomePageIndexProvider>(context,
            //                     listen: false)
            //                 .pageIndex <
            //             value) {
            //           topbarCoontroller.animateTo(
            //               topbarCoontroller.offset + width * 0.2,
            //               duration: Duration(seconds: 1),
            //               curve: Curves.easeIn);
            //         } else if (Provider.of<HomePageIndexProvider>(context,
            //                     listen: false)
            //                 .pageIndex >
            //             value) {
            //           topbarCoontroller.animateTo(
            //               topbarCoontroller.offset - width * 0.2,
            //               duration: Duration(seconds: 1),
            //               curve: Curves.easeIn);
            //         }

            //         Provider.of<HomePageIndexProvider>(context, listen: false)
            //             .onlychangeIndex(value);
            //         setState(() {
            //           topBarIndex = value == 0 ? value : value - 1;
            //         });
            //       },
            //       physics: ScrollPhysics(),
            //       itemCount: topBarData.length + 1,
            //       itemBuilder: (context, int pageindex) {
            //         return Provider.of<HomePageIndexProvider>(context)
            //                     .pageIndex ==
            //                 0
            //             ? TopNews(_scrollController)
            //             : TopBarCategory(_scrollController,
            //                 cpId: topBarData[pageindex - 1]["cp_id"]);
            //       }),
            // ),
          ],
        ),
      );
    }

    // Widget Anayee() {
    //   return RefreshIndicator(
    //     onRefresh: () => getrun(),
    //     child: ListView(
    //       shrinkWrap: true,
    //       physics: ScrollPhysics(),
    //       children: [
    //         Container(
    //             height: 1.0,
    //             width: MediaQuery.of(context).size.width * 1,
    //             color: dark == 0 ? Colors.blue[900]! : Colors.white),
    //         Container(
    //           height: height * 0.05,
    //           child: ListView.builder(
    //               itemCount: states,
    //               controller: arCoontroller,
    //               scrollDirection: Axis.horizontal,
    //               itemBuilder: (context, int index) {
    //                 int ind = index == 0 ? 0 : index - 1;
    //                 return InkWell(
    //                   onTap: () {
    //                     changePage(index);
    //                   },
    //                   child: Container(
    //                     color: dark == 0 ? Colors.white : Colors.black,
    //                     height: height * 0.05,
    //                     width: width * 0.2,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.stretch,
    //                       children: [
    //                         Expanded(
    //                             child: Center(
    //                                 child: heading(
    //                                     text: si[index + 1].toString(),
    //                                     color: topWBarIndex == index
    //                                         ? Colors.orange[900]!
    //                                         : dark == 0
    //                                             ? Colors.blue[900]!
    //                                             : Colors.white))),
    //                         Container(
    //                             height: 3,
    //                             color: topWBarIndex == index
    //                                 ? Colors.blue
    //                                 : Colors.white)
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //                 //
    //               }),
    //         ),
    //         Container(
    //           width: width,
    //           height: height * 0.9,
    //           color: dark == 0 ? Colors.white : Colors.black,
    //           child: PageView.builder(
    //               controller: Provider.of<HomePageIndexProvider>(context)
    //                   .pagecontroller,
    //               onPageChanged: (value) {
    //                 if (Provider.of<HomePageIndexProvider>(context,
    //                             listen: false)
    //                         .pageIndex <
    //                     value) {
    //                   arCoontroller.animateTo(
    //                       arCoontroller.offset + width * 0.2,
    //                       duration: Duration(seconds: 1),
    //                       curve: Curves.easeIn);
    //                   //      getTop(value+1).then((value) {setState(() {
    //                   // });});
    //                 } else if (Provider.of<HomePageIndexProvider>(context,
    //                             listen: false)
    //                         .pageIndex >
    //                     value) {
    //                   arCoontroller.animateTo(
    //                       arCoontroller.offset - width * 0.2,
    //                       duration: Duration(seconds: 1),
    //                       curve: Curves.easeIn);
    //                   //      getTop(value+1).then((value) {setState(() {
    //                   // });});
    //                 }
    //
    //                 Provider.of<HomePageIndexProvider>(context, listen: false)
    //                     .onlychangeIndex(value);
    //                 setState(() {
    //                   topWBarIndex = value;
    //                 });
    //               },
    //               physics: ScrollPhysics(),
    //               itemCount: states,
    //               itemBuilder: (context, int pageindex) {
    //                 return
    //                     //  Provider.of<HomePageIndexProvider>(context)
    //                     //             .pageIndex.toString() ==
    //                     //         hi
    //                     //     ? SizedBox()
    //                     //     :
    //                     //     Container(child:Text(topWBarIndex.toString()));
    //
    //                     TopBarCategory(_scrollController,
    //                         cpId: cat[topWBarIndex]);
    //               }),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    List<Widget> _pages = <Widget>[
      Home(),
      MeraSheher(_scrollController),
      AnyaRajya(),
      TrendingScreen(),
      World(),
    ];

    void _onItem(int index) {
      setState(() {
        // changePage(index);
        lastPage = this._index;
        this._index = index;
      });
    }

    ///sliver app bar
    /////body :NestedScrollView(
    //     //           floatHeaderSlivers: true,
    //     //           body: Snap(controller: _controller.appBar, child: _pages[_index]),
    //     //           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled)=>
    //     //             [SliverAppBar(
    //     //               brightness: Brightness.dark,
    //     //               backgroundColor: dark == 0 ? Colors.blue[900] : Colors.black,
    //     //               leading: new IconButton(icon: Icon(Icons.menu), onPressed: _handle),
    //     //               title: heading(text: _index==3?'ट्रैंडिंग':_index==1?'मेरा शहर':'News Bank' , color: Colors.white),
    //     //               actions: [
    //     //                 InkWell(
    //     //                     onTap: () {
    //     //                       Navigator.push(context,
    //     //                           MaterialPageRoute(builder: (context) => SearchScreen()));
    //     //                     },
    //     //                     child: Icon(
    //     //                       Icons.search,
    //     //                     )),
    //     //                 SizedBox(width: 10),
    //     //                 InkWell(
    //     //                     onTap: () {
    //     //                       Navigator.push(context,
    //     //                           MaterialPageRoute(builder: (context) => LiveTVScreen()));
    //     //                     },
    //     //                     child: Icon(Icons.tv)),
    //     //                 SizedBox(width: 10),
    //     //                 InkWell(
    //     //                     onTap: () {
    //     //                       Navigator.push(context,
    //     //                           MaterialPageRoute(builder: (context) => RadioScreen()));
    //     //                     },
    //     //                     child: Icon(Icons.radio)),
    //     //                 SizedBox(width: 10),
    //     //                 InkWell(
    //     //                     onTap: () async
    //     //                     {
    //     //
    //     //                       Navigator.push(context, MaterialPageRoute(builder: (context)=>BookmarkPage()));
    //     //                     },
    //     //                     child: Icon(Icons.bookmark)),
    //     //                 SizedBox(width: 10),
    //     //                 Icon(Icons.notifications),
    //     //               ],
    //     //             )],
    //     //         ),

    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: ValueListenableBuilder<bool>(
            valueListenable: showNavBarValue,
            builder: (context, showNav, _) => Container(
                  height: showNav ? bottomBarHei : 0,
                  width: MediaQuery.of(context).size.width,
                  child: !showNav
                      ? SizedBox(
                          height: 0,
                        )
                      : BottomNavigationBar(
                          backgroundColor:
                              dark == 0 ? Colors.white : Colors.grey[700],
                          currentIndex: _index,
                          iconSize: 26,
                          onTap: _onItem,
                          unselectedItemColor:
                              dark == 0 ? Colors.black : Colors.black,
                          selectedItemColor:
                              dark == 0 ? Colors.blue[900] : Colors.white70,
                          type: BottomNavigationBarType.fixed,
                          elevation: 10,
                          items: [
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.home,
                                // color:
                                //     dark == 0 ? Colors.blue[900] : Colors.white,
                              ),
                              label: "होम",
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.place,
                                // color:
                                //     dark == 0 ? Colors.blue[900] : Colors.white,
                              ),
                              label: "मेरा शहर",
                            ),
                            BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.map,
                                  // color: dark == 0
                                  //     ? Colors.blue[900]
                                  //     : Colors.white,
                                ),
                                label: "अन्य राज्य"),
                            BottomNavigationBarItem(
                                icon: Icon(
                                  Icons.timeline,
                                  // color: dark == 0
                                  //     ? Colors.blue[900]
                                  //     : Colors.white,
                                ),
                                label: "ट्रेंडिंग"),
                            BottomNavigationBarItem(
                              icon: Icon(
                                Icons.language,
                                // color:
                                //     dark == 0 ? Colors.blue[900] : Colors.white,
                              ),
                              label: "न्यूज वर्ल्ड",
                            )
                          ],
                        ),
                )),
        appBar: PreferredSize(
          preferredSize: showAppBarValue.value ? Size(50, 56.0) : Size(0, 0),
          child: ValueListenableBuilder<bool>(
            valueListenable: showAppBarValue,
            builder: (context, showAppbar, _) {
              return !showAppbar
                  ? PreferredSize(
                      preferredSize: Size(0.0, 0.0),
                      child: SizedBox(),
                    )
                  : ScrollAppBar(
                      controller: _controller,
                      brightness: Brightness.dark,
                      backgroundColor:
                          dark == 0 ? Colors.blue[900] : Colors.black,
                      leading: new IconButton(
                          icon: Icon(Icons.menu), onPressed: _handle),
                      title: heading(
                          text: _index == 3
                              ? 'ट्रैंडिंग'
                              : _index == 1
                                  ? 'मेरा शहर'
                                  : _index == 2
                                      ? 'अन्य राज्य'
                                      : _index == 4
                                          ? "न्यूज वर्ल्ड"
                                          : "News Bank",
                          color: Colors.white),
                      actions: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchScreen()));
                            },
                            child: Icon(
                              Icons.search,
                            )),
                        SizedBox(width: 10),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LiveTVScreen()));
                            },
                            child: Icon(Icons.tv)),
                        SizedBox(width: 10),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RadioScreen()));
                            },
                            child: Icon(Icons.radio)),
                        SizedBox(width: 10),
                        InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookmarkPage()));
                            },
                            child: Icon(Icons.bookmark)),
                        SizedBox(width: 10),
                        Icon(Icons.notifications),
                      ],
                    );
            },
          ),
        ),
        // PreferredSize(
        //     preferredSize: showAppBarValue.value ? Size(50, 56.0) : Size(0, 0),
        //     child:
        //     ValueListenableBuilder<bool>(
        //         valueListenable: showAppBarValue,
        //         builder: (context, showAppbar, _) {
        //
        //           return !showAppbar
        //               ? PreferredSize(
        //                   preferredSize: Size(0.0, 0.0),
        //                   child: Container(),
        //                 )
        //               :

        //   ;
        // })
        // ),
        drawer: SafeArea(
          child: Drawer(
            child: SingleChildScrollView(
              child: Container(
                color: dark == 0 ? Colors.white : Colors.black,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset("images/icon-modified.png",
                              height: 100, width: 100),
                          SizedBox(width: 10),
                          Column(
                            children: [
                              Text(
                                "NEWS",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 25),
                              ),
                              Text(
                                "BANK",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontSize: 25),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "पल पल की खबर, हर पल",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 18),
                    ),
                    // dark == 0
                    //     ? Divider(
                    //         thickness: 1,
                    //       )
                    //     : Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Container(
                    //             height: 1.0,
                    //             width: MediaQuery.of(context).size.width * 1,
                    //             color: dark == 0
                    //                 ? Colors.blue[900]!
                    //                 : Colors.white),
                    //       ),
                    // Divider(
                    //   thickness: 1,
                    // ),
                    // Theme(
                    //   data: Theme.of(context)
                    //       .copyWith(dividerColor: Colors.transparent),
                    //   child:
                    ExpansionTile(
                      backgroundColor:
                          dark == 0 ? Color(0xff303238FF) : Color(0xff303238),
                      leading: Icon(
                        Icons.circle_notifications,
                        color: dark == 0 ? Colors.black : Colors.white,
                      ),
                      title: Text(
                        "डार्क मोड",
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        size: 22,
                        color: dark == 0 ? Colors.black : Colors.white,
                      ),
                      children: [
                        TextButton(
                          onPressed: () async {
                            if (await getColor() != '0') {
                              automatic = false;
                              turnLightMode();
                              putColor("0");
                            }
                          },
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            leading: Icon(
                              dark == 0 && automatic == false
                                  ? Icons.circle_rounded
                                  : Icons.circle_outlined,
                              color: dark == 0 ? Colors.black : Colors.white,
                              size: 18,
                            ),
                            contentPadding: EdgeInsets.only(left: 20),
                            title: Text(
                              'Off',
                              style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      dark == 0 ? Colors.black : Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (await getColor() != '1') {
                              automatic = false;
                              turnDarkMode();
                              putColor("1");
                            }
                          },
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(
                              dark == 1 && automatic == false
                                  ? Icons.circle_rounded
                                  : Icons.circle_outlined,
                              color: dark == 0 ? Colors.black : Colors.white,
                              size: 18,
                            ),
                            title: Text(
                              'On',
                              style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      dark == 0 ? Colors.black : Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            if (await getColor() != '3') {
                              automatic = true;
                              automaticSunset();
                              DateTime now = DateTime.now();
                              if (now.hour > 6 && now.hour < 18) {
                                turnLightMode();
                              } else {
                                turnDarkMode();
                              }
                            }
                          },
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(
                              automatic == true
                                  ? Icons.circle_rounded
                                  : Icons.circle_outlined,
                              color: dark == 0 ? Colors.black : Colors.white,
                              size: 18,
                            ),
                            title: Text(
                              'Automatic at sunset',
                              style: TextStyle(
                                  fontSize: 18,
                                  color:
                                      dark == 0 ? Colors.black : Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // ),
                    // dark == 0
                    //     ? Divider(
                    //         thickness: 1,
                    //       )
                    //     : Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: Container(
                    //             height: 1.0,
                    //             width: MediaQuery.of(context).size.width * 1,
                    //             color: dark == 0
                    //                 ? Colors.blue[900]!
                    //                 : Colors.white),
                    //       ),
                    TextButton(
                      onPressed: () {
                        Share.share(
                            '🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। लाईव  नोटिफिकेशन 🔔 सहित। देखें 📺 लाईव टीवी समाचार। सुनें 📻 रेडियो-एफएम, बॉलीवुड गाने 🎧, गजल, भजन। अभी डाउनलोड करें 👇🇮🇳 https://play.google.com/store/apps/details?id=com.newsbank.app');
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.share,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "ऐप शेयर करें",
                          style: TextStyle(
                              fontSize: 18,
                              color: dark == 0 ? Colors.black : Colors.white),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: ListTile(
                        onTap: () {
                          try {
                            launch("market://details?id=" + 'com.newsbank.app');
                          } on PlatformException catch (_) {
                            launch(
                                "https://play.google.com/store/apps/details?id=" +
                                    'com.newsbank.app');
                          } finally {
                            launch(
                                "https://play.google.com/store/apps/details?id=" +
                                    'com.newsbank.app');
                          }
                        },
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.download,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "ऐप अपडेट करें",
                          style: TextStyle(
                              fontSize: 18,
                              color: dark == 0 ? Colors.black : Colors.white),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        try {
                          launch("market://details?id=" + 'com.newsbank.app');
                        } on PlatformException catch (_) {
                          launch(
                              "https://play.google.com/store/apps/details?id=" +
                                  'com.newsbank.app');
                        } finally {
                          launch(
                              "https://play.google.com/store/apps/details?id=" +
                                  'com.newsbank.app');
                        }
                        // _launchURL(
                        //     'https://play.google.com/store/apps/details?id=com.newsbank.app');
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.star,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "रेटिंग दें",
                          style: TextStyle(
                              fontSize: 18,
                              color: dark == 0 ? Colors.black : Colors.white),
                        ),
                      ),
                    ),
                    dark == 0
                        ? Divider(
                            thickness: 1,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 1.0,
                                width: MediaQuery.of(context).size.width * 1,
                                color: dark == 0
                                    ? Colors.blue[900]!
                                    : Colors.white),
                          ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RadioScreen()));
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.radio,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "रेडियो",
                          style:
                              TextStyle(fontSize: 18, color: Colors.blue[900]),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LiveTVScreen()));
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.tv,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "लाइव टीवी",
                          style:
                              TextStyle(fontSize: 18, color: Colors.blue[900]),
                        ),
                      ),
                    ),
                    dark == 0
                        ? Divider(
                            thickness: 1,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 1.0,
                              width: MediaQuery.of(context).size.width * 1,
                              color: dark == 0 ? Colors.black : Colors.white,
                            ),
                          ),
                    TextButton(
                      onPressed: () async {
                        // getgallary().then((value) {
                        //   setState(() {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             News_Gallery(_scrollController)),
                        //   );
                        // });
                        // });

                        final result = await getgallary(context);

                        if (result) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  News_Gallery(_scrollController),
                            ),
                          );
                        } else {
                          Toast.show("आपका इंटरनेट बंद है |", context);
                        }
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.image_not_supported_outlined,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "न्यूज गैलरी",
                          style:
                              TextStyle(fontSize: 16, color: Colors.redAccent),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FormScreen()),
                        );
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.feedback_rounded,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "अपना फीडबैक/सुझाव साझा करें",
                          style:
                              TextStyle(fontSize: 15, color: Colors.redAccent),
                        ),
                      ),
                    ),
                    dark == 0
                        ? Divider(
                            thickness: 1,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 1.0,
                                width: MediaQuery.of(context).size.width * 1,
                                color: dark == 0
                                    ? Colors.blue[900]!
                                    : Colors.white),
                          ),
                    TextButton(
                      onPressed: () async {
                        var body;
                        var response = await http.get(Uri.parse(
                            'https://ingnewsbank.com/api/get_basic_page?bid=1'));
                        if (response.statusCode == 200) {
                          var jsonData = jsonDecode(response.body);
                          body = jsonData['body'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NiyamShartein(text: body)),
                          );
                        }
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.rule_folder,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "नियम और शर्तें",
                          style:
                              TextStyle(fontSize: 16, color: Colors.blue[900]),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        var body;
                        var response = await http.get(Uri.parse(
                            'https://ingnewsbank.com/api/get_basic_page?bid=2'));
                        if (response.statusCode == 200) {
                          var jsonData = jsonDecode(response.body);
                          body = jsonData['body'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HumareBareMe(text: body)),
                          );
                        }
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.info,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "हमारे बारे में",
                          style:
                              TextStyle(fontSize: 16, color: Colors.blue[900]),
                        ),
                      ),
                    ),
                    // Theme(
                    // data: Theme.of(context)
                    //     .copyWith(dividerColor: Colors.transparent),
                    // child:
                    ExpansionTile(
                      // collapsedBackgroundColor: Color(0xff67b7d1),
                      backgroundColor:
                          dark == 0 ? Color(0xff303238FF) : Color(0xff303238),
                      leading: Icon(
                        Icons.notification_important,
                        color: dark == 0 ? Colors.black : Colors.white,
                      ),
                      title: Text(
                        "नोटिफिकेशन सेटिंग्स",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                        ),
                      ),
                      trailing: Icon(
                        Icons.keyboard_arrow_down,
                        size: 22,
                        color: dark == 0 ? Colors.black : Colors.white,
                      ),
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            leading: Icon(
                              dark == 0
                                  ? Icons.circle_rounded
                                  : Icons.circle_outlined,
                              color: dark == 0 ? Colors.black : Colors.white,
                              size: 18,
                            ),
                            contentPadding: EdgeInsets.only(left: 20),
                            title: Text(
                              'Allow Notifications',
                              style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      dark == 0 ? Colors.black : Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(
                              dark == 0
                                  ? Icons.circle_outlined
                                  : Icons.circle_rounded,
                              color: dark == 0 ? Colors.black : Colors.white,
                              size: 18,
                            ),
                            title: Text(
                              'Off Notifications 6 pm to 7 am',
                              style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      dark == 0 ? Colors.black : Colors.white),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen()),
                                  (route) => false);
                            });
                          },
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(
                              Icons.circle_outlined,
                              color: dark == 0 ? Colors.black : Colors.white,
                              size: 18,
                            ),
                            title: Text(
                              'Sounds',
                              style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      dark == 0 ? Colors.black : Colors.white),
                            ),
                            onTap: () {},
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()),
                                (route) => false);
                          },
                          child: ListTile(
                            visualDensity:
                                VisualDensity(horizontal: 0, vertical: -4),
                            dense: true,
                            contentPadding: EdgeInsets.only(left: 20),
                            leading: Icon(
                              Icons.circle_outlined,
                              color: dark == 0 ? Colors.black : Colors.white,
                              size: 18,
                            ),
                            title: Text(
                              'Vibration',
                              style: TextStyle(
                                  fontSize: 15,
                                  color:
                                      dark == 0 ? Colors.black : Colors.white),
                            ),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    // ),
                    dark == 0
                        ? Divider(
                            thickness: 1,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 1.0,
                                width: MediaQuery.of(context).size.width * 1,
                                color: dark == 0
                                    ? Colors.blue[900]!
                                    : Colors.white),
                          ),
                    TextButton(
                      onPressed: () {
                        getstate().then((value) {
                          setState(() {
                            if (s.length == 0) {
                              s.add("अपना राज्य चुनें");
                              for (int i = 0; i < c; i++) {
                                s.add(getallState[i]["title"].toString());
                              }
                            }
                            print(s.length);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StatesScreen(s)));
                            // MyApps(s)),(route) => false);
                          });
                        });
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.share,
                            color: dark == 0 ? Colors.black : Colors.white),
                        title: Text(
                          "अपना राज्य बदलें",
                          style: TextStyle(
                              fontSize: 18,
                              color: dark == 0 ? Colors.black : Colors.white),
                        ),
                      ),
                    ),
                    dark == 0
                        ? Divider(
                            thickness: 1,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 1.0,
                                width: MediaQuery.of(context).size.width * 1,
                                color: dark == 0
                                    ? Colors.blue[900]!
                                    : Colors.white),
                          ),
                    TextButton(
                      onPressed: () {
                        exit(0);
                      },
                      child: ListTile(
                        visualDensity:
                            VisualDensity(horizontal: 0, vertical: -4),
                        dense: true,
                        contentPadding: EdgeInsets.only(left: 20),
                        leading: Icon(Icons.exit_to_app, color: Colors.blue),
                        title: Text(
                          "EXIT FROM NEWS BANK",
                          style: TextStyle(fontSize: 19, color: Colors.blue),
                        ),
                      ),
                    ),
                    dark == 0
                        ? Divider(
                            thickness: 1,
                          )
                        : Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                height: 1.0,
                                width: MediaQuery.of(context).size.width * 1,
                                color: dark == 0
                                    ? Colors.blue[900]!
                                    : Colors.white),
                          ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 2, vertical: -4),
                      dense: true,
                      onTap: () {},
                      contentPadding: EdgeInsets.only(left: 100),
                      title: Text(
                        "Powered By:",
                        style: TextStyle(fontSize: 14, color: Colors.red),
                      ),
                    ),
                    ListTile(
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                      dense: true,
                      onTap: () {},
                      contentPadding: EdgeInsets.only(left: 50),
                      title: Text(
                        "Independent News Group",
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Snap(controller: _controller.appBar, child: _pages[_index]),
        //   World(),
        //   Home(),
        //  Anayee(),
      ),
      // onWillPop: _onBack,

      //  ()=>{return cancelDialog(context, _scaffoldKey)},

      onWillPop:
          //_scaffoldKey.currentState != null &&
          //         (_scaffoldKey.currentState!.isDrawerOpen == true)
          //     ? () {
          //         _scaffoldKey.currentState!.openEndDrawer();
          //         return Future.value(false);
          //       }
          //     :
          _index == 0
              ? () async {
                  bool? result = await cancelDialog(context, _scaffoldKey);
                  if (result == null) {
                    result = false;
                  }
                  return result;
                }
              : () {
                  print("backClicked" + backClicked.toString());
                  print("lastPage" + lastPage.toString());
                  if ((_scaffoldKey.currentState!.isDrawerOpen == true)) {
                    _scaffoldKey.currentState!.openEndDrawer();
                  } else {
                    // home
                    // app bar
                    // navigator,push  news gallery
                    // back
                    // changePage(0);
                    if (backClicked == 0) {
                      backClicked++;

                      setState(() {
                        _index = lastPage;
                      });
                    } else {
                      backClicked = 0;
                      setState(() {
                        _index = 0;
                        lastPage = 0;
                      });
                    }
                  }
                  MaterialPageRoute(builder: (context) => HomeScreen());
                  return Future.value(false);
                },
    );
  }

  Future<dynamic> getPageData({@required String? cpId}) async {
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://ingnewsbank.com/api/home_top_bar_news_of_category?cp_id=$cpId&page=1'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = jsonDecode(await response.stream.bytesToString());
      print(" from homescreen 2100");
      return data["data"];
    } else {
      print(response.reasonPhrase);
    }
  }

  // _launchURL(String url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

}
