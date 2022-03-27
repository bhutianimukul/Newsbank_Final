import 'package:flutter/material.dart';

class Internet extends StatelessWidget {
  const Internet({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
body:Container(
  child:Column(
    mainAxisAlignment:MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
Icon(Icons.wifi_off,size: 100,),
Center(child: Text("कोई इंटरनेट कनेक्शन नहीं",style: TextStyle(color: Colors.black,fontSize: 20),)),
SizedBox(height:20),
  Center(child: Text("कृपया अपने इंटरनेट की जांच करे और फिर से प्रयास करें पुन: प्रयास करें",style: TextStyle(color: Colors.black,fontSize: 12),))
  ],)
)      
    );
  }
}