import 'package:news/widgets/styles.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

class RadioPlayer extends StatefulWidget {
  String embedUrl;
  String channelName;
  RadioPlayer({required this.embedUrl, required this.channelName});

  @override
  _RadioPlayerState createState() => _RadioPlayerState();
}

class _RadioPlayerState extends State<RadioPlayer> {
  var chewieController;
  bool isError = false;
  VideoPlayerController? _videocontroller;
  void changeChannel() {
    try {
      _videocontroller = VideoPlayerController.network(
        "${widget.embedUrl}",
      )..initialize().then((_) {
          _videocontroller!.play();
          chewieController = ChewieController(
              videoPlayerController: _videocontroller!,
              autoPlay: true,
              looping: true,
              showOptions: false,
              allowFullScreen: false,
              allowedScreenSleep: false,
              allowPlaybackSpeedChanging: false,
              errorBuilder: (context, value) {
                return Icon(Icons.error);
              },
              isLive: true);
          // _controller!.play();
          setState(() {});
        }).onError((error, stackTrace) {
          print("lole" + error.toString());
          setState(() {
            isError = true;
          });
        });
    } catch (e) {
      print("lol" + e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    setState(() {
      print(widget.embedUrl);
    });
    changeChannel();
  }

  @override
  void dispose() {
    super.dispose();
    _videocontroller!.dispose();
    chewieController.dispose();
    Wakelock.disable();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    return Wrap(
      children: [
        Container(
          width: width,
          color: Colors.black12,
          child: _videocontroller!.value.isInitialized
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("images/radio-player.gif"),
                    SizedBox(height: 20),
                    heading(
                        text: widget.channelName,
                        color: Colors.blue[900]!,
                        weight: FontWeight.w800,
                        scale: 1.3),
                    SizedBox(height: 20),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: button1(
                            heading(
                                text: "Close", color: Colors.white, scale: 1.5),
                            25)),
                    SizedBox(height: 20),
                    heading(
                        text:
                            "Please wait around 20 sec if radio is not playing instantly"),
                    SizedBox(height: 30),
                  ],
                )
              : Container(
                  child: Center(
                      child: isError
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error),
                                SizedBox(height: 10),
                                heading(text: "Can't play the file")
                              ],
                            )
                          : CircularProgressIndicator()),
                ),
        ),
      ],
    );
  }
}
