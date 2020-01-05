
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
                    title:new Text('我的店铺1',
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


