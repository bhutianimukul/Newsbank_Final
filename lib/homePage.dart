import 'dart:convert';
import 'dart:io';
import 'package:cache_image/cache_image.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:news/dynamic_link.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newsdata;

  void getDataFromCache() async {
    String fileName = 'pathString.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      setState(() {
        newsdata = res;
      });
      print(newsdata);
    } else {
      print("reading from internet");
      final url =
          "https://ingnewsbank.com/api/get_latest_news_by_district?page=1&did=8";
      final req = await http.get(Uri.parse(url));

      if (req.statusCode == 200) {
        final body = req.body;

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        final res = jsonDecode(body);
        setState(() {
          newsdata = res;
        });
      } else {
        setState(() {
          newsdata = jsonDecode(req.body);
        });
      }
    }
  }

  Future<dynamic> getDataFromInternet() async {
    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        String fileName = 'pathString.json';
        var dir = await getTemporaryDirectory();

        File file = File(dir.path + "/" + fileName);
        print("reading from internet");
        final url =
            "https://ingnewsbank.com/api/get_latest_news_by_district?page=1&did=8";
        final req = await http.get(Uri.parse(url));

        if (req.statusCode == 200) {
          final body = req.body;

          file.writeAsStringSync(body, flush: true, mode: FileMode.write);
          final res = jsonDecode(body);
          setState(() {
            newsdata = res;
          });
        } else {
          setState(() {
            newsdata = jsonDecode(req.body);
          });
        }
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  void navigate() async {
    await initDynamicLink();
  }

  @override
  void initState() {
    navigate();
    super.initState();
    getDataFromCache();
    getDataFromInternet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: () => getDataFromInternet(),
      child: ListView.builder(
          itemCount: newsdata["news"]["data"].length,
          itemBuilder: (context, int index) {
            return ListTile(
              leading:
                  newsdata["news"]["data"][index]["main_image_thumb"] != null
                      ? Container(
                          width: 100,
                          child: Image(
                            image: CacheImage(newsdata["news"]["data"][index]
                                ["main_image_thumb"]),
                          ),
                        )
                      : SizedBox(),
              title: Text("Title: " +
                  newsdata["news"]["data"][index]["title"].toString()),
              subtitle: Row(
                children: [
                  Text("Source Website: " +
                      newsdata["news"]["data"][index]["source_website"]),
                  SizedBox(width: 10),
                  Text(
                    newsdata["news"]["data"][index]["imported_date"],
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            );
          }),
    ));
  }
}
