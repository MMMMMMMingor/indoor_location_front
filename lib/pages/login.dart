import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../conf/Config.dart' as Config;
import '../model/jwtToken.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();
  String userName;
  String password;

  void login() async {
    var loginForm = loginKey.currentState;
    if (loginForm.validate()) {
      loginForm.save();

      var response = await http.post(Config.url + "auth/$userName/$password");
      var data = JwtToken.fromJson(json.decode(response.body));

      print(data.token);
      if (data != null) {
        Toast.show("登录成功", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);

        // 保存 token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", data.token);

        //登陆成功，返回主界面。
        Navigator.pop(context);
      }else{
        Toast.show("登录失败", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('登录'),
        ),
        body: new Column(
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.all(16.0),
                child: new Form(
                  key: loginKey,
                  child: new Column(
                    children: <Widget>[
                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: '请输入用户名',
                        ),
                        onSaved: (value) {
                          userName = value;
                        },
                        onFieldSubmitted: (value) {},
                      ),
                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: '请输入密码',
                        ),
                        obscureText: true,
                        validator: (value) {
                          return value.length < 6 ? "密码长度不够6位" : null;
                        },
                        onSaved: (value) {
                          password = value;
                        },
                      )
                    ],
                  ),
                )),
            new SizedBox(
              width: 340.0,
              height: 50.0,
              child: new CupertinoButton(
                onPressed: login,
                color: Colors.blue,
                disabledColor: Colors.blue,
                child: new Text(
                  '登录',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            )
          ],
        ));
  }
}
