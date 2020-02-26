import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app1/model/AP.dart';
import 'package:my_flutter_app1/model/ThreeAPs.dart';
import 'package:my_flutter_app1/model/successAndMessage.dart';
import 'package:my_flutter_app1/util/commonUtil.dart';
import 'package:my_flutter_app1/util/jsonUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:wifi_hunter/wifi_hunter.dart'; // ap数据采集所需插件
import 'package:http/http.dart' as http;
import 'package:my_flutter_app1/conf/Config.dart' as Config;

class CreateLocationService extends StatefulWidget {
  CreateLocationService({Key key}) : super(key: key);

  @override
  _CreateLocationServiceState createState() => _CreateLocationServiceState();
}

class _CreateLocationServiceState extends State<CreateLocationService> {
  List<AP> _apList = <AP>[];
  ListView _detectedWifis = ListView();
  bool _loading = true;

  void sendHttpReuqest() async {
    this._loading = true;
    this.setState(() { });

    ThreeAPs _threeAPs =
        new ThreeAPs(ap1: _apList[0], ap2: _apList[1], ap3: _apList[2]);

    // 获取本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.post(Config.url + "/api/location/create",
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(_threeAPs));

    print(response.body);

    SuccessAndMessage successAndMessage =
        SuccessAndMessage.fromJson(utf8JsonDecode(response.bodyBytes));

    print(successAndMessage.toJson());

    this._loading = false;
    this.setState(() { });

    if (successAndMessage.success == true) {
      Toast.show("添加成功", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
      Navigator.of(context).pop();
    } else {
      Toast.show("添加失败，请稍后再尝试", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
    }
  }

  // 添加选择的WiFi
  void addWiFi(String bssid, String ssid) {
    if (this._apList.length < 3) {
      final _formKey = new GlobalKey<FormState>();
      int x;
      int y;

      showDialog<Null>(
          context: context,
          builder: (BuildContext context) {
            return Form(
              key: _formKey,
              child: new SimpleDialog(
                title: new Text('填写该AP的坐标信息'),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      style: TextStyle(fontSize: 15),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入x轴坐标（整数）',
                          icon: new Icon(
                            Icons.zoom_out_map,
                            color: Colors.grey,
                          )),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => x = int.parse(value.trim()),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 0.0, 0.0),
                    child: new TextFormField(
                      maxLines: 1,
                      autofocus: false,
                      style: TextStyle(fontSize: 15),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          hintText: '请输入y轴坐标（整数）',
                          icon: new Icon(
                            Icons.zoom_out_map,
                            color: Colors.grey,
                          )),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => y = int.parse(value.trim()),
                    ),
                  ),
                  ButtonBar(
                    children: <Widget>[
                      FlatButton(
                        child: const Text('确定'),
                        onPressed: () {
                          final form = _formKey.currentState;

                          try {
                            form.save();
                          } catch (e) {
                            showMessageDialog("填写信息有误，或者不完整", context);
                          }

                          if (x != null && y != null) {
                            this._apList.add(
                                new AP(bssid: bssid, ssid: ssid, x: x, y: y));
                            Navigator.of(context).pop();

                            this.setState(() {
                              this._loading = true;
                              detectWifi();
                            });
                          }
                        },
                      ),
                      FlatButton(
                        child: const Text('取消'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
    }
  }

// 移除已经选择的WiFi
  void removeWiFi(String bssid) {
    this._apList.removeWhere((element) => element.bssid == bssid);

    this.setState(() {
      this._loading = true;
      detectWifi();
    });
  }

  Widget getItem(String bssid, String ssid, int signalStrength) {
    bool selected = false;

    for (var ap in this._apList) {
      if (ap.bssid == bssid) selected = true;
    }

    return Center(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.wifi),
              title: Text(ssid),
              subtitle: Text(bssid),
              trailing: Text("信号强度: ${signalStrength.toString()}"),
              selected: selected,
            ),
            ButtonBar(
              children: <Widget>[
                Offstage(
                  offstage: selected,
                  child: FlatButton(
                    color: Colors.blue,
                    child: const Text('选择WiFi'),
                    onPressed: () => addWiFi(bssid, ssid),
                    visualDensity:
                        VisualDensity(horizontal: 0.0, vertical: 0.0),
                  ),
                ),
                Offstage(
                  offstage: !selected,
                  child: FlatButton(
                    color: Colors.red,
                    child: const Text('取消选择'),
                    visualDensity:
                        VisualDensity(horizontal: 1.0, vertical: 0.5),
                    onPressed: () {
                      removeWiFi(bssid);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 扫描附近的WiFi
  void detectWifi() async {
    WiFiInfoWrapper wifiObject = await WiFiHunter.huntRequest;

    this.setState(() {
      this._loading = false;
      this._detectedWifis = new ListView.builder(
          itemCount: wifiObject.bssids.length,
          itemBuilder: (BuildContext context, int position) {
            // 返回WiFi的具体描述
            return getItem(
                wifiObject.bssids[position],
                wifiObject.ssids[position],
                wifiObject.signalStrengths[position]);
          });
    });
  }

  @override
  void initState() {
    super.initState();
    detectWifi();
  }

  @override
  Widget build(BuildContext context) {
    // Stack 叠加页面
    Widget stack = Stack(
      alignment: const FractionalOffset(0.5, 0.7),
      children: <Widget>[
        Container(
            decoration: BoxDecoration(color: Colors.grey[200]),
            child: this._detectedWifis),
        Offstage(
          offstage: !this._loading,
          child: Center(
            child: CupertinoActivityIndicator(radius: 40.0, animating: true),
          ),
        )
      ],
    );
    return Scaffold(
        persistentFooterButtons: <Widget>[
          Offstage(
            offstage: this._apList.length < 3,
            child: CupertinoButton(
              color: Colors.green,
              child: Text("完成"),
              onPressed: () {
                sendHttpReuqest();
              },
            ),
          ),
        ],
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            this.setState(() {
              this._loading = true;
              detectWifi();
            });
          },
        ),
        appBar: AppBar(
          title: Text("选择3个附近的wifi（${this._apList.length} / 3）"),
          leading: Icon(Icons.network_wifi),
        ),
        body: stack);
  }
}
