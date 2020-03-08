import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app1/model/successAndMessage.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:my_flutter_app1/util/validUtil.dart';
import 'package:toast/toast.dart';
import '../conf/Config.dart' as Config;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = new GlobalKey<FormState>();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _verifyCode = TextEditingController();
  FocusNode _usernameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confirmPasswordFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _veriFocus = FocusNode();
  Timer _timer;
  int _start = 60;

  //倒计时
  void countdown() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel(); //定时器清除
            _start = 60;
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  // 发送验证邮件
  void sendEmail() async {
    _emailFocus.unfocus();
    if (_start != 60) {
      //简单判断是否可以触发获取验证
      return null;
    }
    var result = validateEmail(this._email.text); //验证邮箱
    if (result == true) {
      // 获取发送验证码
      var response = await http
          .post(Config.url + "api/email/verifyCode/${this._email.text}");
      SuccessAndMessage data =
          SuccessAndMessage.fromJson(utf8JsonDecode(response.bodyBytes));

      if (data.success == true) {
        Toast.show("验证码已发送至${this._email.text}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        countdown();
      } else {
        Toast.show("验证码发送失败", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
    } else {
      Toast.show("邮箱不能为空，或者邮箱格式错误", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    }
  }

  // 发送注册请求
  void sendRegisterRequest() async {
    _veriFocus.unfocus();
    _emailFocus.unfocus();
    // Scaffold.of(context).hideCurrentSnackBar();

    bool noNull = this._username.text.isEmpty ||
        this._password.text.isEmpty ||
        this._confirmPassword.text.isEmpty ||
        this._email.text.isEmpty ||
        this._verifyCode.text.isEmpty;
    if (noNull) {
      Toast.show("请填写所有注册信息", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    bool passwordConfirm =
        this._password.text.compareTo(this._confirmPassword.text) == 0;
    if (!passwordConfirm) {
      Toast.show("两次输入的密码不一致", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    // 发送注册请求
    var response = await http.post(Config.url + "api/user/register",
        headers: {"Content-Type": "application/json"}, body: """
            {
              "email": "${this._email.text}",
              "password": "${this._password.text}",
              "username": "${this._username.text}",
              "verifyCode": ${this._verifyCode.text}
            }
          """);
    SuccessAndMessage data =
        SuccessAndMessage.fromJson(utf8JsonDecode(response.bodyBytes));

    if (data.success == true) {
      Toast.show("注册成功", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      Navigator.pop(context);
    } else {
      Toast.show("注册失败，${data.message}", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    }
  }

  Widget _showUserInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        focusNode: _usernameFocus,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(fontSize: ScreenUtil().setSp(33)),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入帐号',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        controller: _username,
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
        focusNode: _passwordFocus,
        style: TextStyle(fontSize: ScreenUtil().setSp(33)),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请输入密码',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        controller: _password,
      ),
    );
  }

  Widget _showPasswordInputAgain() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        focusNode: _confirmPasswordFocus,
        style: TextStyle(fontSize: ScreenUtil().setSp(33)),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '请再输入密码',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        controller: _confirmPassword,
      ),
    );
  }

  Widget _showEmailInput() {
    return Container(
        padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
        child: new Form(
            child: new Row(children: <Widget>[
          new SizedBox(
            width: ScreenUtil().setWidth(500),
            child: TextFormField(
              maxLines: 1,
              autofocus: false,
              style: TextStyle(fontSize: ScreenUtil().setSp(33)),
              focusNode: _emailFocus,
              decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: '请输入邮箱',
                  icon: new Icon(
                    Icons.email,
                    color: Colors.grey,
                  )),
              controller: _email,
            ),
          ),
          new Container(
            height: ScreenUtil().setHeight(100),
            child: new OutlineButton(
              child: Text(_start == 60 ? "获取验证码" : "$_start S",
                  style: TextStyle(fontSize: ScreenUtil().setSp(33))),
              textColor: Colors.orange,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              borderSide: BorderSide(color: Colors.orange, width: 1),
              onPressed: () {
                sendEmail();
              },
            ),
          )
        ])));
  }

  Widget _showYzmInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        focusNode: _veriFocus,
        controller: _verifyCode,
        keyboardType: TextInputType.number,
        autofocus: false,
        style: TextStyle(fontSize: ScreenUtil().setSp(33)),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: '验证码',
            icon: new Icon(
              Icons.fingerprint,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty || value.length != 6) {
            return '请输入验证码';
          }
          return null;
        },
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
              height: 170,
              child: Image.network(
                  'https://i2.hdslb.com/bfs/face/bcdf640faa16ebaacea1d4c930baabaec9087a80.jpg@50w_50h.webp',
                  fit: BoxFit.fitHeight),
            ),
            Form(
              key: _formKey,
              child: Container(
                height: 310,
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
                      Divider(
                        height: 0.5,
                        indent: 16.0,
                        color: Colors.grey[300],
                      ),
                      _showPasswordInputAgain(),
                      Divider(
                        height: 0.5,
                        indent: 16.0,
                        color: Colors.grey[300],
                      ),
                      _showEmailInput(),
                      Divider(
                        height: 0.5,
                        indent: 16.0,
                        color: Colors.grey[300],
                      ),
                      _showYzmInput(),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 70,
              padding: const EdgeInsets.fromLTRB(35, 30, 35, 0),
              child: OutlineButton(
                child: Text('注册'),
                textColor: Colors.orange,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                borderSide: BorderSide(color: Colors.orange, width: 1),
                onPressed: () {
                  sendRegisterRequest();
                },
              ),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    // 消除定时器
    super.dispose();
    _timer.cancel();
  }
}
