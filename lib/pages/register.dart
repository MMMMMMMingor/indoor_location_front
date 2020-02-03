import 'dart:async';

import 'package:flutter/material.dart';
import '../util/validUtil.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _mobile = TextEditingController();
  TextEditingController _veriCode = TextEditingController();
  FocusNode _mobileFocus = FocusNode();
  FocusNode _veriFocus = FocusNode();
  Timer _timer;
  int _start = 60;
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
                            child: Text("邮箱地址",
                                style: TextStyle(
                                  fontSize: 28.0,
                                )),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            focusNode: _mobileFocus,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintText: '请输入邮箱地址',
                              border: InputBorder.none,
                            ),
                            controller: _mobile,
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
                                      onPressed: () {
                                        _mobileFocus.unfocus();
                                        if (_start != 60) {
                                          //简单判断是否可以触发获取验证
                                          return null;
                                        }
                                        var result = validateEmail(
                                            this._mobile.text); //验证手机号
                                        if (result == true) {
                                          print("验证通过");
                                          countdown();
                                        } else {
                                          Scaffold.of(context)
                                              .hideCurrentSnackBar();
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  duration:
                                                      Duration(seconds: 1),
                                                  backgroundColor:
                                                      Colors.orangeAccent,
                                                  content: new Text(
                                                      result.toString())));
                                        }
                                      },
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
                        onPressed: () async {
                          _veriFocus.unfocus();
                          _mobileFocus.unfocus();
                          Scaffold.of(context).hideCurrentSnackBar();
                          Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 1),
                              backgroundColor: Colors.green,
                              content: new Text("注册成功")));
                        },
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
