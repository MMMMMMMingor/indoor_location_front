import 'dart:async';

import 'package:flutter/material.dart';
import 'package:indoor_data_collection/indoor_data_collection.dart';
import 'package:my_flutter_app1/model/location/APMeta.dart';
import 'package:my_flutter_app1/model/location/CollectReponse.dart';
import 'package:my_flutter_app1/model/location/FingerPrintCollectRequest.dart';
import 'package:my_flutter_app1/model/location/FingerPrintMetaDetail.dart';
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
  FingerPrintMetaDetail _metaDetail;
  Timer _timer;
  WiFiMessageSender _sender;
  List<int> _apSignalList;
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
    _sender =
        new WiFiMessageSender(Config.MQTT_SERVER_IP, collectReponse.topic);
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
      print(x);
      print(y);
      _sender.sendMessage(
          new FingerPrintCollectRequest(intensities: list, x: x, y: y, finish: false).toJson());

      Toast.show("发送成功", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      this._sending = false;
    });
  }

  void _scanWifi({Function(List<int>) recall}) async {
    WiFiInfoWrapper wifiObject = await WiFiHunter.huntRequest;
    int len = wifiObject.bssids.length;

    // for (int i = 0; i < len; ++i) {
    //   if (wifiObject.bssids[i] == arguments.bssid1)
    //     _ap1Signal = wifiObject.signalStrengths[i];
    //   if (wifiObject.bssids[i] == arguments.bssid2)
    //     _ap2Signal = wifiObject.signalStrengths[i];
    //   if (wifiObject.bssids[i] == arguments.bssid3)
    //     _ap3Signal = wifiObject.signalStrengths[i];
    // }

    if (recall != null) recall(wifiObject.signalStrengths);

    print("刷新wifi信号 \n ${_apSignalList.join("  ")}");
    this.setState(() {});
  }

  void _getDetailMessage() async {
    // 获取本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    // 获取用户信息
    var response = await http.get(
        Config.url + "api/location/meta/detail/${arguments.metaId}",
        headers: {"Authorization": "Bearer $token"});

    FingerPrintMetaDetail metaDetail =
        FingerPrintMetaDetail.fromJson(utf8JsonDecode(response.bodyBytes));

    print(metaDetail.toJson());
    this._metaDetail = metaDetail;

    setState(() {});
  }

  Column _generateAPInfo() {

    if (this._metaDetail != null) {
      return Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.wifi_tethering),
              title: Text("${this._metaDetail.accessPoints[0].ssid}"),
              subtitle: Text(
                  "${this._metaDetail.accessPoints[0].bssid}         当前信号： "),
              trailing: Text(
                  "X: ${this._metaDetail.accessPoints[0].x}  Y: ${this._metaDetail.accessPoints[0].y} "),
            ),
          ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Card(
            child: ListTile(
              leading: Icon(Icons.wifi_tethering),
              title: Text("${this.arguments.accessPoints}"),
            ),
          ),
        ],
      );
    }
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
    _getDetailMessage();
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
                _generateAPInfo(),
                Container(
                  constraints: BoxConstraints.expand(
                    height: 100,
                    width: 300,
                  ),
                  child: Center(
                    child: Card(
                      child: TextFormField(
                        onSaved: (newValue) => this.x = int.parse(newValue),
                        maxLines: 1,
                        strutStyle: StrutStyle(
                          fontSize: 5,
                          height: 10,
                        ),
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        style: TextStyle(fontSize: 30),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入X轴坐标',
                          labelText: "X轴坐标",
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          isDense: false,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  constraints: BoxConstraints.expand(
                    height: 100,
                    width: 300,
                  ),
                  child: Center(
                    child: Card(
                      child: TextFormField(
                        onSaved: (newValue) => this.y = int.parse(newValue),
                        maxLines: 1,
                        strutStyle: StrutStyle(
                          fontSize: 5,
                          height: 10,
                        ),
                        keyboardType: TextInputType.number,
                        autofocus: false,
                        style: TextStyle(fontSize: 30),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入Y轴坐标',
                          labelText: "Y轴坐标",
                          icon: Icon(
                            Icons.location_on,
                            color: Colors.grey,
                          ),
                          isDense: false,
                        ),
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
