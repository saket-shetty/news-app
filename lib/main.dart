import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:scc/jsonData.dart';


void main() async {
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    new MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
      title: 'NEWS',
      color: Colors.deepPurpleAccent,
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int i = 0;

  List<jsonData> jsonallData = [];

  @override
  void initState() {




    FetchJSON();
    super.initState();
  }

  FetchJSON() async {
    var Response = await http.get(
        "https://newsapi.org/v2/top-headlines?sources=google-news,wired,the-washington-times&apiKey=931fc8dd717f4bc4a4219938f03a3273");

    if (Response.statusCode == 200) {
      String responseBody = Response.body;
      var responseJSON = json.decode(responseBody);
      var length = responseJSON['totalResults'];
      print('length :$length');
      if (length >= 21) {
        length = 20;
      }
      for (var x = 0; x < length; x++) {
        if (responseJSON['articles'][x]['urlToImage'] != null &&
            responseJSON['articles'][x]['title'] != null &&
            responseJSON['articles'][x]['description'] != null) {
          jsonData jd = new jsonData(
              responseJSON['articles'][x]['urlToImage'],
              responseJSON['articles'][x]['title'],
              responseJSON['articles'][x]['description']);
          jsonallData.add(jd);
        }
      }
      setState(() {});
    } else {
      print('Something went wrong. \nResponse Code : ${Response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        title: new Text(
          'NEWS',
          style: new TextStyle(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: Padding(
        padding: new EdgeInsets.only(top: 0),
        child: Container(
          child: jsonallData.length == 0
              ? new Center(
                  child: new Text('Wait a minute'),
                )
              : new Card(
                  child: InkWell(
                    onDoubleTap: () {
                      i = i + 1;
                      print('Tap :$i');
                      if (i == jsonallData.length) {
                        i = 0;
                      }

                      setState(() {});
                    },
                    onLongPress: () {
                      if (i == 0) {
                        i = jsonallData.length;
                      }
                      i = i - 1;
                      setState(() {});
                    },
                    child: new Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            height: 250,
                            child: new Image(
                              image: NetworkImage('${jsonallData[i].imgurl}'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: new Text(
                              '${jsonallData[i].title}',
                              style: new TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.all(03.0),
                          ),
                          new Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: new Text(
                                '${jsonallData[i].description}',
                                style: new TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                          new Padding(
                            padding: new EdgeInsets.only(bottom: 10.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
