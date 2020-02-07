import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app1/pages/register.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
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
      JwtToken data = JwtToken.fromJson(utf8JsonDecode(response.bodyBytes));
      
//      print(data.token);

      // 如果解析成功，即登陆成功
      if (data.token != null) {
        Toast.show("登录成功", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);

        // 保存 token
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", data.token);

        //登陆成功，返回主界面。
        Navigator.popAndPushNamed(context, "/tab");
      } else {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
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
                ),
                new GestureDetector(
                    child: new Text(
                      '   注册账号',
                      style: new TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new RegisterPage()));
                    })
              ],
            )
          ],
        ));
  }
}
