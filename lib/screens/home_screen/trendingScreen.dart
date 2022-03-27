import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news/provider/string.dart';
import 'package:news/screens/home_screen/search_screen.dart';
import 'package:news/screens/home_screen/trendingNews.dart';
import 'package:news/screens/liveTV/liveTV_screen.dart';
import 'package:news/screens/radio/radio_screen.dart';
import 'package:news/widgets/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import '../bookmark_page.dart';
import 'dart:io';

class TrendingScreen extends StatefulWidget {
  TrendingScreen({Key? key}) : super(key: key);

  @override
  State<TrendingScreen> createState() => _TrendingScreenState();
}

var trendingData = [];

class _TrendingScreenState extends State<TrendingScreen> {
  void initState() {
    getTrending();
    super.initState();
  }

  Future<dynamic> getTrending() async {
    String fileName = 'TrendingScreenData.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    print("gettrending function trending screen ");

    if (file.existsSync()) {
      print("cache file exist in trending screen  ");

      final res = file.readAsStringSync();
      final data = jsonDecode(res);
      if (data.length != 0) {
        print("reading from the cache trending screen ");
        setState(() {
          trendingData = data;
        });
      }
    }

    try {
      var response = await http
          .get(Uri.parse('https://ingnewsbank.com/api/trending_tags'));
      if (response.statusCode == 200) {
        print('response from net trending screen ');

        final res = jsonDecode(response.body);

        trendingChange = 0;
        if (res.length != 0) {
          print("writing in the file trending screen");
          file.writeAsStringSync(response.body,
              flush: true, mode: FileMode.write);
          setState(() {
            trendingData = res;
          });
        }
      } else {
        if (file.existsSync()) {
          final res = file.readAsStringSync();
          final data = jsonDecode(res);
          setState(() {
            trendingData = data.length == 0 ? [] : data;
          });
        } else {
          setState(() {
            trendingData = [];
          });
        }
      }
    } on SocketException catch (_) {
      print("Error trending screen");
      if (file.existsSync()) {
        final res = file.readAsStringSync();
        final data = jsonDecode(res);
        setState(() {
          trendingData = data.length == 0 ? [] : data;
        });
      } else {
        setState(() {
          trendingData = [];
        });
      }
    }

    // String fileName = 'TrendingScreenData.json';
    // var dir = await getTemporaryDirectory();

    // File file = File(dir.path + "/" + fileName);

    // if (file.existsSync() && trendingChange == 0) {
    //   print('from cache data');
    //   final data = file.readAsStringSync();
    //   final res = jsonDecode(data);
    //   trendingChange = 0;
    //   return res;
    // } else {
    //   print('response from net');
    //   var response = await http
    //       .get(Uri.parse('https://ingnewsbank.com/api/trending_tags'));
    //   if (response.statusCode == 200) {
    //     final res = jsonDecode(response.body);
    //     file.writeAsStringSync(jsonEncode(res),
    //         flush: true, mode: FileMode.write);
    //     trendingChange = 0;
    //     return jsonDecode(response.body) as List;
    //   } else {
    //     return [];
    //   }
    // }
  }

  ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: dark == 1 ? Colors.black : Colors.white,
      child: trendingData.length == 0
          ? Container()
          : GridView.builder(
              itemCount: trendingData.length,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 20,
                  childAspectRatio: 20 / 5),
              itemBuilder: (context, index) {
                var color = int.parse(
                    '0xff' + trendingData[index]['bg_color_code'].substring(1));
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => screen(
                          context,
                          trendingData[index]['t_id'],
                          trendingData[index]['tag']['title'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Color(color),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Text(
                      "${trendingData[index]['tag']['title']}",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Widget screen(BuildContext ctx, int tId, String pageTitle) {
    return Scaffold(
      appBar: ScrollAppBar(
        brightness: Brightness.dark,
        backgroundColor: dark == 0 ? Colors.blue[900] : Colors.black,
        title: heading(text: "$pageTitle", color: Colors.white),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: Icon(
                Icons.search,
              )),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (context) => LiveTVScreen()));
              },
              child: Icon(Icons.tv)),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(ctx,
                    MaterialPageRoute(builder: (context) => RadioScreen()));
              },
              child: Icon(Icons.radio)),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BookmarkPage()));
              },
              child: Icon(Icons.bookmark)),
          SizedBox(width: 10),
          Icon(Icons.notifications),
        ],
        controller: _controller,
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: TrendingNews(tId),
      ),
    );
  }
}
