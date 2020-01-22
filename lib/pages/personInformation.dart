import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import './modifyInformation.dart';
import 'package:http/http.dart' as http;
import '../conf/Config.dart' as Config;
import '../model/user.dart';
import 'dart:io';

class PersonInformation extends StatefulWidget {
  @override
  PinforState createState() => PinforState();
}

class PinforState extends State<PersonInformation> {
  void getInfo() async {
    // 尝试获取本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    // 若 token存在
    if (token != null) {
      var response = await http.get(Config.url + "api/user/info",
          headers: {"Authorization": "Bearer $token"});
      print(response.body);
    } else {
      Toast.show("请先登录", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);

      
    }
  }

  @override
  void initState() {
    //页面初始化
    super.initState();
    getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('个人信息'),
        ),
        body: new Column(children: <Widget>[
          new SizedBox(
              height: 150.0,
              child: Center(
                child: new ClipOval(
                  child: new SizedBox(
                    width: 120,
                    height: 120,
                    child: User.instance.url == 'images/head_portraits.jpg'
                        ? Image.asset(
                            User.instance.url,
                            fit: BoxFit.fill,
                          )
                        : Image.file(File(User.instance.url), fit: BoxFit.fill),
                  ),
                ),
              )),
          ListTile(title: Text('昵称  ' + User.instance.name)),
          ListTile(title: Text('性别  ' + User.instance.sex)),
          ListTile(title: Text('年龄  ' + User.instance.age.toString())),
          ListTile(title: Text('职业  ' + User.instance.job)),
          ListTile(title: Text('个人标签  ' + User.instance.notation)),
          new Container(
            width: 260,
            height: 50,
            child: new CupertinoButton(
              child: Text('点击修改'),
              color: Colors.blue,
              disabledColor: Colors.blue,
              onPressed: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => new ModifyInformation()));
              },
            ),
          )
        ]));
  }
}
