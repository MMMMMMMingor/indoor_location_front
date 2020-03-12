/// receiver class
part of mqtt_message_handler;

class MessageReceiver extends MessageHandler {
  Map<String, Function(String)> _topics = new HashMap();
  List<String> get topics => _topics.keys.toList();

  Function(String message, String topic) onData;

  @override
  final String defaultIdentifier = "indoor-data-collection-receiver";

  MessageReceiver(String broker, {int port = 1883, int connectTimes = 10, bool autoConnect = true, String identifier, this.onData})
  : super(broker, port: port, connectTimes: connectTimes, autoConnect: autoConnect, identifier: identifier) {
    _client.onConnected = this._onConnected;
    _client.onDisconnected = this._onDisconnected;
    _client.onSubscribed = this._onSubscribed;
    _client.onUnsubscribed = this._onUnsubscribed;
  }

  Future<bool> subscribe(String topic, {Function(String) callOnData, Qos qos = Qos.exactlyOnce}) async {
    if (_topics.containsKey(topic)) return true;
    else {
      await _wait();
      if (_client.connectionStatus.state != MqttConnectionState.connected) {
        _log("Receiver $identifier trying to subscribe but the client is not connected. Going to retry connection");
        if ((await connect()) != 0) return false;
      }
      bool success = (_client.subscribe(topic, MqttQos.values[qos.index]) != null);
      if (success) _topics[topic] = callOnData;
      return success;
    }
  }

  void unsubscribe(String topic) {
    if (!_topics.containsKey(topic) || _client.connectionStatus.state != MqttConnectionState.connected) return;
    _client.unsubscribe(topic);
    _topics.remove(topic);
  }

  bool isSubscribed(String topic) => _client.getSubscriptionsStatus(topic) == MqttSubscriptionStatus.active;

  void _onConnected() {
    log("Receiver $identifier connection:");
    super._onConnected();
    /// 监听服务器发来的信息
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload;
      /// 服务器返回的数据信息
      final String pt = MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      /// 向 onData 传递信息
      if (onData != null) onData(c[0].topic, pt);
      if (_topics.containsKey(c[0].topic) && _topics[c[0].topic] != null) _topics[c[0].topic](pt);
      log('OnData: topic is <${c[0].topic}>, payload is <-- $pt -->');
    });
  }

  void _onDisconnected() {
    log("Receiver $identifier disconnection:");
    super._onDisconnected();
    _topics.clear();
    log('Receiver $identifier\'s subscription list cleared');
  }

  void _onSubscribed(String topic) => _log('Subscription confirmed for topic $topic');

  void _onUnsubscribed(String topic) => _log('Unsubscription confirmed for topic $topic');
}