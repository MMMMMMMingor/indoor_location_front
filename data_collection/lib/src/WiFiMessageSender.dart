/// use MQTT to send messages.

part of mqtt_message_handler;

class WiFiMessageSender extends MessageHandler {
  String _wifiMessage;          // 暂存json格式化后的Wifi数据

  String topic;           // MQTT消息主题
  MqttQos qos = MqttQos.exactlyOnce;

  @override
  final String defaultIdentifier = "indoor-data-collection-sender";

  WiFiMessageSender(String broker, this.topic, {int port = 1883, this.qos, int connectTimes = 10, bool autoConnect = true, String identifier})
  : super(broker, port: port, connectTimes: connectTimes, autoConnect: autoConnect, identifier: identifier) {
    _client.onConnected = this._onConnected;
    _client.onDisconnected = this._onDisconnected;
  }

  Future<bool> sendMessage(Map<String, dynamic> data) async {
    // if connecting, wait until the connection attempt completes (whether success or not)
    await _wait();
    if (_client.connectionStatus.state != MqttConnectionState.connected) {
      _log("Sender $identifier trying to send a message but the client is not connected. Going to retry connection");
      if ((await connect()) != 0) return false;
    }
    _wifiMessage = json.encode(data);
    // print(_wifiMessage);
    return _send();
  }

  void _onConnected() {
    log("Sender $identifier connection:");
    super._onConnected();
    _client.published.listen((MqttPublishMessage message) {
      log('Published notification: topic is ${message.variableHeader.topicName}, with Qos ${message.header.qos}');
    });
  }

  void _onDisconnected() {
    log("Sender $identifier disconnection:");
    super._onDisconnected();
  }

  bool _send() {
    try {
      /// 发送消息给服务器
      final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
      builder.addString(_wifiMessage);
      _client.publishMessage(topic, qos, builder.payload);
      return true;
    } on Exception catch (e) {
      log('Client Exception - $e');
      return false;
    }
  }
}