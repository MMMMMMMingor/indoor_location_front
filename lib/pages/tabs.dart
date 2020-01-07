import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'tabs/home.dart';
import 'tabs/mine.dart';
import 'tabs/search.dart';

class MyPage extends StatefulWidget{
  @override
  _MyPageState createState()=>_MyPageState();
}

class _MyPageState extends State<MyPage>{
  @override
  Widget build(BuildContext context){

    return CupertinoTabScaffold(

        tabBar: CupertinoTabBar(
          border:  Border.all(
              color: Colors.white70,
              width: 4,

          ),

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
                title: Text('我的')
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