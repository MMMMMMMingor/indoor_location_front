import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:indoor_data_collection/indoor_data_collection.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:my_flutter_app1/model/location/APMeta.dart';
import 'package:my_flutter_app1/model/location/CollectReponse.dart';
import 'package:my_flutter_app1/model/location/FingerPrintCollectRequest.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:wifi_hunter/wifi_hunter.dart'; // ap数据采集所需插件
import 'package:http/http.dart' as http;
import 'package:my_flutter_app1/conf/Config.dart' as Config;

class CollectFingerPrint extends StatefulWidget {
  final APMeta arguments;

  const CollectFingerPrint({Key key, this.arguments}) : super(key: key);

  _CollectFingerPrintState createState() =>
      _CollectFingerPrintState(arguments: arguments);
}

class _CollectFingerPrintState extends State<CollectFingerPrint> {
  final APMeta arguments;
  final _formKey = new GlobalKey<FormState>();
  Timer _timer;
  WiFiMessageSender _sender;
  int x, y;
  bool _sending = false;

  _CollectFingerPrintState({this.arguments});

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
  void _sendFingerPrint() {
    setState(() {
      this._sending = true;
    });
    _scanWifi(recall: (list) {
      final form = _formKey.currentState;
      form.save();
      _sender.sendMessage(new FingerPrintCollectRequest(
              intensities: list, x: x, y: y, finish: false)
          .toJson());

      Toast.show("发送成功", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
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
  }

  @override
  void dispose() {
    super.dispose();
    if (this._timer != null) this._timer.cancel();
    _stopCollectRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.arguments.remark),
      ),
      resizeToAvoidBottomPadding: false,
      body: Padding(
        padding: EdgeInsets.all(0),
        child: Form(
          key: this._formKey,
          child: Container(
            child: Column(
              children: <Widget>[
                Column(
                  children: _generateAPInfo(),
                ),
                Container(
                  constraints: BoxConstraints.expand(
                    height: ScreenUtil().setHeight(140),
                    width: ScreenUtil().setWidth(300),
                  ),
                  child: Card(
                    child: TextFormField(
                      onSaved: (newValue) => this.x = int.parse(newValue),
                      maxLines: 1,
                      strutStyle: StrutStyle(
                        fontSize: ScreenUtil().setSp(5),
                        height: ScreenUtil().setHeight(10),
                      ),
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请输入当前X轴坐标',
                        labelText: "当前X轴坐标",
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        ),
                        isDense: false,
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints.expand(
                    height: ScreenUtil().setHeight(140),
                    width: ScreenUtil().setWidth(300),
                  ),
                  child: Card(
                    child: TextFormField(
                      onSaved: (newValue) => this.y = int.parse(newValue),
                      maxLines: 1,
                      strutStyle: StrutStyle(
                        fontSize: ScreenUtil().setSp(5),
                        height: ScreenUtil().setHeight(10),
                      ),
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      style: TextStyle(fontSize: ScreenUtil().setSp(24)),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '请输入当前Y轴坐标',
                        labelText: "当前Y轴坐标",
                        icon: Icon(
                          Icons.location_on,
                          color: Colors.grey,
                        ),
                        isDense: false,
                      ),
                    ),
                  ),
                ),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: _sending ? const Text('发送中。。。') : const Text('发送'),
                  visualDensity: VisualDensity(horizontal: 1.0, vertical: 0.5),
                  onPressed: _sending ? null : _sendFingerPrint,
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Color(0XFFF0F0F0),
            ),
          ),
        ),
      ),
    );
  }
}
