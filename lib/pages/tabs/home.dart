import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_flutter_app1/model/location/AP.dart';
import 'package:my_flutter_app1/model/location/APMeta.dart';
import 'package:my_flutter_app1/model/location/LocationRequest.dart';
import 'package:my_flutter_app1/model/location/LocationResult.dart';
import 'package:my_flutter_app1/model/location/LocationServiceTopicResponse.dart';
import 'package:my_flutter_app1/provider/mapProvider.dart';
import 'package:my_flutter_app1/util/commonUtil.dart';
import 'package:my_flutter_app1/util/data_collect/MessageHandler.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:my_flutter_app1/util/websocket_util.dart';
import 'package:my_flutter_app1/widget/LocationMap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quick_log/quick_log.dart';
import 'package:toast/toast.dart';
import 'package:wifi_hunter/wifi_hunter.dart'; // ap数据采集所需插件

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Logger log = Logger("HomePageState");
  GlobalKey<FormState> searchKey = new GlobalKey<FormState>();
  String _search;
  Timer _timer;
  WebSocketUtil _webSocketUtil;

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
  void _indoorLocationSerivce(String metadataId, List<AP> apList) async {
    this._webSocketUtil = new WebSocketUtil();
    this._webSocketUtil.connectWithServer(await getToken(), metadataId);
    // 订阅数据
    this._webSocketUtil.addListener(
      "indoorLocation",
      (value) {
        // TODO 接收逻辑未实现1
      },
    );

    // 发送数据
    this._timer = Timer.periodic(Duration(seconds: 7), (timer) async {
      log.debug(timer.tick.toString());
      _webSocketUtil.sendMessage(
          new LocationRequest(intensities: await _scanAPs(apList)).toJson());
    });
  }

  // 向服务器请求定位服务资源
  void _startLocationRequest(APMeta apMeta) async {
    if (apMeta != null) {
      this._indoorLocationSerivce(apMeta.metaId, apMeta.accessPoints);
    }
  }

  // 请求服务器关闭定位服务资源
  void _stopLocationRequest() async {
    if (this._webSocketUtil != null) {
      _webSocketUtil.removeListener("indoorLocation");
      _webSocketUtil.disconnectWithServer();
      _webSocketUtil = null;
      _timer.cancel();
    }
  }

  void search() {
    var loginForm = searchKey.currentState;
    if (loginForm.validate()) {
      loginForm.save();

      log.debug(_search);
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

  FloatingActionButton _goButtun() {
    if (_webSocketUtil == null) {
      return FloatingActionButton(
        child: Text("Go"),
        onPressed: () async {
          var value = await Navigator.pushNamed(context, '/Go');
          if (value != null) {
            Provider.of<MapProvider>(context, listen: false).clear();
            for (var ap in (value as APMeta).accessPoints) {
              Provider.of<MapProvider>(context, listen: false)
                  .addAP(ap.x, ap.y);
            }
            this._startLocationRequest(value);
          }
        },
      );
    } else {
      return FloatingActionButton(
        child: Text("Stop"),
        backgroundColor: Colors.red,
        onPressed: () async {
          _stopLocationRequest();
          setState(() {});
        },
      );
    }
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
    // _stopLocationRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _goButtun(),
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            child: LocationMap(),
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
                                highlightColor: Colors.black,
                              ),
                            )
                          ],
                        ),
                        height: ScreenUtil().setHeight(150),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.white70, width: 2),
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
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
                                      Provider.of<MapProvider>(context,
                                              listen: false)
                                          .setScaleFactor(4 / 3);
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
                                      Provider.of<MapProvider>(context,
                                              listen: false)
                                          .setScaleFactor(3 / 4);
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
      ),
    );
  }
}
