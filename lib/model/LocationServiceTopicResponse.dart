class LocationServiceTopicResponse {
  String describe;
  String receiveTopic;
  String sendTopic;
  bool success;

  LocationServiceTopicResponse(
      {this.describe, this.receiveTopic, this.sendTopic, this.success});

  LocationServiceTopicResponse.fromJson(Map<String, dynamic> json) {
    describe = json['describe'];
    receiveTopic = json['receiveTopic'];
    sendTopic = json['sendTopic'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['describe'] = this.describe;
    data['receiveTopic'] = this.receiveTopic;
    data['sendTopic'] = this.sendTopic;
    data['success'] = this.success;
    return data;
  }
}
