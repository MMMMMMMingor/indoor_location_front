import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_flutter_app1/model/location/AP.dart';
import 'package:my_flutter_app1/model/location/APMeta.dart';
import 'package:my_flutter_app1/model/location/LocationRequest.dart';
import 'package:my_flutter_app1/model/location/LocationResult.dart';
import 'package:my_flutter_app1/model/location/LocationServiceTopicResponse.dart';
import 'package:my_flutter_app1/provider/mapProvider.dart';
import 'package:my_flutter_app1/util/commonUtil.dart';
import 'package:my_flutter_app1/util/data_collect/MessageHandler.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:my_flutter_app1/widget/LocationMap.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app1/conf/Config.dart' as Config;
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:wifi_hunter/wifi_hunter.dart'; // ap数据采集所需插件
import 'package:my_flutter_app1/widget/CollectFingerMap.dart';

class NewFingerCollect extends StatefulWidget {
  NewFingerCollect({Key key}) : super(key: key);

  @override
  _NewFingerCollectState createState() => _NewFingerCollectState();
}

class _NewFingerCollectState extends State<NewFingerCollect> {
  GlobalKey<FormState> searchKey = new GlobalKey<FormState>();
  String _search;
  Timer _timer;
  MessageReceiver _receiver;
  WiFiMessageSender _sender;

  _NewFingerCollectState();

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
        var loactionResult = LocationResult.fromJson(jsonDecode(value));
        print(loactionResult);
        Provider.of<MapProvider>(context, listen: false)
            .addTrace(loactionResult.x, loactionResult.y);
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
    return Container(
            child: CollectFingerMap(),
            color: Colors.white,
            height: ScreenUtil().setHeight(1600),
            width: ScreenUtil().setWidth(1080),
          );
     
  }
}
