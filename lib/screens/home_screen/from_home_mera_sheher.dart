import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:news/homePage.dart';
import 'package:news/provider/apna_sheher_provider.dart';
import 'package:news/provider/homePageIndex_provider.dart';
import 'package:news/provider/sheher_change_provider.dart';
import 'package:news/provider/string.dart';
import 'package:news/screens/home_screen/states_screen.dart';
import 'package:news/widgets/styles.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:translator/translator.dart';

import 'home_screen.dart';

class FromHomeMeraSheher extends StatefulWidget {
  const FromHomeMeraSheher({Key? key}) : super(key: key);

  @override
  _FromHomeMeraSheherState createState() => _FromHomeMeraSheherState();
}

class _FromHomeMeraSheherState extends State<FromHomeMeraSheher> {
  var districtData = [];
  String districtName = '';
  var toShow = [];
  var previousSelected;

  Future<List> getInfo() async {
    String fileName = 'all_districts.json';
    var dir = await getTemporaryDirectory();
    File file = File(dir.path + "/" + fileName);
    if (stChange == 1) fromHomemeraSheherChange = 1;
    if (file.existsSync() == true && stChange == 0) {
      final data = file.readAsStringSync();
      final res = jsonDecode(data);
      districtData = res;
      districtName = '';
    } else {
      final url =
          "https://ingnewsbank.com/api/get_districts?keyword=null&mode=choose&st_id=${HomeScreen.stId}";
      // print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
      final req = await http.get(Uri.parse(url));
      final body = req.body;
      file.writeAsStringSync(body, flush: true, mode: FileMode.write);
      final res = jsonDecode(body);
      // print(res);
      setState(() {
        districtData = res;
      });
    }

    if (fromHomemeraSheherChange == 0) {
      String fileName1 = 'district_scroll.json';
      var dir1 = await getTemporaryDirectory();
      File file1 = File(dir1.path + "/" + fileName1);
      final data = file1.readAsStringSync();
      final res = jsonDecode(data);
      districtName = res["district"]["title"];
      print('the district name is $districtName');
      setState(() {
        toShow = districtData;
      });
    } else {
      districtName = '';
      setState(() {
        toShow = districtData;
      });
    }
    previousSelected = districtName;
    // String fileName1 = 'district_scroll.json';
    // var dir1 = await getTemporaryDirectory();
    // File file1 = File(dir1.path + "/" + fileName1);
    // if(file1.existsSync())
    //   {
    //     var data=file1.readAsStringSync();
    //     scrollingDistrict=jsonDecode(data);
    //   }
    //
    // setState(() {
    //
    // });
    return districtData;
  }

  Color convertColor(String color) {
    String c1 = '0xFF';
    String c2 = color.substring(1);
    String c3 = c1 + c2;
    return Color(int.parse(c3));
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

  TextEditingController textController = TextEditingController();
  var currentSelectedDistrict = {};

  @override
  void initState() {
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
          backgroundColor: dark == 0 ? Colors.blue[900] : Colors.black,
          title: heading(text: 'अपना शहर', color: Colors.white),
          actions: [
            TextButton(
                onPressed: () async {
                  print("CLICKKKKEED");
                  String fileName = 'district_added.json';
                  var dir = await getTemporaryDirectory();
                  File file = File(dir.path + "/" + fileName);
                  if (file.existsSync()) {
                    final data = jsonDecode(file.readAsStringSync());
                    addedDistrict.clear();
                    addedDistrict = data;
                  }
                  String curDist = '';
                  if (addedDistrict.length != 0) {
                    addedDistrict.removeAt(0);
                  }
                  if (currentSelectedDistrict.isNotEmpty) {
                    await deleteCache('getAdNews1.json');
                    bool isExist = false;
                    int index = 0;
                    for (int i = 0; i < addedDistrict.length; i++) {
                      if (currentSelectedDistrict['did'].toString() ==
                          addedDistrict[i]['did'].toString()) {
                        addedDistrict.removeAt(i);
                        index = i;
                        isExist = true;
                      }
                    }
                    print('added from here');

                    if (addedDistrict.length == 0)
                      addedDistrict.add(currentSelectedDistrict);
                    else {
                      if (index != 0) addedDistrict.removeAt(0);
                      addedDistrict.insert(0, currentSelectedDistrict);
                    }
                  }

                  // firstTimeLoadAds=1;

                  // Navigator.pop(context,true);
                  // Provider.of<ApnaSheherIndexProvider>(
                  //     context,listen: false).changePage(0);

                  // HomeScreen().setDistrictName(addedDistrict[0]);
                  // firstDistrictName = addedDistrict[0].toString();
                  fileName = 'district_added.json';
                  dir = await getTemporaryDirectory();
                  file = File(dir.path + "/" + fileName);
                  file.writeAsStringSync(jsonEncode(addedDistrict),
                      flush: true, mode: FileMode.write);
                  var did = currentSelectedDistrict['did'];
                  final url =
                      "https://ingnewsbank.com/api/get_latest_news_by_district?page=1&did=$did";
                  // print("get home news reading from internet FILE EXIST and DATA is [] for anya rajgya");
                  final req = await http.get(Uri.parse(url));
                  final body = req.body;
                  scrollingDistrict = jsonDecode(body);
                  fileName = 'district_scroll.json';
                  dir = await getTemporaryDirectory();
                  file = File(dir.path + "/" + fileName);

                  setState(() {
                    apnadistict = districtName;
                    file.writeAsStringSync(jsonEncode(scrollingDistrict),
                        flush: true, mode: FileMode.write);
                  });
                  print("District" + districtName);
                  Provider.of<SheherChangeProvider>(context, listen: false)
                      .updateSheher(districtName);
                  Navigator.pop(context);
                  // Navigator.push(context,
                  //     MaterialPageRoute(builder: (context) => HomeScreen()));
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
                      'अपने पसंद के शहर की खबर पाने के लिए उस शहर पर क्लिक करें।',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    )),
              ),
              districtName != ''
                  ? Wrap(
                      children: [
                        ...List.generate(
                            1,
                            (index) => Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Chip(
                                    label: Text(districtName),
                                  ),
                                ))
                      ],
                    )
                  : SizedBox(),
              Padding(
                padding: EdgeInsets.fromLTRB(3, 2, 3, 0),
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
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                    mainAxisExtent: 60,
                                    maxCrossAxisExtent: 140,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 0),
                            itemCount: toShow.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 3),
                                child: GestureDetector(
                                  onTap: () async {
                                    currentSelectedDistrict = toShow[index];
                                    fromHomemeraSheherChange = 0;
                                    setState(() {
                                      districtName = toShow[index]['title'];
                                    });
                                    // var did = toShow[index]['did'];

                                    // addedDistrict.add(districtData[index]);
                                    // String fileName = 'district_added.json';
                                    // var dir = await getTemporaryDirectory();
                                    // File file = File(dir.path + "/" + fileName);
                                    // file.writeAsStringSync(jsonEncode(addedDistrict));
                                    // setState(() {
                                    //
                                    // });
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
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
