import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyCar extends StatefulWidget {
  @override
  MyCarState createState() => MyCarState();

}

class MyCarState extends State<MyCar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('我的车辆'),),
      body: new ListView(
          children: <Widget>[
            new SizedBox(
              height: ScreenUtil().setHeight(500),
              child:  new Image.asset('images/head_portraits.jpg',fit: BoxFit.fill,),
            ),
            new SizedBox(
              height: ScreenUtil().setHeight(100),
            ),
            ListTile(
              title:new Row(
                children: <Widget>[
                  new Text('车牌号        ' + '粤A X1X15    ',
                    style: new TextStyle(fontSize: ScreenUtil().setSp(26.0)),),
                  new GestureDetector(
                      child: new Text('更改绑定',
                        style: new TextStyle(
                          fontSize: ScreenUtil().setSp(28.0),
                          color: Colors.blue,),
                      ),
                      onTap:() {
                        print('更改绑定');
                      }
                  )

                ],
              ),
            ),
            ListTile(
              title: new Row(
                children: <Widget>[
                  new Text(
                    '停车时间    ' + '00:52:30',
                    style: new TextStyle(fontSize: ScreenUtil().setSp(26.0)),
                  )
                ],
              ),
            ),
            ListTile(
              title: new Row(
                children: <Widget>[
                  new Text(
                    '状态            ' + '在库未缴费    ',
                    style: new TextStyle(fontSize: ScreenUtil().setSp(26.0)),
                  ),
                  new GestureDetector(
                      child:  new Text(
                        '在线缴费',
                        style: new TextStyle(
                          fontSize: ScreenUtil().setSp(28.0),
                          color: Colors.blue,),
                      ),
                      onTap:() {
                        print('在线缴费');
                      }
                  )

                ],
              ),
            ),
            ListTile(
              title: new Row(
                children: <Widget>[
                  new Text(
                    '应缴金额    ' + '10',
                    style: new TextStyle(fontSize: ScreenUtil().setSp(26.0)),
                  )
                ],
              ),
            )
          ]
      ),
    );
  }
}