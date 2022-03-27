import 'dart:convert';
import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:news/dynamic_link.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/news_details/webiew.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Map<String, dynamic>> list = [];
  String text = "";
  int a = 0;
  ScrollController sc = ScrollController();
  TextEditingController _textController = new TextEditingController();
  var skip = 1;
  getData(keyword) async {
    setState(() {
      skip = 1;

      list.clear();
    });
    print("Key WOrddd" + keyword.toString());
    var url = Uri.parse(
        "https://ingnewsbank.com/api/get_news_by_keyword?skip=0&take=40&keyword=$keyword");
    var res = await http.get(url);
    var jsonRes = jsonDecode("[" + res.body + "]");
    List listLength = jsonRes[0]['news'];
    int l = listLength.length;
    print('length is $l');
    for (int i = 0; i < l; i++) {
      try {
        list.add({
          "image": jsonRes[0]["news"][i]["main_image_thumb"],
          "title": jsonRes[0]["news"][i]["title"],
          "url": jsonRes[0]["news"][i]["imported_news_url"],
          "source": jsonRes[0]["news"][i]["source_website"],
          "time": jsonRes[0]["news"][i]["imported_date"]
        });
      } catch (e) {}
    }
    setState(() {
      // skip = skip + 40;
      //  skip=skip+1;
      a = 0;
    });
  }

  Future<void> getMoreData(keyword) async {
    print("get more data");
    print("skip" + skip.toString());

    var url = Uri.parse(
        'https://ingnewsbank.com/api/get_news_by_keyword?skip=$skip&take=40&keyword=$keyword');

    var res = await http.get(url);
    try {
      print(res.statusCode);
      var jsonRes = jsonDecode("[" + res.body + "]");
      print(jsonRes.toString());
      List listLength = jsonRes[0]['news'];
      int l = listLength.length;
      print('length is $l');
      final List<Map<String, dynamic>> temp = [];
      for (int i = 0; i < l; i++) {
        temp.add({
          "image": jsonRes[0]["news"][i]["main_image_thumb"],
          "title": jsonRes[0]["news"][i]["title"],
          "url": jsonRes[0]["news"][i]["imported_news_url"],
          "source": jsonRes[0]["news"][i]["source_website"],
          "time": jsonRes[0]["news"][i]["imported_date"]
        });
      }
      setState(() {
        list.addAll(temp);
      });
      // take = take + 25;

    } catch (e) {
      print(e);
    }

    setState(() {
      a = 0;
      skip++;
    });
  }

  @override
  void initState() {
    sc.addListener(() {
      if (sc.position.pixels >
              sc.position.maxScrollExtent / 1.100000000000000001 &&
          sc.position.pixels == sc.position.maxScrollExtent) {
        print('need more data');
        getMoreData(_textController.text);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    var height = mq.height;
    var width = mq.width;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: AppBar(
            backgroundColor: dark == 0 ? Colors.blue[900] : Colors.black12,
            title: Text(
              "समाचार खोजें",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        backgroundColor: dark == 0 ? Color(0xffF8F8F8) : Colors.black,
        body: RefreshIndicator(
          onRefresh: () async {
            getData(_textController.text);
            setState(() {});
          },
          child: Column(
            children: [
              dark == 0
                  ? Divider(thickness: 1, color: Colors.blue[900])
                  : Container(
                      height: 1.0,
                      width: MediaQuery.of(context).size.width * 1,
                      color: dark == 0 ? Colors.blue[900]! : Colors.white),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: dark == 0 ? Colors.blue : Colors.white),
                  height: 50,
                  width: double.infinity,
                  child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Stack(
                        children: [
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: TextField(
                                controller: _textController,
                                onChanged: (value) {
                                  setState(() {
                                    a = 1;
                                  });
                                  getData(_textController.text);
                                },
                                onSubmitted: (s) {
                                  setState(() {
                                    a = 1;
                                  });
                                  getData(_textController.text);
                                },
                                textInputAction: TextInputAction.search,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "शब्द टाइप करें"),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 2,
                              right: 6,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 2, right: 4),
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      color: dark == 0
                                          ? Colors.white
                                          : Colors.black),
                                  child: IconButton(
                                    icon: Icon(Icons.search,
                                        color: dark == 0
                                            ? Colors.black
                                            : Colors.white),
                                    onPressed: () {
                                      setState(() {
                                        a = 1;
                                      });
                                      getData(text);
                                    },
                                  ),
                                ),
                              ))
                        ],
                      )),
                ),
              ),
              a == 1
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: list.length > 0
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3, horizontal: 5),
                              child: newsWidget(list, height, width),
                            )
                          : Text(
                              'No results found',
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget newsWidget(list, height, width) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
      controller: sc,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, int index) {
        return Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 2),
          child: InkWell(
            onTap: () {
              final dataNews = {
                "newsTitle": list[index]['title'],
                "newsURL": list[index]['url'],
                "data": list[index]
              };
              Get.to(WebviewScreen(), arguments: dataNews);
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (context) => WebviewScreen(
              //               newsTitle: list[index]['title'],
              //               newsURL: list[index]['url'],
              //               data: list[index],
              //             )));
            },
            child: Container(
              height: 80,
              //height * 0.10,
              width: width,
              decoration: BoxDecoration(
                  color: dark == 0 ? Colors.green[50] : Colors.white10,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                        offset: Offset(3, 3),
                        color: Colors.black12,
                        spreadRadius: 0.05)
                  ]),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: AutoSizeText(
                              list[index]['title'].toString().length > 115
                                  ? list[index]['title']
                                          .toString()
                                          .substring(0, 115) +
                                      ".."
                                  : list[index]['title'].toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: dark == 0 ? Colors.black : Colors.white,
                              ),
                              textScaleFactor: 1.0,
                              maxLines: 3,
                              minFontSize: 15,
                              maxFontSize: 29,
                            ),
                          ),
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 8,
                                ),
                                Expanded(
                                  child: RichText(
                                    textScaleFactor: 1.0,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      text: list[index]['source'].toString(),
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
                                                color: dark == 0
                                                    ? Colors.black
                                                    : Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        TextSpan(
                                            text:
                                                list[index]['time'].toString(),
                                            style:
                                                TextStyle(color: Colors.blue))
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                    onTap: () async {
                                      final tempMap = list[index];

                                      tempMap['main_image_cropped'] = '';

                                      final dataNews = {
                                        "newsTitle": list[index]['title'],
                                        "newsURL": list[index]['url'],
                                        "data": tempMap
                                      };
                                      String url = '';
                                      await generateUrl(dataNews)
                                          .then((value) => {
                                                url = value,
                                              });
                                      final title =
                                          "🇮🇳 अब एक ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳\n" +
                                              Uri.parse(url).toString();
                                      FlutterShare.share(
                                          title: "Title", text: title);
                                      // FlutterShare.share(
                                      //     linkUrl: url,
                                      //     title: "Title",
                                      //     text:
                                      //         "🇮🇳 अब  ही📱ऍप में पाऐं सभी प्रमुख अखबारों, पोर्टलों के समाचार हिंदी में। अभी डाउनलोड करें 👇🇮🇳                                            " +
                                      //             list[index]['title'],
                                      //     chooserTitle:
                                      //         "इस खबर को शेयर करो...");
                                    },
                                    child: Icon(
                                      Icons.share,
                                      size: 17,
                                      color: Colors.red,
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
      },
    );
  }
}


 //  ListView.builder(
                              //   controller: sc,
                              //   itemCount: list.length,
                              //   itemBuilder: (context, index) => SizedBox(
                              //     height: 106,
                              //     child:,
                                  // Card(
                                  //   color: Colors.white,
                                  //   elevation: 4,
                                  //   margin: EdgeInsets.symmetric(vertical: 5),
                                  //   child: Column(
                                  //     textBaseline: TextBaseline.alphabetic,
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.spaceBetween,
                                  //     children: [
                                  //       ListTile(
                                  //           onTap: () {
                                  //             Navigator.push(
                                  //                 context,
                                  //                 MaterialPageRoute(
                                  //                     builder: (context) =>
                                  //                         WebviewScreen(
                                  //                           newsTitle:
                                  //                               list[index]
                                  //                                   ['title'],
                                  //                           newsURL: list[index]
                                  //                               ['url'],
                                  //                           data: list[index],
                                  //                         )));
                                  //           },
                                  //           title: Text(
                                  //             list[index]['title']
                                  //                         .toString()
                                  //                         .length >
                                  //                     115
                                  //                 ? list[index]['title']
                                  //                         .toString()
                                  //                         .substring(0, 115) +
                                  //                     ".."
                                  //                 : list[index]['title']
                                  //                     .toString(),
                                  //             style: TextStyle(
                                  //                 fontWeight: FontWeight.w600),
                                  //           ),

                                  //           // subtitle: Expanded(
                                  //           //   child: Text(
                                  //           //     list[index]['source'].toString() +
                                  //           //         "    " +
                                  //           //         list[index]['time'],
                                  //           //   ),
                                  //           // ),
                                  //           trailing: Padding(
                                  //             padding: const EdgeInsets.only(
                                  //                 top: 34),
                                  //             child: InkWell(
                                  //                 onTap: () {
                                  //                   FlutterShare.share(
                                  //                       title: "Title",
                                  //                       text: list[index]
                                  //                           ['title'],
                                  //                       chooserTitle:
                                  //                           "इस खबर को शेयर करो...");
                                  //                 },
                                  //                 child: Icon(Icons.share)),
                                  //           )),
                                  //       Padding(
                                  //         padding: const EdgeInsets.only(
                                  //             left: 14, bottom: 3),
                                  //         child: Text(
                                  //           list[index]['source'].toString() +
                                  //               "    " +
                                  //               list[index]['time'],
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                //   ),
                                // ),






// GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (context) =>
//                                                   WebviewScreen(
//                                                       newsTitle: list[index]
//                                                           ['title'],
//                                                       newsURL: list[index]
//                                                           ['url'])));
//                                 },
//                                 child: Container(
//                                   height:80, 
//                                   //height * 0.10,
//                                   width: width,
//                                   decoration: BoxDecoration(
//                                       color: Colors.green[50],
//                                       borderRadius: BorderRadius.circular(5),
//                                       boxShadow: [
//                                         BoxShadow(
//                                             offset: Offset(3, 3),
//                                             color: Colors.black12,
//                                             spreadRadius: 0.05)
//                                       ]),
//                                   child: Row(
//                                     children: [
//                                       list[index]["image"] ==
//                                               null
//                                           ? SizedBox()
//                                           : Container(
//                                               height: height * 0.18,
//                                               width: width * 0.4,
//                                               decoration: BoxDecoration(
//                                                   image: DecorationImage(
//                                                       image: CachedNetworkImageProvider(
//                                                           list[index][
//                                                               "image"].toString()),
//                                                       fit: BoxFit.cover)),
//                                             ),
//                                       SizedBox(width: 2),
//                                       Expanded(
//                                         child: Padding(
//                                           padding:
//                                               const EdgeInsets.only(top: 5),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceBetween,
//                                             children: [
//                                               AutoSizeText(
//                                                list[index]['title'].toString().length>68?
//                                       list[index]['title'].toString().substring(0,68)+"..."
//                                       :list[index]['title'].toString(),
//                                                 style: TextStyle(
//                                                     fontWeight:
//                                                         FontWeight.bold), textScaleFactor: 1.0,
//                                                 maxLines: 3,
//                                                 minFontSize: 15,
//                                                 maxFontSize: 29,
//                                               ),
//                                               // heading(
//                                               //     text: homeNewsData[index]
//                                               //         ["news"][index2]["title"],
//                                               //     maxLines: 3,
//                                               //     scale: 1.25,
//                                               //     weight: FontWeight.w800,
//                                               //     align: TextAlign.left),

