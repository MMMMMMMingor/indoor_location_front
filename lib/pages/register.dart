import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_flutter_app1/model/successAndMessage.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:toast/toast.dart';
import '../util/validUtil.dart';
import 'package:http/http.dart' as http;
import '../conf/Config.dart' as Config;

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _confrimPassword = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _veriCode = TextEditingController();
  FocusNode _usernameFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  FocusNode _confrimPasswordFocus = FocusNode();
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
      var response = await http.post(Config.url + "api/email/verifyCode/${this._email.text}");
      SuccessAndMessage data = SuccessAndMessage.fromJson(utf8JsonDecode(response.bodyBytes));

      if(data.success == true){
        Toast.show("验证码已发送至${this._email.text}", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        countdown();
      }else{
        Toast.show("验证码发送失败", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      }
      
    } else {
      Toast.show("邮箱不能为空，或者邮箱格式错误", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    }
  }

  // 发送注册请求
  void sendRegisterRequest() async{
    _veriFocus.unfocus();
    _emailFocus.unfocus();
    // Scaffold.of(context).hideCurrentSnackBar();

    bool noNull = this._username.text.isEmpty 
                  || this._password.text.isEmpty
                  || this._confrimPassword.text.isEmpty
                  || this._email.text.isEmpty
                  || this._veriCode.text.isEmpty;
    if(noNull){
      Toast.show("请填写所有注册信息", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    bool passwordConfirm = this._password.text.compareTo(this._confrimPassword.text) == 0;
    if(!passwordConfirm){
      Toast.show("两次输入的密码不一致", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    // 发送注册请求
    var response = await http.post(Config.url + "api/user/register", 
    headers: {"Content-Type" : "application/json"},
    body: """
            {
              "email": "${this._email.text}",
              "password": "${this._password.text}",
              "username": "${this._username.text}",
              "verifyCode": ${this._veriCode.text}
            }
          """);
    SuccessAndMessage data = SuccessAndMessage.fromJson(utf8JsonDecode(response.bodyBytes));

    if(data.success == true){
      Toast.show("注册成功", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      Navigator.pop(context);
    }else{
      Toast.show("注册失败，${data.message}", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("注册"),
        ),
        body: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "images/head_portraits.jpg",
                      width: 444,
                      height: 300,
                    ),
                  ),
                ),
                Container(
                    width: 710,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 160,
                          child: Center(
                            child: Text("账号",
                                style: TextStyle(
                                  fontSize: 28.0,
                                )),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _usernameFocus,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: '请输入账号',
                              border: InputBorder.none,
                            ),
                            controller: _username,
                          ),
                        )
                      ],
                    ))
                    ,Container(
                    width: 710,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 160,
                          child: Center(
                            child: Text("密码",
                                style: TextStyle(
                                  fontSize: 28.0,
                                )),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _passwordFocus,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: '请输入密码',
                              border: InputBorder.none,
                            ),
                            controller: _password,
                          ),
                        )
                      ],
                    )),
                    Container(
                    width: 710,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 160,
                          child: Center(
                            child: Text("确认密码",
                                style: TextStyle(
                                  fontSize: 28.0,
                                )),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _confrimPasswordFocus,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: '再一次输入密码',
                              border: InputBorder.none,
                            ),
                            controller: _confrimPassword,
                          ),
                        )
                      ],
                    )),
                Container(
                    width: 710,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Color(0xFFF2F2F2),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 160,
                          child: Center(
                            child: Text("邮箱地址",
                                style: TextStyle(
                                  fontSize: 28.0,
                                )),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _emailFocus,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: '请输入邮箱地址',
                              border: InputBorder.none,
                            ),
                            controller: _email,
                          ),
                        )
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    width: 710,
                    height: 90,
                    child: Row(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xFFF2F2F2),
                          ),
                          width: 444,
                          height: 90,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                width: 160,
                                child: Center(
                                  child: Text("验证码",
                                      style: TextStyle(
                                        fontSize: 28.0,
                                      )),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  focusNode: _veriFocus,
                                  controller: _veriCode,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    hintText: "请输入验证码",
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if (value.isEmpty || value.length != 6) {
                                      return '请输入验证码';
                                    }
                                    return null;
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 15.0),
                                child: Builder(builder: (BuildContext context) {
                                  return FlatButton(
                                      onPressed: sendEmail,
                                      color: _start == 60
                                          ? Colors.blue
                                          : Colors.grey,
                                      textColor: _start == 60
                                          ? Colors.white
                                          : Colors.black54,
                                      child: Container(
                                        height: 80,
                                        child: Center(
                                          child: Text(_start == 60
                                              ? "获取验证码"
                                              : "$_start S"),
                                        ),
                                      ));
                                })))
                      ],
                    )),
                Container(
                    margin: EdgeInsets.only(top: 20.0),
                    width: 300,
                    height: 90,
                    child: Builder(builder: (context) {
                      return FlatButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: sendRegisterRequest,
                        child: Container(
                          width: 710,
                          height: 90,
                          child: Center(
                            child: Text(
                              "注册",
                              style: TextStyle(fontSize: 28.0),
                            ),
                          ),
                        ),
                      );
                    })),
              ],
            )),
        resizeToAvoidBottomPadding: false);
  }

  @override
  void dispose() {
    //定时器清除
    _timer?.cancel();
    super.dispose();
  }
}
