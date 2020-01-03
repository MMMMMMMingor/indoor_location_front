import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:io';

void main()=>runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title:"Cupertino导航组件集",
      theme:ThemeData.light(),
      home:MyPage(),
    );
  }
}

class MyPage extends StatefulWidget{
  @override
  _MyPageState createState()=>_MyPageState();
}

class _MyPageState extends State<MyPage>{
  @override
  Widget build(BuildContext context){
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        backgroundColor: CupertinoColors.lightBackgroundGray,
        items:[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            title: Text('发现'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_solid),
            title: Text('我的'),
          )
          ]
      ),
      tabBuilder: (context,index){
        return CupertinoTabView(
          builder: (context){
            switch(index){
              case 0:
                return HomePage();
                break;
              case 1:
                return SearchPage();
                break;
              case 2:
                return MinePage();
              default:
                return Container();
            }
          },
        );
      }
    );
  }
}

class HomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
        child:Center(
            child:Text('首页',
              style: Theme.of(context).textTheme.button,)
        )
    );

  }
}

class SearchPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return CupertinoPageScaffold(
        child:Center(
            child:Text('发现',
              style: Theme.of(context).textTheme.button,)
        )
    );
  }
}

class MinePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    var card =new SizedBox(
        height: 360.0,
        child: new Card(
            child: new Column(
                children:<Widget>[
                  new ListTile(
                    title:new Text('收藏',
                      style: new TextStyle(fontWeight: FontWeight.w300),
                    ),
                    leading: new Icon(
                      Icons.star_border,
                      color:Colors.lightBlue,
                    ),
                  ),
                  new Divider(),
                  new ListTile(
                    title:new Text('我的车辆',
                      style: new TextStyle(fontWeight: FontWeight.w300),
                    ),
                    leading: new Icon(
                      Icons.directions_car,
                      color:Colors.lightBlue,
                    ),
                  ),
                  new Divider(),
                  new ListTile(
                    title:new Text('我的店铺',
                      style: new TextStyle(fontWeight: FontWeight.w300),
                    ),
                    leading: new Icon(
                      Icons.shopping_cart,
                      color:Colors.lightBlue,
                    ),
                  ),
                  new Divider(),
                  new ListTile(
                    title:new Text('消息',
                      style: new TextStyle(fontWeight: FontWeight.w300),
                    ),
                    leading: new Icon(
                      Icons.message,
                      color:Colors.lightBlue,
                    ),
                  ),
                  new Divider(),
                  new ListTile(
                    title:new Text('好友',
                      style: new TextStyle(fontWeight: FontWeight.w300),
                    ),
                    leading: new Icon(
                      Icons.people_outline,
                      color:Colors.lightBlue,
                    ),
                  ),
                ]
            )
        )
    );
    return CupertinoPageScaffold(
        child:ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: 5.0,
                  height: 55.0,
                ),
                new CircleAvatar(
                  radius:50.0,
                  backgroundImage: new AssetImage("images/head_portraits.jpg"),
                ),
              ],
            ),
            card,
          ],
        )
    );
  }
}




