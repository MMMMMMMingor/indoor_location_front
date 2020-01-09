import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'tabs/home.dart';
import 'tabs/mine.dart';
import 'tabs/search.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  int _currentIndex = 0;
  List _pageList = [
    HomePage(),
    SearchPage(),
    MinePage(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: this._pageList[this._currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
          });
        },
        currentIndex: this._currentIndex,
        backgroundColor: CupertinoColors.lightBackgroundGray,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search),
            title: Text('发现'),
          ),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.person_solid), title: Text('我的'))
        ],
      ),
    );
  }
}
