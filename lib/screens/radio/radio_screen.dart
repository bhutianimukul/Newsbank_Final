import 'dart:convert';
import 'dart:io';

import 'package:news/provider/string.dart';
import 'package:news/screens/radio/radioplayer_widget.dart';
import 'package:news/widgets/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class RadioScreen extends StatefulWidget {
  @override
  _RadioScreenState createState() => _RadioScreenState();
}

class _RadioScreenState extends State<RadioScreen> {
  int selectedIndex = 0;
  int playingIndex = -1;
  String currentChannel = "";
  ScrollController topBarController = new ScrollController();

  PageController _controller = PageController(
    initialPage: 0,
  );

  var radioData;
  Future<dynamic> getRadioData() async {
    String fileName = 'getRadioData.json';
    var dir = await getTemporaryDirectory();

    File file = File(dir.path + "/" + fileName);

    if (file.existsSync()) {
      print("reading from cache");

      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      setState(() {
        radioData = res;
      });
    } else {
      print("reading from internet");
      var request = http.Request(
          'GET', Uri.parse('https://ingnewsbank.com/api/get_category_radio'));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();

        file.writeAsStringSync(body, flush: true, mode: FileMode.write);
        final res = jsonDecode(body);
        setState(() {
          radioData = res;
        });
      } else {}
    }

    try {
      final result = await InternetAddress.lookup('www.google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        String fileName = 'getRadioData.json';
        var dir = await getTemporaryDirectory();

        File file = File(dir.path + "/" + fileName);
        print("reading from internet");
        final url = "https://ingnewsbank.com/api/get_category_radio";
        final req = await http.get(Uri.parse(url));

        if (req.statusCode == 200) {
          final body = req.body;

          file.writeAsStringSync(body, flush: true, mode: FileMode.write);
          final res = jsonDecode(body);
          setState(() {
            radioData = res;
          });
        } else {}
      }
    } on SocketException catch (_) {
      print('not connected');
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();

    getRadioData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    return Scaffold(
      backgroundColor: dark == 0 ? Colors.white : Color(0xFF262E39),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.0),
        child: AppBar(
          title: Text('Radio FM'),
          backgroundColor: Colors.blue[900],
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Container(
              height: height * 0.03,
              child: ListView.builder(
                  itemCount: radioData.length,
                  controller: topBarController,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, int index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _controller.animateToPage(index,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        });
                      },
                      child: Container(
                        width: width * 0.25,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: heading(
                                  color: dark == 1 ? Colors.white : Colors.black,
                              text: radioData[index]["category"]["title"],
                            )),
                            Container(
                                height: 2,
                                color: selectedIndex == index
                                    ? Colors.blue
                                    : Colors.transparent)
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
          Expanded(
            child: PageView.builder(
                controller: _controller,
                itemCount: radioData.length,
                onPageChanged: (value) {
                  if (selectedIndex < value) {
                    topBarController.animateTo(
                        topBarController.offset + width * 0.15,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn);
                    setState(() {
                      selectedIndex = value;
                    });
                  } else if (selectedIndex > value) {
                    topBarController.animateTo(
                        topBarController.offset - width * 0.15,
                        duration: Duration(milliseconds: 100),
                        curve: Curves.easeIn);
                    setState(() {
                      selectedIndex = value;
                    });
                  }
                },
                itemBuilder: (context, int pageindex) {
                  return ListView.builder(
                      itemCount: radioData[pageindex]["radios"].length,
                      itemBuilder: (context, int radiolistindex) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                currentChannel = radioData[pageindex]["radios"]
                                    [radiolistindex]["embed_url"];
                                playingIndex = radiolistindex;
                              });
                              _showModal(radioData[pageindex]["radios"]
                                  [radiolistindex]["title"]);
                              // showModalBottomSheet(
                              //    context: context,
                              //    builder: (BuildContext context) =>
                              //        RadioPlayer(embedUrl: currentChannel));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: dark == 0 ? Colors.white : Color(0xFF3E4651),
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 2),
                                        color: Colors.black12,
                                        spreadRadius: 0.8,
                                        blurRadius: 1)
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CachedNetworkImage(
                                          imageUrl: radioData[pageindex]
                                                  ["radios"][radiolistindex]
                                              ["logo"]),
                                      SizedBox(width: width * 0.03),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 15),
                                        child: heading(
                                            text: radioData[pageindex]["radios"]
                                                [radiolistindex]["title"],
                                            scale: 1.3,
                                            weight: FontWeight.w600),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10.0),
                                    child: playingIndex == radiolistindex
                                        ? Icon(
                                            Icons.pause_circle_filled,
                                            size: height * 0.04,
                                            color: Colors.blue,
                                          )
                                        : Icon(
                                            Icons.play_circle_filled_outlined,
                                            size: height * 0.04,
                                            color: Colors.green,
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          )
        ],
      ),
    );
  }

  void _showModal(String name) {
    Future<void> future = showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) => RadioPlayer(
              embedUrl: currentChannel,
              channelName: name,
            ));
    future.then((void value) => _closeModal(value));
  }

  void _closeModal(void value) {
    setState(() {
      playingIndex = -1;
    });
  }
}
