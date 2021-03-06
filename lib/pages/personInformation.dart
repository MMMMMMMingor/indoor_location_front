import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_flutter_app1/model/userInfo.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import './modifyInformation.dart';
import 'package:http/http.dart' as http;
import '../conf/Config.dart' as Config;

class PersonInformation extends StatefulWidget {
  @override
  PinforState createState() => PinforState();
}

class PinforState extends State<PersonInformation> {
  // 默认用户信息
  UserInfo _userInfo = UserInfo(
      userId: '',
      nickname: '',
      gender: '',
      age: 18,
      vocation: '',
      personLabel: '',
      avatarUrl: '');

  void getUserInfo() async {
    // 获取token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    // 若 token存在
    if (token != null) {
      // 获取用户信息
      var response = await http.get(Config.url + "api/user/info",
          headers: {"Authorization": "Bearer $token"});

      UserInfo info = UserInfo.fromJson(utf8JsonDecode(response.bodyBytes));
      print(info.toJson());
      this.setState(() {
        this._userInfo = info;
      });
    } else {
      Toast.show("请先登录", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
      Navigator.popAndPushNamed(context, "/login");
    }
  }

  @override
  void initState() {
    //页面初始化
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text('个人信息'),
        ),
        body: new Column(children: <Widget>[
          new SizedBox(
              height: ScreenUtil().setHeight(200),
              child: Center(
                child: new ClipOval(
                  child: new SizedBox(
                    width: ScreenUtil().setWidth(200),
                    height: ScreenUtil().setHeight(200),
                    child: this._userInfo.avatarUrl == ''
                        ? Image.asset(
                            "images/head_portraits.jpg",
                            fit: BoxFit.fill,
                          )
                        : Image.network(this._userInfo.avatarUrl,
                            fit: BoxFit.fill),
                  ),
                ),
              )),
          ListTile(title: Text('昵称  ${this._userInfo.nickname}')),
          ListTile(title: Text('性别  ${this._userInfo.gender}')),
          ListTile(title: Text('年龄  ${this._userInfo.age}')),
          ListTile(title: Text('职业  ${this._userInfo.vocation}')),
          ListTile(title: Text('个人标签  ${this._userInfo.personLabel}')),
          new Container(
            child: new CupertinoButton(
              child: Text('点击修改'),
              color: Colors.blue,
              disabledColor: Colors.blue,
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ModifyInformation(),
                  ),
                );
              },
            ),
          )
        ]));
  }
}
