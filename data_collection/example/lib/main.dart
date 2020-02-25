import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'test.dart';

/// APP 内测试指南
/// ====================
/// 这里提供一个测试及演示用的原型 APP 程序。它可以被用来显示 WiFi 数据信息，并且提供刷新功能。
/// 如需在 APP 上进行测试，请参考以下步骤：
///
/// 0. 在相同目录下新建一个 test.dart 文件，定义 runTest() 函数，以设计自己测试用的 App 代码。
///     其他所需的代码也在该文件里写。请务必将这个文件加入 Ignored Files 当中。
///     同时检查 testapp 下的 .flutter-plugins 及 .flutter-plugins-dependencies 是否也加了进去，如无，请补上。
///
/// 1. 功能介绍
///     这个程序主要的功能体现在 MyAppState 类中。这个类由应用类 MyApp 创建，负责控制 App 界面的显示，显示的最终效果由类里的
///     属性 send（bool）及 wifiData（Map<String, int>）决定。前者表示是否要发送消息，后者是 WiFi 数据。
///     程序还内置了一个按钮和一个定时器。
///     MyAppState 类提供了以下接口：
///     （1）void setBoth(Map<String, int> wifi, bool s)
///           通过传入的 Map 更新界面上的 WiFi 列表，并通过传入的 bool 在界面上显示（是否移动）。
///           也可以单独设置 send 或者 wifiData 属性来更新界面，如：
///               send = true;    // 向 setter send 传入 true，然后更新界面显示
///     （2）void buttonClick()
///           按下按钮时会调用的函数。默认调用 WiFi 扫描函数（见下）。如果需要做别的事情，可以对其重载。
///           长按按钮的功能是向系统申请位置权限，以备无权限之时使用。
///           可以通过 buttonText 设置界面文字。
///     （3）Map<String, int> Function() func
///           函数指针，如不为空会被 WiFi 扫描函数调用，以在界面上更新 WiFi 数据。这个函数应该返回一个包含 WiFi 数据的 Map。
///           如果不需要用到，请将其留空。
///     （4）void timeout()
///           定时器周期性调用的函数，默认为 WiFi 扫描函数（见下）。如果需要做别的事情，可以对其重载。
///           通过 startTimer(tick) 和 endTimer() 启停定时器。
///           如果需要周期性地扫描 WiFi 数据并显示，可以将 enableAutoRefresh 设置为 true，但前提是你重载了 func。
///
///     内置的 WiFi 扫描函数会根据情况返回一组 Map 并更新界面。如果指定了 func，那么 Map 的来源就是你的 func；否则，会返回
///     一个空白的 Map，也就是说界面上不会显示一条数据。
///     通过下拉 / 右下角悬浮按钮两种刷新方式，可以手动刷新。刷新时会自动调用 WiFi 扫描函数以获取 WiFi 信息，但不会去获取新
///     的 bool。
///
///     为了方便，MyApp 已经将其内的 MyAppState 类暴露出来（作为 state 成员），因此，你可以在外部直接调用 MyApp 中的
///     update / updateWiFi / updateSend / startTimer / endTimer / setFunc 等函数，以实现界面更新或定时器功能。
///
///     可以继承并修改 MyAppState 类，如果需要的话。然后重载里面的一些函数。
///
///     考虑到拓展性，MyApp 的构造函数需要一个 MyAppState 参数。如果你没有继承 MyAppState，那么 MyAppState() 即可；否则，
///     传入一个子类的实例。
///
/// 2. 写好测试之后，在你的 runTest() 函数里 runApp，以启动 App。例如：
///   runApp(MyApp(MyAppState()));
///
/// 3. 代码写好后，就可以在模拟器或者真机上运行了：
///   Run -> Run.. -> 找到这个 main.dart
///   如果运行的时候扫不出 WiFi，可以试试长按按钮以获取位置权限。为了测试正常进行，建议在真机上测试时到系统设置中给予足够的权限。
///
/// 请注意，这个 main.dart 文件是共用的。如果有其他测试内容的需求，或者发现 bug，请在群里提出。


/// test.dart 示例（试过能跑）
//  import 'package:flutter/cupertino.dart';
//  import 'package:indoor_data_collection/indoor_data_collection.dart';
//  import 'package:testapp/main.dart';
//
//  WiFiCollector collector;
//
//  void runTest() {
//    // 如果开头不是直接 runApp() 就要加上下面这句
//    WidgetsFlutterBinding.ensureInitialized();
//
//    // 创建一个周期为 3 秒的 collector 并开始采集数据
//    collector = new WiFiCollector(setSeconds: 3);
//    // collector.manager = new WiFiDataManager();
//    // collector.manager.sender = new WiFiMessageSender("localhost", "/fingerprint");
//    collector.startCollect();
//
//    // 创建 MyApp 实例并开始运行
//    MyApp app = MyApp(MyAppState());
//    app.setFunc(doScan);            // 设置 MyApp 获取 WiFi 数据的函数
//    app.enableAutoRefresh = true;   // 定时刷新数据
//    app.startTimer(5);              // 启动定时器
//    runApp(app);
//  }
//
//  Map<String, int> doScan() {
//    if (collector != null) return collector.collectWiFi();
//    else return Map<String, int>();
//  }



