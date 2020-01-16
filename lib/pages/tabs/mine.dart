
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../personInformation.dart';
import '../register.dart';
import '../../model/user.dart';
import 'dart:io';
import '../friendTab.dart';
import '../myCar.dart';

class MinePage extends StatefulWidget{

  @override
  _MinePageState createState()=>new _MinePageState();

}

class _MinePageState extends State<MinePage>{
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
                    onTap: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context)=>new MyCar()));
                      //跳转到我的车辆界面
                    },
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
                    onTap: (){
                      Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context)=>new friendTab()));
                          //跳转到好友列表界面
                             },
                    leading: new Icon(
                      Icons.people_outline,
                      color:Colors.lightBlue,
                    ),
                  ),

                ]
            )
        )
    );
    return Scaffold(
      body: Container(
        child:ListView(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:CrossAxisAlignment.center,
              children: <Widget>[
                new GestureDetector(
                    child:new ClipOval(
                      child: new SizedBox(
                        width: 120,
                        height: 120,
                        child: User.instance.url=='images/head_portraits.jpg'?Image.asset(User.instance.url,fit: BoxFit.fill,)
                            :Image.file(File(User.instance.url),fit: BoxFit.fill),
                      ),
                    ),
                    onTap:() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context)=>new PersonInformation()));
                    }
                ),
                new GestureDetector(
                    child: new Text(
                      '  点击登录',
                      style: new TextStyle(
                          color: Colors.grey
                      ),
                    ),
                    onTap:() {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context)=>new RegisterPage()));
                    }
                )
              ],
            ),
            card,
          ],
        )
        ),
    );
  }
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    setState(() {

    });
  }

}


