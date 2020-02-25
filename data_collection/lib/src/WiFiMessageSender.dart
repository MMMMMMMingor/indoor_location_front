/// use MQTT to send messages.

import 'dart:convert';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';

/// 自定义端口可以调用 MqttClient.withPort(服务器地址, 身份标识, 端口号);

class WiFiMessageSender {
  String _wifiMessage;          // 暂存json格式化后的Wifi数据

  final String topic;           // MQTT消息主题
  final String broker;          // MQTT服务器
  final int port;               // 服务器端口
  final int connectTimes;       // 服务器连接次数
  final String defaultIdentifier = "indoor-data-collection";

  MqttClient client;

  bool get connected => client.connectionStatus.state == MqttConnectionState.connected;
  bool _connecting = false;     // connection mutex

  //final MqttClient client = MqttClient('test.mosquitto.org', '');
  //final MqttClient client = MqttClient('39.99.131.85:18083', '');

  WiFiMessageSender(this.broker, this.topic, {this.port = 1883, this.connectTimes = 10, bool autoConnect = true, String identifier})
  {
    String theIdentifier = (identifier == null || identifier == "") ? defaultIdentifier : identifier;   // prevents the identifier from empty
    client = MqttClient.withPort(broker, theIdentifier, port);

    /// 是否开启日志
    client.logging(on: false);

    /// 设置超时时间
    client.keepAlivePeriod = 20;

    client.onDisconnected = onDisconnected; // 设置断开连接的回调
    client.onConnected = onConnected; // 设置连接成功的回调
    client.onSubscribed = onSubscribed; // 订阅的回调
    client.pongCallback = pong; // ping的回调

    if (autoConnect) connect();
  }

  Future<int> connect() async
  {
    // wait if there is another connection
    await _wait();
    // if previous connection success, no further action needed
    if (client.connectionStatus.state == MqttConnectionState.connected)
      return 0;

    _connecting = true;
    /// 客户连接
    int connectResult = connectTimes;//连接的结果
    ///获取连接的结果的函数，连接成功得到-1，出现异常或连接失败得到剩余可连接次数
    while(connectResult > 0){
      connectResult = await tryConnect(connectResult);
    }
    _connecting = false;

    ///判断连接结果
    if(connectResult == -1){
      print("successfully connect");
      return 0;
    }
    else if(connectResult == 0) {
      print("connection time out");
      return 1;
    }
    else {
      print("unknow error");
      return 2;
    }
  }

  Future<int> tryConnect(int remainingTimes) async
  {
    try {
      await client.connect();
      /// 开始连接
    } on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      // client.disconnect();
      return --remainingTimes;
    }

    /// 检查连接结果
    if (client.connectionStatus.state == MqttConnectionState.connected) return -1;
    else return --remainingTimes;
  }

  Future<bool> sendMessage(Map<String, int> data) async {
    // if connecting, wait until the connection attempt completes (whether success or not)
    await _wait();

    if (client.connectionStatus.state != MqttConnectionState.connected) {
      if ((await connect()) != 0) return false;
    }

    _wifiMessage = json.encode(data);
    print(_wifiMessage);
    return send();
  }


  bool send() {
    try{
      ///发送消息给服务器
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(_wifiMessage);

      ///这里传 请求信息的json字符串
      client.publishMessage(topic, MqttQos.exactlyOnce, builder.payload);
      return true;
    }on Exception catch (e) {
      print('EXAMPLE::client exception - $e');
      return false;
    }
  }

  void onSubscribed(String topic) {
    print('EXAMPLE::Subscription confirmed for topic $topic');

    /// 设置 public 监听，当我们调用 publishMessage 时，会告诉你是都发布成功
    client.published.listen((MqttPublishMessage message) {
      print('EXAMPLE::Published notification:: topic is ${message.variableHeader.topicName}, with Qos ${message.header.qos}');
    });

    /// 监听服务器发来的信息
    client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      /// 服务器返回的数据信息
      final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      print( 'EXAMPLE::Change notification:: topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
  }

  void onDisconnected() {
    print('EXAMPLE::OnDisconnected client callback - Client disconnection');
    if (client.connectionStatus.returnCode == MqttConnectReturnCode.solicited) {
      print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
    }
    // exit(-1);
  }

  void onConnected() {
    print('EXAMPLE::OnConnected client callback - Client connection was sucessful');

    /// 订阅一个topic: 服务端定义的事件   当服务器发送了这个消息，就会在 client.updates.listen 中收到
    client.subscribe(topic, MqttQos.exactlyOnce);
  }

  void pong() {
    print('EXAMPLE::Ping response client callback invoked');
  }

  void disconnect() {
    client.unsubscribe(topic);
    client.disconnect();
  }

  Future _wait() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: 200));
      if (!_connecting)
        break;
    }
  }
}