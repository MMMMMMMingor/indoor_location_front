import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_flutter_app1/model/location/AP.dart';
import 'package:my_flutter_app1/model/location/APMeta.dart';
import 'package:my_flutter_app1/model/location/CollectReponse.dart';
import 'package:my_flutter_app1/model/location/LocationRequest.dart';
import 'package:my_flutter_app1/model/location/LocationResult.dart';
import 'package:my_flutter_app1/model/location/LocationServiceTopicResponse.dart';
import 'package:my_flutter_app1/provider/mapProvider.dart';
import 'package:my_flutter_app1/util/commonUtil.dart';
import 'package:my_flutter_app1/model/location/FingerPrintCollectRequest.dart';
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
import 'package:my_flutter_app1/provider/fingetProvider.dart';

class NewFingerCollect extends StatefulWidget {
   final APMeta arguments;
  NewFingerCollect({Key key, this.arguments}) : super(key: key);


  @override
  _NewFingerCollectState createState() => _NewFingerCollectState(arguments: arguments);
}

class _NewFingerCollectState extends State<NewFingerCollect> {
  final APMeta arguments;
  final _formKey = new GlobalKey<FormState>();
  Timer _timer;
  WiFiMessageSender _sender;
  int x, y;
  bool _sending = false;

  _NewFingerCollectState({this.arguments});

  void _startCollectRequest() async {
    // 获取本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    // 获取用户信息
    var response = await http.post(
        Config.url + "api/location/collect/${arguments.metaId}",
        headers: {"Authorization": "Bearer $token"});

    var collectReponse =
        CollectReponse.fromJson(utf8JsonDecode(response.bodyBytes));

    print(collectReponse.toJson());

    // 初始化sender
    _sender = new WiFiMessageSender(Config.MQTT_SERVER_IP, collectReponse.topic,
        qos: MqttQos.exactlyOnce);
  }

  void _stopCollectRequest() async {
    if (this._sender != null) {
      var request = new FingerPrintCollectRequest(finish: true);
      await this._sender.sendMessage(request.toJson());
      this._sender.disconnect();
    }
  }

  // 发送指纹
  void _sendFingerPrint(lastx,lasty) {
    final form = _formKey.currentState;
    form.save();
    print(lastx);
x= int.parse(lastx.toString());
y=int.parse(lasty.toString());
print(x);
print(y);

    if (x < 0 || y < 0) {
      Toast.show("坐标不能为负数", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      return;
    }

    setState(() {
      this._sending = true;
    });
    _scanWifi(recall: (list) {
      _sender.sendMessage(new FingerPrintCollectRequest(
              intensities: list, x: x, y: y, finish: false)
          .toJson());

      Toast.show("发送成功", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
      setState(() {
        this._sending = false;
      });
    });
  }

  void _scanWifi({Function(List<int>) recall}) async {
    WiFiInfoWrapper wifiObject = await WiFiHunter.huntRequest;

    if (recall != null) {
      var aps = this.arguments.accessPoints;
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

      print(intensities);

      recall(intensities);
    }
  }

  List<Widget> _generateAPInfo() {
    var result = <Widget>[];

    for (var ap in this.arguments.accessPoints) {
      result.add(
        Card(
          child: ListTile(
            leading: Icon(Icons.wifi_tethering),
            title: Text("${ap.ssid}"),
            subtitle: Text("${ap.bssid}"),
            trailing: Text("X: ${ap.x}  Y: ${ap.y} "),
          ),
        ),
      );
    }

    return result;
  }

void showTips(){
   Toast.show("请长按屏幕添加指纹", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.TOP);
}
  @override
  void initState() {
    super.initState();
    // _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
    //   print(timer.tick);
    //   _scanWifi(arguments.bssid1, arguments.bssid2, arguments.bssid3);
    //   this.setState(() {});
    // });
    _scanWifi();
    _startCollectRequest();
showTips();
  }

  @override
  void dispose() {
    super.dispose();
    if (this._timer != null) this._timer.cancel();
    _stopCollectRequest();
  }
  @override
  Widget build(BuildContext context) {
        FingerProvider fingerProvider = Provider.of<FingerProvider>(context);//引入的单实例
    return Scaffold(
       appBar: AppBar(
        title: Text("添加指纹"),
      ),
        floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
         _sendFingerPrint(fingerProvider.lastPosition.dx, fingerProvider.lastPosition.dy);

        },
      ),
        resizeToAvoidBottomPadding: false,
        body: Padding(padding: EdgeInsets.all(0),
            child: Container(
            child: CollectFingerMap(),
            color: Colors.white,
   
          ),
        ),
      
    );
  
     
  }
}
