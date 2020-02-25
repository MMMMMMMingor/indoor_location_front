import 'package:flutter/cupertino.dart';
import 'package:indoor_data_collection/indoor_data_collection.dart';
import 'package:exmaple/main.dart';

WiFiCollector collector;
WiFiDataManager manager;
WiFiMessageSender sender;

// Map<String, int> map;

Future<void> runTest() async {
  // 如果开头不是直接 runApp() 就要加上下面这句
  WidgetsFlutterBinding.ensureInitialized();

  sender = new WiFiMessageSender("39.99.131.85", "/fingerprint", port: 1883);   // autoConnect
  await Future.delayed(Duration(seconds: 3));                                   // wait for a while
  
    // edit your knownAPs and replace the following
  // var apList = [
  //   "00:2f:d9:ab:c0:f7",
  //   "1c:fa:68:36:5f:8e",
  //   "b6:6b:fc:3f:e8:91",
  //   "e4:d3:32:94:a5:ac",
  //   "88:88:88:88:87:88"
  // ];

  // 创建一个周期为 5 秒的 collector 并开始采集数据
  collector = new WiFiCollector(setSeconds: 5);
  // collector.knownAPs = apList;
  collector.manager = new WiFiDataManager(preprocess: false);
  collector.manager.sender = sender;
  collector.startCollect();

  // 创建 MyApp 实例并开始运行
  MyApp app = MyApp(MyAppState2());
  app.setFunc(doScan);            // 设置 MyApp 获取 WiFi 数据的函数
  app.enableAutoRefresh = true;   // 定时刷新数据
  app.startTimer(5);              // 启动定时器
  runApp(app);
}

Map<String, int> doScan() {
  if (collector != null) return collector.collectWiFi();
  else return Map<String, int>();
}

/// test class
class MyAppState2 extends MyAppState {
  int aa = 0;

  @override
  void buttonClick() {
    // first click: clear knownAPs, collect all
    // second click: disconnect, stop sending
    switch (aa) {
      case 0:
        collector.knownAPs = null;
        aa = 1;
        break;
      case 1:
        collector.manager.sender.disconnect();
        collector.manager.sender = null;
        aa = 2;
        break;
      default:
        break;
    }
  }
}