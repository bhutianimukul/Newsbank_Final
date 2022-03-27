import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:news/provider/homePageIndex_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/home_screen/search_screen.dart';
import 'package:news/screens/home_screen/topbar_categories.dart';
import 'package:news/screens/liveTV/liveTV_screen.dart';
import 'package:news/screens/radio/radio_screen.dart';
import 'package:news/widgets/styles.dart';
// import 'package:provider/provider.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';
import 'package:quiver/strings.dart';

import '../bookmark_page.dart';

class Gallery extends StatefulWidget {
  Gallery(this.scrollController, this.cp, this.pageTitle, {Key? key})
      : super(key: key);
  int cp;
  final ScrollController scrollController;
  final String pageTitle;
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  @override
  //ScrollController _scrollController = ScrollController();

  final _controller = ScrollController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(
        brightness: Brightness.dark,
        backgroundColor: dark == 0 ? Colors.blue[900] : Colors.black,
        title: heading(text: "${widget.pageTitle}", color: Colors.white),
        actions: [
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SearchScreen()));
              },
              child: Icon(
                Icons.search,
              )),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LiveTVScreen()));
              },
              child: Icon(Icons.tv)),
          SizedBox(width: 10),
          GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RadioScreen()));
              },
              child: Icon(Icons.radio)),
          SizedBox(width: 10),
          GestureDetector(
            onTap: ()
              {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>BookmarkPage()));
              },
              child: Icon(Icons.bookmark)),
          SizedBox(width: 10),
          Icon(Icons.notifications),
        ],
        controller: _controller,
      ),
      body: Container(
        color: dark==1?Colors.black:Colors.white,
          child: TopBarCategory(widget.scrollController, cpId: widget.cp)),
    );
  }
}
