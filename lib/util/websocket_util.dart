import 'dart:convert';

import 'package:my_flutter_app1/model/location/LocationResult.dart';
import 'package:quick_log/quick_log.dart';
import 'package:my_flutter_app1/conf/Config.dart' as Config;
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

typedef Callback = void Function(LocationResult);

class WebSocketUtil {
  Logger log = Logger("WebSocketManager");

  String _metadataId;
  StompClient _client;
  Map<String, Callback> _callbacks = new Map();

  //与服务器建立连接
  void connectWithServer(String token, String metadataId) async {
    log.debug("正在跟服务器建立连接。。。");

    _metadataId = metadataId;

    _client = StompClient(
        config: StompConfig(
      url: Config.WEBSOCKET_URL,
      onConnect: _onConnect,
      stompConnectHeaders: {
        "Authorization": "Bearer $token",
        "metadataId": metadataId
      },
      webSocketConnectHeaders: {
        "Authorization": "Bearer $token"
      },
    ));

    _client.activate();
  }

  dynamic _onConnect(StompClient client, StompFrame frame) {
    client.subscribe(
        destination: '/service/result/' + _metadataId,
        callback: (StompFrame frame) {
          log.debug(frame.body);
          LocationResult result = LocationResult.fromJson(jsonDecode(frame.body));
          _callbacks.forEach((k, v) {
            v(result);
          });
        });
  }

  //断开连接
  void disconnectWithServer() async {
    log.debug("websocket连接断开。。。");
    _client.deactivate();
  }

  //发送消息(json)
  void sendMessage(Map<String, dynamic> data) async {
    // _websocket.send(json.encode(data));
    try {
      _client.send(
          destination: "/service/request/" + _metadataId,
          body: json.encode(data));
    } on NoSuchMethodError {}
  }

  //外部添加监听
  void addListener(String callbackName, Callback callback) {
    if (_callbacks.containsKey(callbackName)) {
      return;
    }
    _callbacks.putIfAbsent(callbackName, () => callback);
  }

  void removeListener(String callbackName) {
    _callbacks.remove(callbackName);
  }
}
