import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app1/model/userInfo.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../personInformation.dart';
import '../friendTab.dart';
import '../myCar.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import '../../conf/Config.dart' as Config;

class MinePage extends StatefulWidget {
  @override
  _MinePageState createState() => new _MinePageState();
}

class _MinePageState extends State<MinePage> {
  // 用户信息
  UserInfo _userInfo;

  void getUserInfo() async {
    // 获取本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    // 若 token存在
    if (token != null) {
      // 获取用户信息
      var response = await http.get(Config.url + "api/user/info",
          headers: {"Authorization": "Bearer $token"});
      UserInfo userInfo = UserInfo.fromJson(utf8JsonDecode(response.bodyBytes));
//      print(userInfo.toJson());

      // 判断token是否过期
      if (userInfo.userId != null) {
        this.setState(() {
          this._userInfo = userInfo;
        });
        return;
      }
    }

    Toast.show("请先登录", context,
        duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);

    Navigator.pushNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    if(this._userInfo==null){
      print('下载');
      getUserInfo();
    }
  }


  @override
  Widget build(BuildContext context) {
    var card = new SizedBox(
        height: 360.0,
        child: new Card(
            child: new Column(children: <Widget>[
              new ListTile(
                title: new Text(
                  '收藏',
                  style: new TextStyle(fontWeight: FontWeight.w300),
                ),
                leading: new Icon(
                  Icons.star_border,
                  color: Colors.lightBlue,
                ),
              ),
              new Divider(),
              new ListTile(
                title: new Text(
                  '我的车辆',
                  style: new TextStyle(fontWeight: FontWeight.w300),
                ),
                leading: new Icon(
                  Icons.directions_car,
                  color: Colors.lightBlue,
                ),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => new MyCar()));
                  //跳转到我的车辆界面
                },
              ),
              new Divider(),
              new ListTile(
                title: new Text(
                  '我的店铺',
                  style: new TextStyle(fontWeight: FontWeight.w300),
                ),
                leading: new Icon(
                  Icons.shopping_cart,
                  color: Colors.lightBlue,
                ),
              ),
              new Divider(),
              new ListTile(
                title: new Text(
                  '消息',
                  style: new TextStyle(fontWeight: FontWeight.w300),
                ),
                leading: new Icon(
                  Icons.message,
                  color: Colors.lightBlue,
                ),
              ),
              new Divider(),
              new ListTile(
                title: new Text(
                  '好友',
                  style: new TextStyle(fontWeight: FontWeight.w300),
                ),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => new FriendTab()));
                  //跳转到好友列表界面
                },
                leading: new Icon(
                  Icons.people_outline,
                  color: Colors.lightBlue,
                ),
              ),
            ])));
    return Scaffold(
      body: Container(
          child: ListView(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/mineBack.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(12),
                      child: new GestureDetector(
                          child: new ClipOval(
                            child: new SizedBox(
                              width: 120,
                              height: 120,
                              child: this._userInfo == null
                                  ? Image.asset(
                                'images/head_portraits.jpg',
                                fit: BoxFit.fill,
                              )
                                  : Image.network(this._userInfo.avatarUrl,
                                  fit: BoxFit.fill),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => new PersonInformation()));
                          }),
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Text(
                            this._userInfo == null ? '  ' :this._userInfo.nickname,
                            style: new TextStyle(color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Text(
                          '我的个人空间',
                          style: new TextStyle(color: Colors.white,
                              fontWeight: FontWeight.w300
                          ),)
                      ],
                    )
                  ],
                ),
              ),

              card,
            ],
          )),
    );
  }

}
