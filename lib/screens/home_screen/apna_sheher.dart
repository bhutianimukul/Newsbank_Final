import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:news/homePage.dart';
import 'package:news/provider/apna_sheher_provider.dart';
import 'package:news/provider/homePageIndex_provider.dart';
import 'package:news/provider/sheher_change_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/widgets/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';
import 'home_screen.dart';
import 'mera_sheher.dart';

class ApnaSheher extends StatefulWidget {
  const ApnaSheher({Key? key}) : super(key: key);

  @override
  _ApnaSheherState createState() => _ApnaSheherState();
}

class _ApnaSheherState extends State<ApnaSheher> {
  var toShow = [];
  var districtData = [];

  Future<List> getInfo() async {
    String fileName = 'all_districts.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);

    if (file.existsSync() && stChange == 0) {
      print('error 100');
      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      districtData = res;
    } else {
      print(HomeScreen.stId);
      print('error 101');
      final url =
          "https://ingnewsbank.com/api/get_districts?keyword=null&mode=choose&st_id=${HomeScreen.stId}";
      // print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
      final req = await http.get(Uri.parse(url));
      final body = req.body;
      file.writeAsStringSync(body, flush: true, mode: FileMode.write);
      final res = jsonDecode(body) as List;
      // print(res);
      districtData = res;
    }
    setState(() {
      toShow = districtData;
    });
    stChange = 0;
    return districtData;
  }

