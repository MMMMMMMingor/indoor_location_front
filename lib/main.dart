import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'pages/tabs.dart';
import 'pages/Go.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: MyPage(),
      routes: {
      '/Go':(context)=>Go()
      },
    );
  }
}
