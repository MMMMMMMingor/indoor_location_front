import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_flutter_app1/model/location/AP.dart';
import 'package:my_flutter_app1/model/location/FingerPrintMetadataRequest.dart';
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
  GlobalKey<FormState> _saveKey = new GlobalKey<FormState>();
  List<AP> _accessPoints = <AP>[];
  String _remark = "未命名";
  ListView _detectedWifis = ListView();
  WiFiInfoWrapper _wifiObject;
  bool _loading = true;

  void _sendHttpReuqest() async {
    this.setState(() {
      this._loading = true;
    });

    var saveForm = _saveKey.currentState;
    saveForm.save();

    var request = new FingerPrintMetadataRequest(
        remark: this._remark, accessPoints: this._accessPoints);

    // 获取本地token
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");

    var response = await http.post(Config.url + "api/location/create",
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(request));

    var successAndMessage =
        SuccessAndMessage.fromJson(utf8JsonDecode(response.bodyBytes));

    this.setState(() {
      this._loading = false;
    });

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
    final _formKey = new GlobalKey<FormState>();
    double x;
    double y;

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
                      hintText: '请输入x轴坐标',
                      icon: new Icon(
                        Icons.zoom_out_map,
                        color: Colors.grey,
                      )),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => x = double.parse(value.trim()),
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
                      hintText: '请输入y轴坐标',
                      icon: new Icon(
                        Icons.zoom_out_map,
                        color: Colors.grey,
                      )),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => y = double.parse(value.trim()),
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
                        this
                            ._accessPoints
                            .add(new AP(bssid: bssid, ssid: ssid, x: x, y: y));
                        Navigator.of(context).pop();

                        this.setState(() {
                          _renderWifi();
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
      },
    );
  }

// 移除已经选择的WiFi
  void removeWiFi(String bssid) {
    this._accessPoints.removeWhere((element) => element.bssid == bssid);

    this.setState(() {
      _renderWifi();
    });
  }

  Widget getItem(String bssid, String ssid, int signalStrength) {
    bool selected = false;

    for (var ap in this._accessPoints) {
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
//                    visualDensity:
//                        VisualDensity(horizontal: 0.0, vertical: 0.0),
                  ),
                ),
                Offstage(
                  offstage: !selected,
                  child: FlatButton(
                    color: Colors.red,
                    child: const Text('取消选择'),
//                    visualDensity:
//                        VisualDensity(horizontal: 1.0, vertical: 0.5),
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
  void _detectWifi() async {
    _wifiObject = await WiFiHunter.huntRequest;
    _renderWifi();
  }

  void _renderWifi() async {
    this.setState(
      () {
        this._loading = false;
        this._detectedWifis = ListView.builder(
          itemCount: _wifiObject.bssids.length,
          itemBuilder: (BuildContext context, int position) {
            // 返回WiFi的具体描述
            return getItem(
                _wifiObject.bssids[position],
                _wifiObject.ssids[position],
                _wifiObject.signalStrengths[position]);
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _detectWifi();
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
          new Form(
            key: _saveKey,
            child: Offstage(
              offstage: this._accessPoints.length < 3,
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Text(
                    '备注: ',
                    style: new TextStyle(
                        fontSize: ScreenUtil().setSp(30), color: Colors.grey),
                  ),
                  new SizedBox(
                    width: ScreenUtil().setWidth(400),
                    child: new TextFormField(
                      onSaved: (value) {
                        if (value != "") {
                          this._remark = value;
                        }
                      },
                      style: new TextStyle(
                          fontSize: ScreenUtil().setSp(30), color: Colors.grey),
                      decoration: new InputDecoration(hintText: this._remark),
                    ),
                  )
                ],
              ),
            ),
          ),
          Offstage(
            offstage: this._accessPoints.length < 3,
            child: CupertinoButton(
              color: Colors.green,
              child: Text("完成"),
              onPressed: () {
                _sendHttpReuqest();
              },
            ),
          ),
        ],
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            print("refresh");
            this.setState(() {
              this._loading = true;
              _detectWifi();
            });
          },
        ),
        appBar: AppBar(
          title: Text("至少选择3个AP（${this._accessPoints.length} / 3）"),
          leading: Icon(Icons.wifi),
        ),
        body: stack);
  }
}