void main() async => await runTest();


class MyApp extends StatefulWidget {
  MyApp(this.state);
  final MyAppState state;

  @override
  MyAppState createState() => state;

  void startTimer(int tick) => state.startTimer(tick);

  void endTimer() => state.endTimer();

  bool get enableAutoRefresh => state.enableAutoRefresh;
  set enableAutoRefresh(bool r) => state.enableAutoRefresh = r;

  void setFunc(Map<String, int> Function() f) {
    state.func = f;
  }

  void update(Map<String, int> wifi, bool s) {
    state.setBoth(wifi, s);
  }

  void updateWiFi(Map<String, int> wifi) {
    if (state != null)
      state.wifiData = wifi;
  }

  void updateSend(bool s) {
    if (state != null)
      state.send = s;
  }
}


class MyAppState extends State {
  Map<String, int> _wifiData;
  Map<String, int> get wifiData => _wifiData;
  set wifiData(Map<String, int> newData) {
    _wifiData = (newData == null) ? new HashMap() : newData;
    update();
  }

  bool _send = false;
  bool get send => _send;
  set send(bool shouldSend) {
    _send = shouldSend;
    update();
  }

  void setBoth(Map<String, int> wifi, bool s) {
    if (wifi != null) _wifiData = wifi;
    _send = s;
    update();
  }

  Timer _timer;
  int get duration => (_timer == null) ? 0 : _timer.tick;
  set duration(int tick) {
    if (_timer != null) _timer.cancel();    // cancel() can be invoked multiple times for a timer
    _timer = new Timer.periodic(Duration(seconds: tick), (Timer timer) {
      if (func != null && enableAutoRefresh) func();
      timeout();
      update();
    });
  }
  void timeout() => scanHandler();
  void startTimer(int tick) => duration = tick;
  void endTimer() {
    if (_timer != null) _timer.cancel();
  }
  bool enableAutoRefresh = false;

  Map<String, int> Function() func;

  String _buttonText = "ReScan (after prev. scan is finished; await...)";
  String get buttonText => _buttonText;
  set buttonText(String newTxt) {
    _buttonText = newTxt;
    update();
  }
  void buttonClick() { scanHandler(); }

  ListView list = new ListView();

  @override
  void initState() {
    scanHandler();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Iterator<MapEntry> it = wifiData == null ? null : wifiData.entries.iterator;
    if (it != null) it.moveNext();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WiFiHunter Example App'),
        ),
        body: new RefreshIndicator(
            onRefresh: scanHandler,
            child: Center (
                child: Column (
                  children: <Widget>[
                    Text ("Scanning... Please check Log for results..."),
                    RichText(
                      text: TextSpan(
                        text: send ? "Send a message now!" : "no need to send",
                        style: TextStyle(
                            fontWeight: send ? FontWeight.bold : FontWeight.normal,
                            color: send ? Colors.green : Colors.red
                        ),
                      ),
                    ),
                    FlatButton (
                      child: Text (_buttonText),
                      onPressed: buttonClick,
                      onLongPress: getPermission,
                    ),
                    Expanded(
                        child: new ListView.builder(
                          itemBuilder: (context, i) {
                            Text txt = new Text(it.current.key.toString() + " @ " + it.current.value.toString());
                            it.moveNext();
                            return txt;
                          },
                          itemCount: (wifiData != null) ? wifiData.length : 0,
                          shrinkWrap: true,
                        )
                    )
                  ],
                )
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: scanHandler,
          tooltip: "Refresh",
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }

  /// 这个函数会在按下按钮或者下拉刷新时调用
  Future<void> scanHandler() async {
    wifiData = await scanWiFi();
  }

  /// 重载这个函数以返回 WiFi 数据，以便刷新时显示在屏幕上
  Future<Map<String, int>> scanWiFi() async {
    print("Scan wifi");
    if (func != null) return func();
    else return new HashMap();
  }

  void getPermission() async {
    await PermissionHandler().requestPermissions([PermissionGroup.location]);
  }

  void update() {
    setState(() {});
  }
}





/// 下面的内容没有用

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}