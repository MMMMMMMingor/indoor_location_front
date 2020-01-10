import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';
import 'pages/tabs.dart';
import 'pages/Go.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  final routes= {
    '/Go': (context) => Go(),

    // '/search':(context,{arguments})=>SearchPage(arguments:arguments),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: MyPage(),
       onGenerateRoute :(RouteSettings settings) {
      // 统一处理
      final String name = settings.name;
      final Function pageContentBuilder = routes[name];
      if (pageContentBuilder != null) {
        if (settings.arguments != null) {
          final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context, arguments: settings.arguments));
          return route;
        }else{
          final Route route = MaterialPageRoute(
              builder: (context) =>
                  pageContentBuilder(context));
          return route;
        }
      }return null;
    }

    );
  }
}
