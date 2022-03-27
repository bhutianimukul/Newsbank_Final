import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:news/widgets/styles.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LiveTVScreen extends StatefulWidget {
  @override
  _LiveTVScreenState createState() => _LiveTVScreenState();
}

class _LiveTVScreenState extends State<LiveTVScreen> {
  VideoPlayerController? _videocontroller;
  String currentChannel = "";
  List<dynamic> tvDataList = [];
  ChewieController? _chewieController;
  bool isBuffering = false;

  void changeChannel() {
    _videocontroller = VideoPlayerController.network(
      "$currentChannel",
      formatHint: VideoFormat.hls,
    )..initialize().then((_) {
        _chewieController = ChewieController(
          videoPlayerController: _videocontroller!,
          autoPlay: true,
          looping: false,
          isLive: true,
          autoInitialize: false,
          allowedScreenSleep: false,
          showOptions: false,
          allowPlaybackSpeedChanging: false,
        );

        setState(() {
          isBuffering = false;
        });
      });
  }

  Future<dynamic> getLiveTvData() async {
    print("reading from internet");
    var request = http.Request(
        'GET', Uri.parse('https://ingnewsbank.com/api/get_live_tvs'));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();

      final res = jsonDecode(body);
      setState(() {
        tvDataList = res;
        currentChannel = tvDataList[0]["embed_url"];
      });
      changeChannel();
    } else {}
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    print("yes");
    getLiveTvData();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // IMPORTANT to dispose of all the used resources
    Wakelock.disable();
    _videocontroller!.dispose();
    _chewieController!.dispose();
    _chewieController!.pause();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return await true;
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: _videocontroller?.value.isInitialized ?? true
                    ? isBuffering
                        ? Container(child: Center(child: Text("Loasing")))
                        : Chewie(
                            controller: _chewieController!,
                          )

                    // AspectRatio(
                    //         aspectRatio: 16 / 9,
                    //         child: VideoPlayer(_controller!),
                    //       )
                    : Container(
                        child: Center(child: CircularProgressIndicator())),
              ),
              Expanded(
                flex: 5,
                child: GridView.builder(
                  itemCount: tvDataList.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      child: InkWell(
                        splashColor: Colors.grey,
                        onTap: () {
                          _chewieController!.pause();
                          setState(() {
                            isBuffering = true;
                            currentChannel = tvDataList[index]["embed_url"];
                          });
                          _videocontroller!.dispose();
                          changeChannel();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: currentChannel ==
                                          tvDataList[index]["embed_url"]
                                      ? Colors.blue
                                      : Colors.transparent,
                                  width: 3)),
                          child: Card(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: new CachedNetworkImage(
                                        imageUrl: tvDataList[index]["logo"]),
                                  ),
                                ),
                                heading(
                                    text: tvDataList[index]["title"],
                                    weight: FontWeight.w800,
                                    color: Colors.blue[900]!,
                                    scale: 0.9)
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
