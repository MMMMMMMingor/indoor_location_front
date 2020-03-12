/// MQTT handler base class
library mqtt_message_handler;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

part 'MessageReceiver.dart';
part 'WiFiMessageSender.dart';

enum Qos { atMostOnce, atLeastOnce, exactlyOnce, notSubscribe }

class MessageHandler {
  String _broker;
  String get broker => _broker;
  set broker(String newBroker) {
    if (newBroker.compareTo(_broker) == 0) {
      _log("Client $identifier is already using broker $newBroker");
    } else {
      _log(
          "Client $identifier is trying to replace broker $_broker by $newBroker. Pleace reconnect later");
      _client.disconnect();
      _client.server = newBroker;
    }
  }

  int _port;
  int get port => _port;
  set port(int newPort) {
    if (newPort == _port) {
      _log("Client $identifier is already using port $newPort");
    } else {
      _log(
          "Client $identifier is trying to switch to port $newPort from $_port.  Pleace reconnect later");
      _client.disconnect();
      _client.port = newPort;
    }
  }

  final String defaultIdentifier =
      "indoor-data-collection"; // gets overridden by children
  String get identifier => _client.clientIdentifier;

  MqttServerClient _client;

  bool get connected =>
      _client.connectionStatus.state == MqttConnectionState.connected;
  bool _connecting = false; // connection mutex

  final int connectTimes;

  Function(String) _log = print;
  set log(Function(String) logFunc) {
    if (logFunc == null)
      _log = print;
    else
      _log = logFunc;
  }

  Function(String) get log => _log;

  MessageHandler(this._broker,
      {int port = 1883,
      this.connectTimes = 10,
      bool autoConnect = true,
      String identifier}) {
    _port = (port < 0) ? 1883 : port;
    String theIdentifier = (identifier == null || identifier == "")
        ? defaultIdentifier
        : identifier; // prevents the identifier from empty
    _client = MqttServerClient.withPort(_broker, theIdentifier, _port);
    _client.logging(on: false);
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = _onDisconnected; // 设置断开连接的回调
    _client.onConnected = _onConnected; // 设置连接成功的回调
    // _client.pongCallback = _pong; // ping的回调

    if (autoConnect) connect();
  }

  Future<int> connect() async {
    // wait if there is another connection
    if (_connecting) await _wait();
    // if connected, no further action needed
    if (_client.connectionStatus.state == MqttConnectionState.connected) {
      _log("Client $identifier is already connected");
      return 0;
    }

    _log("Client $identifier trying to connect");
    _connecting = true;

    /// 客户连接
    int connectResult = connectTimes; //连接的结果
    /// 获取连接的结果的函数，连接成功得到-1，出现异常或连接失败得到剩余可连接次数
    while (connectResult > 0) {
      connectResult = await _tryConnect(connectResult);
    }
    _connecting = false;

    /// 判断连接结果
    if (connectResult == -1) {
      // print("successfully connect");
      return 0;
    } else if (connectResult == 0) {
      _log(
          "Not connected: Maximum reattempt times {$connectTimes} have exceeded");
      return 1;
    } else {
      // print("unknown error");
      return 2;
    }
  }

  Future<int> _tryConnect(int remainingTimes) async {
    try {
      await _client.connect();

      /// 开始连接
    } on Exception catch (e) {
      _log('Client Exception: $e');
      // client.disconnect();
      return --remainingTimes;
    }

    /// 检查连接结果
    if (_client.connectionStatus.state == MqttConnectionState.connected)
      return -1;
    else
      return --remainingTimes;
  }

  void disconnect() => _client.disconnect();

  Future _wait() async {
    while (true) {
      await Future.delayed(Duration(milliseconds: 200));
      if (!_connecting) break;
    }
  }

  void _pong() => _log('Ping response client callback invoked');

  void _onConnected() => _log('Connection to $_broker:$_port confirmed');

  void _onDisconnected() {
    _log('Disconnected from $_broker:$_port confirmed');
    if (_client.connectionStatus.returnCode == MqttConnectReturnCode.solicited)
      _log('OnDisconnected callback is solicited, this is correct');
  }
}
