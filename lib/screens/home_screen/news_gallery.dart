import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/home_screen/gallary.dart';
import 'package:news/screens/home_screen/search_screen.dart';
import 'package:news/screens/liveTV/liveTV_screen.dart';
import 'package:news/screens/radio/radio_screen.dart';
import 'package:news/widgets/styles.dart';
import 'package:scroll_app_bar/scroll_app_bar.dart';

import '../bookmark_page.dart';

class News_Gallery extends StatefulWidget {
  News_Gallery(this.scrollController, {Key? key}) : super(key: key);
  final ScrollController scrollController;
  @override
  _News_GalleryState createState() => _News_GalleryState();
}

class _News_GalleryState extends State<News_Gallery> {
  @override
  ScrollController _scrollController = ScrollController();

  final _controller = ScrollController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ScrollAppBar(
        brightness: Brightness.dark,
        backgroundColor: dark == 0 ? Colors.blue[900] : Colors.black,
        title: heading(text: "News Gallery", color: Colors.white),
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
      body: Snap(
        controller: _controller.appBar,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
            itemCount: getallgallary.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                if (index == 0) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LiveTVScreen()));
                } else if (index == 1) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RadioScreen()));
                } else {
                  setState(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Gallery(
                                widget.scrollController,
                                int.parse(getallgallary[index]["link"]
                                    .split('/')[(getallgallary[index]["link"]
                                        .split('/')
                                        .length) -
                                    1]),
                                getallgallary[index]["title"])));
                  });
                }
              },
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.width * 0.30,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0, top: 8),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.20,
                        height: MediaQuery.of(context).size.width * 0.18,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: CachedNetworkImageProvider(
                                  getallgallary[index]["logo"]),
                              fit: BoxFit.cover),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(getallgallary[index]["title"].toString()),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(3, 3),
                        color: Colors.black12,
                        spreadRadius: 0.05)
                  ],
                ),
              ),
            ),
          ),

          // child: Column(
          //   children: [
          //     SizedBox(height: 10.0),
          //     Row(
          //       children: [
          //         GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => LiveTVScreen()));
          //           },
          //           child: Container(
          //               alignment: Alignment.bottomCenter,
          //               width: MediaQuery.of(context).size.width * 0.30,
          //               height: MediaQuery.of(context).size.width * 0.30,
          //               child: Padding(
          //                 padding: const EdgeInsets.only(
          //                     left: 8.0, right: 8.0, bottom: 8.0),
          //                 child: Column(
          //                   children: [
          //                     Container(
          //                       width: MediaQuery.of(context).size.width * 0.20,
          //                       height:
          //                           MediaQuery.of(context).size.width * 0.18,
          //                       decoration: BoxDecoration(
          //                         image: DecorationImage(
          //                             image: CachedNetworkImageProvider(
          //                                 getallgallary[0]["logo"]),
          //                             fit: BoxFit.cover),
          //                       ),
          //                     ),
          //                     SizedBox(height: 10),
          //                     Text(getallgallary[0]["title"].toString()),
          //                   ],
          //                 ),
          //               ),
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 boxShadow: [
          //                   BoxShadow(
          //                       offset: Offset(3, 3),
          //                       color: Colors.black12,
          //                       spreadRadius: 0.05)
          //                 ],
          //               )),
          //         ),
          //         SizedBox(width: 4.0),
          //         GestureDetector(
          //           onTap: () {
          //             Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => RadioScreen()));
          //           },
          //           child: Container(
          //               alignment: Alignment.bottomCenter,
          //               width: MediaQuery.of(context).size.width * 0.30,
          //               height: MediaQuery.of(context).size.width * 0.30,
          //               child: Padding(
          //                 padding: const EdgeInsets.only(
          //                     left: 8.0, right: 8.0, bottom: 8.0),
          //                 child: Column(
          //                   children: [
          //                     Container(
          //                       width: MediaQuery.of(context).size.width * 0.20,
          //                       height:
          //                           MediaQuery.of(context).size.width * 0.18,
          //                       decoration: BoxDecoration(
          //                         image: DecorationImage(
          //                             image: CachedNetworkImageProvider(
          //                                 getallgallary[1]["logo"]),
          //                             fit: BoxFit.cover),
          //                       ),
          //                     ),
          //                     SizedBox(height: 10),
          //                     Text(getallgallary[1]["title"].toString()),
          //                   ],
          //                 ),
          //               ),
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 boxShadow: [
          //                   BoxShadow(
          //                       offset: Offset(3, 3),
          //                       color: Colors.black12,
          //                       spreadRadius: 0.05)
          //                 ],
          //               )),
          //         ),
          //         SizedBox(width: 4.0),
          //         GestureDetector(
          //           onTap: () {
          //             setState(() {
          //               Navigator.push(
          //                   context,
          //                   MaterialPageRoute(
          //                       builder: (context) =>
          //                           Gallery(widget.scrollController, 6)));
          //             });
          //           },
          //           child: Container(
          //               alignment: Alignment.bottomCenter,
          //               width: MediaQuery.of(context).size.width * 0.30,
          //               height: MediaQuery.of(context).size.width * 0.30,
          //               child: Padding(
          //                 padding: const EdgeInsets.only(
          //                     left: 8.0, right: 8.0, bottom: 8.0),
          //                 child: Column(
          //                   children: [
          //                     Container(
          //                       width: MediaQuery.of(context).size.width * 0.20,
          //                       height:
          //                           MediaQuery.of(context).size.width * 0.18,
          //                       decoration: BoxDecoration(
          //                         image: DecorationImage(
          //                             image: CachedNetworkImageProvider(
          //                                 getallgallary[2]["logo"]),
          //                             fit: BoxFit.cover),
          //                       ),
          //                     ),
          //                     SizedBox(height: 10),
          //                     Text(getallgallary[2]["title"].toString()),
          //                   ],
          //                 ),
          //               ),
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 boxShadow: [
          //                   BoxShadow(
          //                       offset: Offset(3, 3),
          //                       color: Colors.black12,
          //                       spreadRadius: 0.05)
          //                 ],
          //               )),
          //         ),
          //       ],
          //     ),
          //     SizedBox(height: 10.0),
          //     GestureDetector(
          //       onTap: () {
          //         setState(() {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) =>
          //                       Gallery(widget.scrollController, 18)));
          //         });
          //       },
          //       child: Padding(
          //         padding: const EdgeInsets.only(left: 2.0),
          //         child: Row(
          //           children: [
          //             Container(
          //                 alignment: Alignment.bottomCenter,
          //                 width: MediaQuery.of(context).size.width * 0.30,
          //                 height: MediaQuery.of(context).size.width * 0.30,
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                       left: 8.0, right: 8.0, bottom: 8.0),
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         width:
          //                             MediaQuery.of(context).size.width * 0.20,
          //                         height:
          //                             MediaQuery.of(context).size.width * 0.18,
          //                         decoration: BoxDecoration(
          //                           image: DecorationImage(
          //                               image: CachedNetworkImageProvider(
          //                                   getallgallary[3]["logo"]),
          //                               fit: BoxFit.cover),
          //                         ),
          //                       ),
          //                       SizedBox(height: 10),
          //                       Text(getallgallary[3]["title"].toString()),
          //                     ],
          //                   ),
          //                 ),
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   boxShadow: [
          //                     BoxShadow(
          //                         offset: Offset(3, 3),
          //                         color: Colors.black12,
          //                         spreadRadius: 0.05)
          //                   ],
          //                 )),
          //             SizedBox(width: 4.0),
          //             GestureDetector(
          //               onTap: () {
          //                 setState(() {
          //                   Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           builder: (context) =>
          //                               Gallery(widget.scrollController, 10)));
          //                 });
          //               },
          //               child: Container(
          //                   alignment: Alignment.bottomCenter,
          //                   width: MediaQuery.of(context).size.width * 0.30,
          //                   height: MediaQuery.of(context).size.width * 0.30,
          //                   child: Padding(
          //                     padding: const EdgeInsets.only(
          //                         left: 8.0, right: 8.0, bottom: 8.0),
          //                     child: Column(
          //                       children: [
          //                         Container(
          //                           width: MediaQuery.of(context).size.width *
          //                               0.20,
          //                           height: MediaQuery.of(context).size.width *
          //                               0.18,
          //                           decoration: BoxDecoration(
          //                             image: DecorationImage(
          //                                 image: CachedNetworkImageProvider(
          //                                     getallgallary[4]["logo"]),
          //                                 fit: BoxFit.cover),
          //                           ),
          //                         ),
          //                         SizedBox(height: 10),
          //                         Text(getallgallary[4]["title"].toString()),
          //                       ],
          //                     ),
          //                   ),
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     boxShadow: [
          //                       BoxShadow(
          //                           offset: Offset(3, 3),
          //                           color: Colors.black12,
          //                           spreadRadius: 0.05)
          //                     ],
          //                   )),
          //             ),
          //             SizedBox(width: 4.0),
          //             GestureDetector(
          //               onTap: () {
          //                 setState(() {
          //                   Navigator.push(
          //                       context,
          //                       MaterialPageRoute(
          //                           builder: (context) =>
          //                               Gallery(widget.scrollController, 12)));
          //                 });
          //               },
          //               child: Container(
          //                   alignment: Alignment.bottomCenter,
          //                   width: MediaQuery.of(context).size.width * 0.30,
          //                   height: MediaQuery.of(context).size.width * 0.30,
          //                   child: Padding(
          //                     padding: const EdgeInsets.only(
          //                         left: 8.0, right: 8.0, bottom: 8.0),
          //                     child: Column(
          //                       children: [
          //                         Container(
          //                           width: MediaQuery.of(context).size.width *
          //                               0.20,
          //                           height: MediaQuery.of(context).size.width *
          //                               0.18,
          //                           decoration: BoxDecoration(
          //                             image: DecorationImage(
          //                                 image: CachedNetworkImageProvider(
          //                                     getallgallary[5]["logo"]),
          //                                 fit: BoxFit.cover),
          //                           ),
          //                         ),
          //                         SizedBox(height: 10),
          //                         Text(getallgallary[5]["title"].toString()),
          //                       ],
          //                     ),
          //                   ),
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     boxShadow: [
          //                       BoxShadow(
          //                           offset: Offset(3, 3),
          //                           color: Colors.black12,
          //                           spreadRadius: 0.05)
          //                     ],
          //                   )),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ),
          //     SizedBox(height: 10.0),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 2.0),
          //       child: Row(
          //         children: [
          //           GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) =>
          //                             Gallery(widget.scrollController, 6)));
          //               });
          //             },
          //             child: Container(
          //                 alignment: Alignment.bottomCenter,
          //                 width: MediaQuery.of(context).size.width * 0.30,
          //                 height: MediaQuery.of(context).size.width * 0.30,
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                       left: 8.0, right: 8.0, bottom: 8.0),
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         width:
          //                             MediaQuery.of(context).size.width * 0.20,
          //                         height:
          //                             MediaQuery.of(context).size.width * 0.18,
          //                         decoration: BoxDecoration(
          //                           image: DecorationImage(
          //                               image: CachedNetworkImageProvider(
          //                                   getallgallary[6]["logo"]),
          //                               fit: BoxFit.cover),
          //                         ),
          //                       ),
          //                       SizedBox(height: 10),
          //                       Text(getallgallary[6]["title"].toString()),
          //                     ],
          //                   ),
          //                 ),
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   boxShadow: [
          //                     BoxShadow(
          //                         offset: Offset(3, 3),
          //                         color: Colors.black12,
          //                         spreadRadius: 0.05)
          //                   ],
          //                 )),
          //           ),
          //           SizedBox(width: 4.0),
          //           GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) =>
          //                             Gallery(widget.scrollController, 19)));
          //               });
          //             },
          //             child: Container(
          //                 alignment: Alignment.bottomCenter,
          //                 width: MediaQuery.of(context).size.width * 0.30,
          //                 height: MediaQuery.of(context).size.width * 0.30,
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                       left: 8.0, right: 8.0, bottom: 8.0),
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         width:
          //                             MediaQuery.of(context).size.width * 0.20,
          //                         height:
          //                             MediaQuery.of(context).size.width * 0.18,
          //                         decoration: BoxDecoration(
          //                           image: DecorationImage(
          //                               image: CachedNetworkImageProvider(
          //                                   getallgallary[7]["logo"]),
          //                               fit: BoxFit.cover),
          //                         ),
          //                       ),
          //                       SizedBox(height: 10),
          //                       Text(getallgallary[7]["title"].toString()),
          //                     ],
          //                   ),
          //                 ),
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   boxShadow: [
          //                     BoxShadow(
          //                         offset: Offset(3, 3),
          //                         color: Colors.black12,
          //                         spreadRadius: 0.05)
          //                   ],
          //                 )),
          //           ),
          //           SizedBox(width: 4.0),
          //           Container(
          //               alignment: Alignment.bottomCenter,
          //               width: MediaQuery.of(context).size.width * 0.30,
          //               height: MediaQuery.of(context).size.width * 0.30,
          //               child: Padding(
          //                 padding: const EdgeInsets.only(
          //                     left: 8.0, right: 8.0, bottom: 8.0),
          //                 child: Column(
          //                   children: [
          //                     GestureDetector(
          //                       onTap: () {
          //                         setState(() {
          //                           Navigator.push(
          //                               context,
          //                               MaterialPageRoute(
          //                                   builder: (context) => Gallery(
          //                                       widget.scrollController, 21)));
          //                         });
          //                       },
          //                       child: Container(
          //                         width:
          //                             MediaQuery.of(context).size.width * 0.20,
          //                         height:
          //                             MediaQuery.of(context).size.width * 0.18,
          //                         decoration: BoxDecoration(
          //                           image: DecorationImage(
          //                               image: CachedNetworkImageProvider(
          //                                   getallgallary[8]["logo"]),
          //                               fit: BoxFit.cover),
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(height: 10),
          //                     Text(getallgallary[8]["title"].toString()),
          //                   ],
          //                 ),
          //               ),
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 boxShadow: [
          //                   BoxShadow(
          //                       offset: Offset(3, 3),
          //                       color: Colors.black12,
          //                       spreadRadius: 0.05)
          //                 ],
          //               )),
          //         ],
          //       ),
          //     ),
          //     SizedBox(height: 10.0),
          //     Padding(
          //       padding: const EdgeInsets.only(left: 2.0),
          //       child: Row(
          //         children: [
          //           GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) =>
          //                             Gallery(widget.scrollController, 21)));
          //               });
          //             },
          //             child: Container(
          //                 alignment: Alignment.bottomCenter,
          //                 width: MediaQuery.of(context).size.width * 0.30,
          //                 height: MediaQuery.of(context).size.width * 0.30,
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                       left: 8.0, right: 8.0, bottom: 8.0),
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         width:
          //                             MediaQuery.of(context).size.width * 0.20,
          //                         height:
          //                             MediaQuery.of(context).size.width * 0.18,
          //                         decoration: BoxDecoration(
          //                           image: DecorationImage(
          //                               image: CachedNetworkImageProvider(
          //                                   getallgallary[9]["logo"]),
          //                               fit: BoxFit.cover),
          //                         ),
          //                       ),
          //                       SizedBox(height: 10),
          //                       Text(getallgallary[9]["title"].toString()),
          //                     ],
          //                   ),
          //                 ),
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   boxShadow: [
          //                     BoxShadow(
          //                         offset: Offset(3, 3),
          //                         color: Colors.black12,
          //                         spreadRadius: 0.05)
          //                   ],
          //                 )),
          //           ),
          //           SizedBox(width: 4.0),
          //           GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) =>
          //                             Gallery(widget.scrollController, 22)));
          //               });
          //             },
          //             child: Container(
          //                 alignment: Alignment.bottomCenter,
          //                 width: MediaQuery.of(context).size.width * 0.30,
          //                 height: MediaQuery.of(context).size.width * 0.30,
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                       left: 8.0, right: 8.0, bottom: 8.0),
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         width:
          //                             MediaQuery.of(context).size.width * 0.20,
          //                         height:
          //                             MediaQuery.of(context).size.width * 0.18,
          //                         decoration: BoxDecoration(
          //                           image: DecorationImage(
          //                               image: CachedNetworkImageProvider(
          //                                   getallgallary[10]["logo"]),
          //                               fit: BoxFit.cover),
          //                         ),
          //                       ),
          //                       SizedBox(height: 10),
          //                       Text(getallgallary[10]["title"].toString()),
          //                     ],
          //                   ),
          //                 ),
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   boxShadow: [
          //                     BoxShadow(
          //                         offset: Offset(3, 3),
          //                         color: Colors.black12,
          //                         spreadRadius: 0.05)
          //                   ],
          //                 )),
          //           ),
          //           SizedBox(width: 4.0),
          //           GestureDetector(
          //             onTap: () {
          //               setState(() {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                         builder: (context) =>
          //                             Gallery(widget.scrollController, 20)));
          //               });
          //             },
          //             child: Container(
          //                 alignment: Alignment.bottomCenter,
          //                 width: MediaQuery.of(context).size.width * 0.30,
          //                 height: MediaQuery.of(context).size.width * 0.30,
          //                 child: Padding(
          //                   padding: const EdgeInsets.only(
          //                       left: 8.0, right: 8.0, bottom: 8.0),
          //                   child: Column(
          //                     children: [
          //                       Container(
          //                         width:
          //                             MediaQuery.of(context).size.width * 0.20,
          //                         height:
          //                             MediaQuery.of(context).size.width * 0.18,
          //                         decoration: BoxDecoration(
          //                           image: DecorationImage(
          //                               image: CachedNetworkImageProvider(
          //                                   getallgallary[11]["logo"]),
          //                               fit: BoxFit.cover),
          //                         ),
          //                       ),
          //                       SizedBox(height: 10),
          //                       Text(getallgallary[11]["title"].toString()),
          //                     ],
          //                   ),
          //                 ),
          //                 decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   boxShadow: [
          //                     BoxShadow(
          //                         offset: Offset(3, 3),
          //                         color: Colors.black12,
          //                         spreadRadius: 0.05)
          //                   ],
          //                 )),
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // ),
        ),
      ),
    );
  }
}
