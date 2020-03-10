import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app1/model/jwtToken.dart';
import 'package:my_flutter_app1/pages/register.dart';
import 'package:my_flutter_app1/util/commonUtil.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import '../conf/Config.dart' as Config;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = new GlobalKey<FormState>();

  String _userName;
  String _password;
  bool _logining = false;

  void _onLogin() async {
    setState(() {
      this._logining = true;
    });

    final form = _formKey.currentState;
    form.save();

    if (_userName == '') {
      showMessageDialog('账号不可为空', context);
      return;
    }
    if (_password == '') {
      showMessageDialog('密码不可为空', context);
      return;
    }

    var response = await http.post(Config.url + "auth/$_userName/$_password");
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

    setState(() {
      this._logining = false;
    });
  }

  Widget _showUserInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入帐号',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        onSaved: (value) => _userName = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(fontSize: ScreenUtil().setSp(30)),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入密码',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CupertinoNavigationBar(
          backgroundColor: Colors.white,
          middle: const Text('登录'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 30),
              height: ScreenUtil().setHeight(400),
              child: Image.network(
                  'https://i2.hdslb.com/bfs/face/bcdf640faa16ebaacea1d4c930baabaec9087a80.jpg@50w_50h.webp',
                  fit: BoxFit.fitHeight),
            ),
            Form(
              key: _formKey,
              child: Container(
                height: ScreenUtil().setHeight(330),
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      _showUserInput(),
                      Divider(
                        height: 0.5,
                        indent: 16.0,
                        color: Colors.grey[300],
                      ),
                      _showPasswordInput(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(200),
              padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
              child: OutlineButton(
                child: this._logining ? Text('登录中。。。') : Text('登录'),
                textColor: Colors.orange,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                borderSide: BorderSide(color: Colors.orange, width: 1),
                onPressed: this._logining ? null : _onLogin,
              ),
            ),
            Container(
              height: ScreenUtil().setHeight(200),
              padding: const EdgeInsets.fromLTRB(200, 30, 35, 0),
              child: GestureDetector(
                  child: new Text(
                    '注册账号',
                    style: new TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new RegisterPage()));
                  }),
            )
          ],
        ));
  }
}