//                                               Flexible(
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceBetween,
//                                                   crossAxisAlignment:
//                                                       CrossAxisAlignment.center,
//                                                   children: [
//                                                     Expanded(
//                                                       child: new Container(
//                                                           padding:
//                                                               new EdgeInsets
//                                                                       .only(
//                                                                   right: 13.0),
//                                                           child: RichText( textScaleFactor: 1.0,
//                                                             overflow:
//                                                                 TextOverflow
//                                                                     .ellipsis,
//                                                             text: TextSpan(
//                                                               text: list[index]['source'].toString(),
//                                                               style: TextStyle(
//                                                                   fontSize: 11,
//                                                                   color: Colors
//                                                                       .black54),
//                                                               children: <
//                                                                   TextSpan>[
//                                                                 TextSpan(
//                                                                     text: ' | ',
//                                                                     style: TextStyle(
//                                                                         fontWeight:
//                                                                             FontWeight.bold)),
//                                                                 TextSpan(
//                                                                     text: list[index]['time']
//                                                                         .toString(),
//                                                                     style: TextStyle(
//                                                                         color: Colors
//                                                                             .blue))
//                                                               ],
//                                                             ),
//                                                           )),
//                                                     ),
//                                                     GestureDetector(
//                                                       onTap: () {
//                                                         FlutterShare.share(
//                                                 title: "Title",
//                                                 text: list[index]['title'],
//                                                 chooserTitle:
//                                                     "इस खबर को शेयर करो...");
//                                                       },
//                                                       child: Icon(
//                                                         Icons.share,
//                                                         size: height * 0.02,
//                                                         color: Colors.red,
//                                                       ),
//                                                     )
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),