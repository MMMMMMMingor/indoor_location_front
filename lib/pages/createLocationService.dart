import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_flutter_app1/model/ThreeAPs.dart';
import 'package:wifi_hunter/wifi_hunter.dart'; // ap数据采集所需插件

class CreateLocationService extends StatefulWidget {
  CreateLocationService({Key key}) : super(key: key);

  @override
  _CreateLocationServiceState createState() => _CreateLocationServiceState();
}

class _CreateLocationServiceState extends State<CreateLocationService> {
  ThreeAPs _threeAPs;
  ListView _detectedWifis;
  bool _loading = true;

  Widget getItem(String bssid, String ssid, int signalStrength) {
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
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: const Text('选择WiFi'),
                  onPressed: () {
                    print("选择WiFi");
                  },
                ),
                FlatButton(
                  child: const Text('取消选择'),
                  onPressed: () {/* ... */},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void detectWifi() async {
    WiFiInfoWrapper wifiObject = await WiFiHunter.huntRequest;

    this.setState(() {
      this._loading = false;
      this._detectedWifis = new ListView.builder(
          itemCount: wifiObject.bssids.length,
          itemBuilder: (BuildContext context, int position) {
            // return ListTile (title:Text(friendList[position].name),);
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
            ))
      ],
    );

    return Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.refresh),
          onPressed: () {
            this.setState(() {
              this._loading = true;
            });
            detectWifi();
          },
        ),
        appBar: AppBar(
          title: Text("wifi列表"),
        ),
        body: stack);
  }
}