  Color convertColor(String color) {
    String c1 = '0xFF';
    String c2 = color.substring(1);
    String c3 = c1 + c2;
    return Color(int.parse(c3));
  }

  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  Future<void> searchQuery(String text) async {
    print('this is the text $text');

    final translator = GoogleTranslator();
    // final input = text;
    //
    // translator.translate(input, from: 'hi', to: 'en').then(print);
    Translation translation = await translator.translate(text);
    var lanCode = translation.sourceLanguage.code;
    print("Language Code: $lanCode");

    if (lanCode == 'hi') {
      toShow = districtData
          .where((element) => element['title'].startsWith(text))
          .toList();
      for (int i = 0; i < toShow.length; i++) {
        print(toShow[i]['title_in_english']);
      }
    } else {
      toShow = districtData
          .where((element) => element['title_in_english'].startsWith(text))
          .toList();
      for (int i = 0; i < toShow.length; i++) {
        print(toShow[i]['title_in_english']);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
                Provider.of<ApnaSheherIndexProvider>(context, listen: false)
                    .changePage(0);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: dark == 0 ? Colors.blue[900] : Colors.black,
          title: heading(text: 'मेरा शहर', color: Colors.white),
          actions: [
            TextButton(
                onPressed: () async {
                  addedDistrict.clear();
                  for (final str in tempDistrict) {
                    addedDistrict.add(str);
                  }
                  String fileName = 'district_added.json';
                  var dir = await getTemporaryDirectory();
                  File file = File(dir.path + "/" + fileName);
                  file.writeAsStringSync(jsonEncode(tempDistrict),
                      flush: true, mode: FileMode.write);
                  Navigator.pop(context, true);
                  Provider.of<ApnaSheherIndexProvider>(context, listen: false)
                      .changePage(0);
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 17),
                ))
          ],
        ),
        body: Container(
          color: dark == 0 ? Colors.white : Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment(-1, 0),
                child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                    child: Text(
                      ' अपने पसंद के शहरों की खबरें पाने के लिए उन शहरों पर क्लिक करें।',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    )),
              ),
              Wrap(
                spacing: 0,
                children: [
                  ...List.generate(
                      tempDistrict.length,
                      (index) => Container(
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 0),
                              child: Chip(
                                onDeleted: index == 0
                                    ? null
                                    : () async {
                                        tempDistrict.removeAt(index);

                                        setState(() {});
                                      },
                                deleteIconColor:
                                    index == 0 ? null : Colors.black,
                                deleteIcon: index == 0
                                    ? null
                                    : Icon(
                                        Icons.clear,
                                        size: 15,
                                      ),
                                label: Text(tempDistrict[index]['title']),
                              ),
                            ),
                          ))
                ],
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(3, 5, 3, 0),
                child: TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) async {
                    if (value.isNotEmpty) {
                      await searchQuery(value);
                      setState(() {});
                    } else {
                      print('this is been printed');
                      setState(() {
                        toShow = districtData;
                      });
                    }
                  },
                  maxLines: null,
                  controller: textController,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'शहर/जिला सर्च करें।',
                    labelStyle:
                        TextStyle(color: Color(0xFF0D47A1), fontSize: 15),
                    hintText: '',
                    hintStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Color(0xFF303030),
                      fontSize: 14,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: dark != 0 ? Colors.white : Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF0D47A1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                  ),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF303030),
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
              toShow.isEmpty
                  ? SizedBox()
                  : Expanded(
                      child: SingleChildScrollView(
                        child: GridView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisExtent: 60,
                                    maxCrossAxisExtent: 140,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 2),
                            itemCount: toShow.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 3),
                                child: GestureDetector(
                                  onTap: () async {
                                    bool alreadyExist = false;
                                    for (int i = 0;
                                        i < tempDistrict.length;
                                        i++) {
                                      if (tempDistrict[i]['did'].toString() ==
                                          toShow[index]['did'].toString()) {
                                        alreadyExist = true;
                                      }
                                    }

                                    if (!alreadyExist) {
                                      print('this is $scrollingDistrict');
                                      tempDistrict.add(toShow[index]);
                                      // if (scrollingDistrict.isEmpty) {
                                      //   print('new scrolling added');
                                      //   final url =
                                      //       "https://ingnewsbank.com/api/get_latest_news_by_district?page=1&did=${toShow[index]['did']}";
                                      //   // print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
                                      //   final req =
                                      //       await http.get(Uri.parse(url));
                                      //   final body = req.body;
                                      //   scrollingDistrict = jsonDecode(body);
                                      //   String fileName =
                                      //       'district_scroll.json';
                                      //   var dir = await getTemporaryDirectory();
                                      //   File file =
                                      //       File(dir.path + "/" + fileName);
                                      //   file.writeAsStringSync(
                                      //       jsonEncode(scrollingDistrict));
                                      // }
                                      // fromHomemeraSheherChange = 0;
                                      setState(() {});
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: convertColor(
                                            toShow[index]['bg_color_code']),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                        child: Text(
                                      toShow[index]['title'].toString(),
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.white),
                                    )),
                                  ),
                                ),
                              );
                            }),
                      ),
                    )
              // FutureBuilder(
              //   future: getInfo(),
              //   builder: (context, AsyncSnapshot snapshot){
              //     if (snapshot.data==null)
              //     {
              //       return Center(child: CircularProgressIndicator());
              //     }
              //     else
              //     {
              //       // return ListView.builder(
              //       //   shrinkWrap: true,
              //       //   physics: ClampingScrollPhysics(),
              //       //   scrollDirection:Axis.vertical,
              //       //   itemCount:toShow.length,
              //       //   itemBuilder: (context,index)
              //       //   {
              //       //     return Container(
              //       //       color: convertColor(toShow[index]['bg_color_code']),
              //       //       child: Text(toShow[index]['did'].toString()),
              //       //     );
              //       //   },
              //       // );
              //       return GridView.builder(
              //           shrinkWrap: true,
              //           physics: ClampingScrollPhysics(),
              //           gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              //
              //               maxCrossAxisExtent: 140,
              //               childAspectRatio: 3 / 2,
              //               crossAxisSpacing: 5,
              //               mainAxisSpacing: 0),
              //           itemCount: toShow.length,
              //           itemBuilder: (context, index) {
              //             return Padding(
              //               padding: EdgeInsets.symmetric(vertical: 5,horizontal: 3),
              //               child: GestureDetector(
              //                 onTap: () async
              //                 {
              //                   addedDistrict.add(toShow[index]);
              //                   String fileName = 'district_added.json';
              //                   var dir = await getTemporaryDirectory();
              //                   File file = File(dir.path + "/" + fileName);
              //                   file.writeAsStringSync(jsonEncode(addedDistrict));
              //                   setState(() {
              //
              //                   });
              //                 },
              //                 child: Container(
              //                   decoration: BoxDecoration(
              //                       color: convertColor(toShow[index]['bg_color_code']),
              //                       borderRadius: BorderRadius.circular(10)
              //                   ),
              //                   child: Center(child:
              //                   Text(toShow[index]['title_in_english'].toString(),
              //                     style: TextStyle(
              //                       fontSize: 16,
              //                         color: Colors.white
              //                     ),
              //                   )),
              //                 ),
              //               ),
              //             );
              //           });
              //     }
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
