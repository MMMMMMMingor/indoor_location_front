import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:my_flutter_app1/model/APMeta.dart';
import 'package:my_flutter_app1/pages/login.dart';
import 'pages/tabs.dart';
import 'pages/Go.dart';
import 'pages/search_result.dart';
import 'pages/CollectFingerPrint.dart';
import 'pages/createLocationService.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = {
    '/Go': (context) => Go(),
    '/Search_result': (context) => Search_result(),
    '/collect': (context, {APMeta arguments}) => CollectFingerPrint(arguments: arguments),
    '/login': (context) => LoginPage(),
    '/tab': (context) => MyPage(),
    '/createLocationService': (context) => CreateLocationService(),
    // '/friendTab': (context) => friendTab(),
    // '/search':(context,{arguments})=>SearchPage(arguments:arguments),//传参数的
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData.light(),
        home: MyPage(),
        onGenerateRoute: (RouteSettings settings) {
          // 统一处理
          final String name = settings.name;
          final Function pageContentBuilder = routes[name];
          if (pageContentBuilder != null) {
            if (settings.arguments != null) {
              final Route route = MaterialPageRoute(
                  builder: (context) => pageContentBuilder(context,
                      arguments: settings.arguments));
              return route;
            } else {
              final Route route = MaterialPageRoute(
                  builder: (context) => pageContentBuilder(context));
              return route;
            }
          }
          return null;
        });
  }
}
