import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_flutter_app1/model/location/AP.dart';
import 'package:my_flutter_app1/model/location/APMeta.dart';
import 'package:my_flutter_app1/model/location/LocationRequest.dart';
import 'package:my_flutter_app1/model/location/LocationResult.dart';
import 'package:my_flutter_app1/model/location/LocationServiceTopicResponse.dart';
import 'package:my_flutter_app1/pages/widget/DrawBoard.dart';
import 'package:my_flutter_app1/util/commonUtil.dart';
import 'package:my_flutter_app1/util/data_collect/MessageHandler.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app1/conf/Config.dart' as Config;
import 'package:wifi_hunter/wifi_hunter.dart'; // ap数据采集所需插件

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<FormState> searchKey = new GlobalKey<FormState>();
  String _search;
  Timer _timer;
  MessageReceiver _receiver;
  WiFiMessageSender _sender;
  DrawBoard _drawBoard = DrawBoard();

  _HomePageState();

  Future<List<int>> _scanAPs(List<AP> aps) async {
    WiFiInfoWrapper wifiObject = await WiFiHunter.huntRequest;

    int apLen = aps.length;
    int wifiLen = wifiObject.bssids.length;
    List<int> intensities = new List(apLen);

    L1:
    for (int i = 0; i < apLen; ++i) {
      for (int j = 0; j < wifiLen; ++j) {
        if (aps[i].bssid == wifiObject.bssids[j]) {
          intensities[i] = wifiObject.signalStrengths[j];
          continue L1;
        }
      }
      intensities[i] = 0;
    }

    return Future.value(intensities);
  }

  // 定位服务
  void _indoorLocationSerivce(
      String sendTopic, String receiveTopic, List<AP> apList) async {
    this._sender = new WiFiMessageSender(Config.MQTT_SERVER_IP, sendTopic,
        qos: MqttQos.exactlyOnce);
    this._receiver = new MessageReceiver(Config.MQTT_SERVER_IP);
    this._receiver.connect();

    // 订阅数据
    this._receiver.subscribe(
      receiveTopic,
      callOnData: (value) {
        Toast.show(value, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
        var result = LocationResult.fromJson(jsonDecode(value));
        print(result);
        this._drawBoard.addTrace(result.x, result.y);
      },
    );

    // 发送数据
    this._timer = Timer.periodic(Duration(seconds: 7), (timer) async {
      print(timer.tick);
      _sender.sendMessage(new LocationRequest(
              intensities: await _scanAPs(apList), finish: false)
          .toJson());
    });
  }

  // 向服务器请求定位服务资源
  void _startLocationRequest(APMeta apMeta) async {
    if (apMeta != null) {
      // 获取本地token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString("token");

      // 获取用户信息
      var response = await http.post(
          Config.url + "api/location/service/${apMeta.metaId}",
          headers: {"Authorization": "Bearer $token"});

      var topics = LocationServiceTopicResponse.fromJson(
          utf8JsonDecode(response.bodyBytes));

      print(topics.toJson());

      this._indoorLocationSerivce(
          topics.sendTopic, topics.receiveTopic, apMeta.accessPoints);
    }
  }

  // 请求服务器关闭定位服务资源
  void _stopLocationRequest() async {
    if (this._sender != null) {
      _receiver.disconnect();
      _timer.cancel();
      await this
          ._sender
          .sendMessage(new LocationRequest(finish: true).toJson());
      this._sender.disconnect();
    }
  }

  void search() {
    var loginForm = searchKey.currentState;
    if (loginForm.validate()) {
      loginForm.save();

      print(_search);
      //由于没有和后端对接，点击之后直接返回
      Navigator.pop(context);
    }
  }

  _dialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("注意!"),
          content: Text("请输入地址"),
          actions: <Widget>[
            FlatButton(
              child: Text("确定"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void _getPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
  }

  @override
  void initState() {
    super.initState();
    _getPermission();
    validateLogin(context);
  }

  @override
  void dispose() {
    super.dispose();
    _stopLocationRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Text("Go"),
          onPressed: () async {
            var value = await Navigator.pushNamed(context, '/Go');
            _stopLocationRequest();
            if (value != null) {
              this._drawBoard.clear();
              for (var ap in (value as APMeta).accessPoints) {
                this._drawBoard.addAP(ap.x, ap.y);
              }
              this._startLocationRequest(value);
            }
          },
        ),
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            Container(
              child: _drawBoard,
              height: ScreenUtil().setHeight(1600),
              width: ScreenUtil().setWidth(1080),
            ),
            Container(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                flex: 5,
                                child: Form(
                                  key: searchKey,
                                  child: TextFormField(
                                    obscureText: true,
                                    validator: (value) {
                                      return value.length < 1
                                          ? _dialog()
                                          : Navigator.pushNamed(
                                              context, '/Search_result');
                                    },
                                    onSaved: (value) {
                                      _search = value;
                                    },
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(50)),
                                    decoration: InputDecoration.collapsed(
                                      border: InputBorder.none,
                                      hintText: "搜索地址",
                                      hintStyle: TextStyle(),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: IconButton(
                                    icon: Icon(Icons.search),
                                    padding: EdgeInsets.all(10.0),
                                    iconSize: 30,
                                    onPressed: () {
                                      search();
                                    },
                                    color: Colors.blueAccent,
                                    highlightColor: Colors.black),
                              )
                            ],
                          ),
                          height: ScreenUtil().setHeight(150),
                          decoration: BoxDecoration(
                              color: Colors.white70,
                              border:
                                  Border.all(color: Colors.white70, width: 2),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                        ),
                        Expanded(flex: 2, child: Container()),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: ScreenUtil().setWidth(80),
                                height: ScreenUtil().setHeight(300),
                                child: Column(
                                  children: <Widget>[
                                    RaisedButton(
                                      onPressed: () {
                                        this._drawBoard.setScaleFactor(4 / 3);
                                      },
                                      color: Colors.white,
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        "+",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(50)),
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        this._drawBoard.setScaleFactor(3 / 4);
                                      },
                                      color: Colors.white,
                                      padding: EdgeInsets.all(5.0),
                                      child: Text(
                                        "-",
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(50)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(),
                              ),
                              // Padding(
                              //   padding: EdgeInsets.fromLTRB(
                              //       0, 0, ScreenUtil().setWidth(5), 0),
                              //   child: Container(
                              //     width: ScreenUtil().setWidth(70),
                              //     height: ScreenUtil().setHeight(70),
                              //     decoration: BoxDecoration(
                              //       color: Colors.white70,
                              //       border: Border.all(
                              //           color: Colors.black, width: 1),
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(
                              //             ScreenUtil().setWidth(150)),
                              //       ),
                              //     ),
                              //     child: Center(
                              //       child: IconButton(
                              //         icon: Icon(Icons.adjust),
                              //         padding: EdgeInsets.all(4.0),
                              //         iconSize: 30,
                              //         onPressed: () {
                              //           Navigator.pushNamed(context, "/draw");
                              //         },
                              //         color: Colors.blueAccent,
                              //         highlightColor: Colors.blueAccent,
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                          height: ScreenUtil().setHeight(300),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
