import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:localstorage/localstorage.dart';
import 'package:toast/toast.dart';

bool isLoadingAnya = true;
int dark = 0;
bool automatic = false;
int selected = 1;
bool firstTime = true;
int stChange = 0;
int trendingChange = 1;
int trendingNewChange = 1;
int meraSheherChange = 1;
String firstDistrictName = "";
int fromHomemeraSheherChange = 0;
int stateChangeForMeraSheher = 0;
int firstTimeLoadAds = 1;
bool isLoading = false;
bool loading = false;
String newsLoaded = '';
List addedDistrict = [];
List tempDistrict = [];
bool sliding = false;
Map scrollingDistrict = {};
int time = 180;
String apnadistict = '';
int prevCount = 0;
int currCount = 0;
bool flag = true;

class Favourite {
  dynamic data;
  String id;

  Favourite({required this.data, required this.id});

  toJSONEncodable() {
    Map<String, dynamic> m = {};

    m['data'] = data;
    m['id'] = id;

    return m;
  }
}

int numberOfStates = 0;
//
final LocalStorage storage = LocalStorage('favourite_news');

class FavouriteList {
  List<Favourite> items = [];

  toJSONEncodable() {
    return items.map((item) {
      return item.toJSONEncodable();
    }).toList();
  }
}

FavouriteList list = FavouriteList();

int? sid;
List cat = [10, 23, 24, 26, 28, 29, 25, 27];
List<Widget> favourites = [];
String fileName = 'state_id.txt';
String mode = 'color_id.txt';
putColor(color) async {
  var dir = await getTemporaryDirectory();
  File file = File(dir.path + "/" + mode);
  file.writeAsStringSync(color, flush: true, mode: FileMode.write);
}

Future<String> getColor() async {
  var dir = await getTemporaryDirectory();
  File file = File(dir.path + "/" + mode);
  if (file.existsSync()) {
    final data = file.readAsStringSync();
    return data;
  } else {
    return "0";
  }
}

getStateId(int id) {
  sid = id;
}

putData(stateId) async {
  var dir = await getTemporaryDirectory();
  File file = File(dir.path + "/" + fileName);
  file.writeAsStringSync(stateId, flush: true, mode: FileMode.write);
}

int states = 0;
List si = [];
Future<String> getData() async {
  var dir = await getTemporaryDirectory();
  File file = File(dir.path + "/" + fileName);
  if (file.existsSync()) {
    final data = file.readAsStringSync();
    return data;
  } else {
    return "0";
  }
}

List<dynamic> readNews = [];

var getallgallary;
Future<bool> getgallary(context) async {
  String fileName = 'getGalleryData.json';

  var dir = await getTemporaryDirectory();
  File file = File(dir.path + "/" + fileName);

  try {
    var request = http.Request(
        'GET', Uri.parse('https://ingnewsbank.com/api/get_news_gallery'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();
      file.writeAsStringSync(responseString, flush: true, mode: FileMode.write);
      // print(responseString);
      var decode = jsonDecode(responseString);
      getallgallary = decode;
      print(getallgallary.length.toString());
      print("gallary");
    } else {
      var responseString = await response.stream.bytesToString();
      print("gallary");
      print(responseString);
    }
  } on SocketException catch (_) {
    Toast.show("आपका इंटरनेट बंद है |", context);
    if (file.existsSync()) {
      var data = file.readAsStringSync();
      var decode = jsonDecode(data);
      if (decode.length == 0) {
        return false;
      }
      getallgallary = decode;
    }
  }
  return true;
}
