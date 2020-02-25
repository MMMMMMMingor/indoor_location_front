/// collect raw wifi data.
import 'dart:collection';                                     // HashMap()所需插件
import 'package:wifi_hunter/wifi_hunter.dart';                // ap数据采集所需插件
import 'package:permission_handler/permission_handler.dart';  // 权限管理
//import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';                                          // 定时器所需插件
import 'WiFiDataManager.dart';                                // 把数据传给小贱

class WiFiCollector {
  WiFiInfoWrapper _wifiObject;
  Map<String, int> _data;
  List<String> knownAPs;

  int setSeconds;
  final int defaultSeconds = 5;
  Timer _timer;
  bool _isCollecting = false;

  WiFiDataManager manager;    // public, can be set freely

  WiFiCollector({this.setSeconds, this.manager, this.knownAPs});

  Future<void> collectWiFiHelp() async {
    try {
      _wifiObject = await WiFiHunter.huntRequest;
    } on PlatformException {}

    Map<String, int> data = new HashMap();

    if (knownAPs == null || knownAPs.isEmpty) {
      for (var i = 0; i < _wifiObject.ssids.length; i++) {
        String mac = _wifiObject.bssids[i];
        int rssi = _wifiObject.signalStrengths[i];
        data[mac] = rssi;
        print(mac + " - " + rssi.toString());
      }
    } ///如果knownAPs为空，可以选择将扫描到的全部AP发送出去
    else {
      for (var i = 0; i < knownAPs.length; i++) {
        String mac = knownAPs[i];
        int index = _wifiObject.bssids.indexOf(knownAPs[i]);
        int rssi = (index >= 0) ? _wifiObject.signalStrengths[index] : 0;
        data[mac] = rssi;
        print(mac + " - " + rssi.toString());
      }
    }

    // sort
    // var entries = data.entries.toList(growable: false);
    // entries.sort((MapEntry<String, int> a, MapEntry<String, int> b) => a.key.compareTo(b.key));
    // _data = Map<String, int>.fromEntries(entries);
    _data = data;
    print('scan done');
  }

  Map<String, int> collectWiFi() {
    if (_data != null) return _data;
    else return new HashMap();
  }

  void collectionTimer() {
    if (setSeconds < 0) setSeconds = defaultSeconds;
    final period = Duration(seconds: setSeconds);
    _timer = Timer.periodic(period, (timer) async {
      await collectWiFiHelp();
      if (manager != null) manager.addData(_data);
    });
  }

  void startCollect() async {
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.location]);
    print(permissions[PermissionGroup.location]);
    if (permissions[PermissionGroup.location] == PermissionStatus.granted) {
      _isCollecting = true;
      collectionTimer();
    }
  }

  void setTimer(int duration) {
    setSeconds = duration;
    if (_isCollecting) {
      stopCollect();
      collectionTimer();
    }
  }

  void stopCollect() {
    if (_timer != null) {
      _timer.cancel();
      _isCollecting = false;
      _timer = null;
    }
  }

}